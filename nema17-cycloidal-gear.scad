// motor shaft diameter
d_m = 5;
// height of the D flat of the shaft measured from the OD
h_flat = 0.5;
// bearing inside diameter
d_bi= 9;

// rirg radius
r = sqrt(2)*31/2;
// number of pins
n_p = 8; // [3:100]
// eccentricity
ecc = (d_bi-d_m)/2; // [0.1:0.1:10]
//ecc = (d_bi-d_m)/2; // [0.1:0.1:10]
// outer pin diameter
d_p = 5;
// bearing outside diamter
d_bo = 16;
// spoke pin diameter
d_s = 5;
// spoke radius
r_s = r*2/3;
// number of spokes
n_s = n_p-1;
// part (0 = all)
part = 0; // [0:6]
// render
do_render = false;

explode = max(0, min(12*abs($t-0.5)-0.5, 5)); // [0:0.1:9]

// circle resolution
$fn=90;

use <./cycloidal-gear.scad>;
include <./NopSCADlib/vitamins/ball_bearings.scad>;


module countersunk_hole(d, d_o, h, center=false) {
    union() {
        translate([0, 0, center ? -h/2 : 0]) {
            cylinder(d1=d_o, d2=0, h=d_o/2);
            cylinder(d=d, h=h);
        }
    }
}

module upper_disk(r, d_bo, r_s, n_s) {
    difference() {
        cylinder(d=2*r-d_p, h=5, center=true);
        cylinder(d=d_bo, h=6, center=true);
        for (a = [0:360/n_s:360-1]) {
            rotate(a) {
                translate([r_s, 0, 3]){
                    rotate([180])
                    countersunk_hole(d=3.2, d_o=8, h=6);
                }
                translate([r_s, 0, -2.5]){
                    cylinder(d=d_p, h=5, center=true);
                }
            }
            rotate(180+a) {
                translate([r_s, 0])
                cylinder(d=2.5, h=6, center=true);
            }
        }
    }
}

module lower_disk(r, d_bo, r_s, n_s) {
    difference() {
        cylinder(d=2*r-d_p, h=5, center=true);
        cylinder(d=d_bo, h=6, center=true);
        for (a = [0:360/n_s:360-1]) {
            rotate(a) {
                translate([r_s, 0]){
                    cylinder(d=2.5, h=6, center=true);
                    cylinder(d=5, h=5);
                }
            }
        }
    }
}

module output(r, d_p, d_s, r_s){
    if($preview)
        color("#b5a642")
            linear_extrude(10, center=true)
                for (a = [0:360/n_s:360-1]) {
                    rotate(a) {
                        translate([r_s, 0]){
                            circle(d=d_s);
                        }
                    }
                }
    translate([0, 0, 5]*(1+explode)) {
        color("#b5a642")
            upper_disk(r, d_bo, r_s, n_s);
        if($preview)
            ball_bearing(BB625);
    }
    translate([0, 0, -5]*(1+explode)) {
        color("#b5a642")
            lower_disk(r, d_bo, r_s, n_s);
        if($preview)
            ball_bearing(BB625);
    }
}


module upper_cage(r, n_p) {
    render()
    difference() {
        cylinder(d=2*r+7.5, h=5, center=true);
        cylinder(d=2*r-7.5, h=6, center=true);
        for (a = [0:360/n_p:360-1]) {
            rotate(a) {
                translate([r, 0, 3]){
                    rotate([180])
                    countersunk_hole(d=3.2, d_o=8, h=6);
                }
                translate([r, 0, -2.5]){
                    cylinder(d=d_p, h=5, center=true);
                }
            }
        }
    }
}

module lower_cage(r, n_p) {
    mirror([0, 0, 1])
        difference() {
            cylinder(d=2*r+7.5, h=5, center=true);
                cylinder(d=22, h=6, center=true);
            for (a = [0:360/n_p*2:360-1]) {
                rotate(a) {
                    translate([r, 0]){
                        cylinder(d=2.5, h=6, center=true);
                    }
                }
            }
            for (a = [360/n_p:360/n_p*2:360-1]) {
                rotate(a) {
                    translate([r, 0]){
                        cylinder(d=3.2, h=6, center=true);
                    }
                }
            }
            for (a = [360/n_p:360/n_p:360]) {
                rotate(a) {
                    translate([r, 0, -2.5]){
                        cylinder(d=d_p, h=5, center=true);
                    }
                }
            }
        cylinder(d=22, h=5);
        }
}

module cage(r, n_p, d_p) {
    linear_extrude(20, center=true)
        for (a = [0:360/n_p: 360-1]) {
            rotate(a) {
                translate([r, 0]*(1+explode/2)){
                    circle(d=d_p, $fn=45);
                }
            }
        }
}

module d_shaft(d, h_flat) {
    difference() {
        circle(d=d);
        translate([d-h_flat, 0])
            square([d, d], center=true);
    }
}

module eccentric_disc(d_m, h_flat, d_bi, ecc) {
    linear_extrude(5, center=true)
        difference() {
            translate([ecc, 0])
                circle(d=d_bi);
            d_shaft(d_m, h_flat);
        }
}

module hub(r, d_m, r_s, n_s) {
    linear_extrude(5, center=true)
        difference() {
            circle(d=2*r-8);
            circle(d=d_m+1);
            for (a = [360/n_s/2:360/n_s:360-1]) {
                rotate(a) {
                    translate([r_s, 0]){
                        circle(d=3.2);
                    }
                }
            }
        }
    translate([0, 0, 2.5]) {
        cylinder(d=d_m+1, h=0.2, center=true);
        difference()    {
            cylinder(d1=2*r_s-8, d2=2*r_s-8-2*5, h=5);
            cube([4.8, 1.8, 11], center=true);
            cube([1.8, 4.8, 11], center=true);
        }
    }
}

module rendering() {
    rotate($t*360*(n_p-1)) {
        color("#7b9095")
            linear_extrude(5, center=true)        
                translate([-ecc, 0])
                    rotate(-$t*360*n_p)
                        cycloidal_gear(r, n_p, ecc, d_p, d_bo, d_s, r_s, n_s);
        if($preview)
            translate([-ecc, 0])
                ball_bearing(BB689);
    }

    rotate(-$t*360)
        output(r, d_p, d_s, r_s);

    translate([0, 0, 10]*(1+explode*1.5))
        rotate(-$t*360)
          color("#b5a642")
            hub(r, d_m, r_s, n_s);

    color("#b87333") {
      cage(r, n_p, d_p);
        translate([0, 0, -10]*(1+explode))
            lower_cage(r, n_p);

        translate([0, 0, 10]*(1+explode))
            upper_cage(r, n_p);
    }

    rotate($t*360*(n_p-1)-180)
        color("#50C878") 
            eccentric_disc(d_m, h_flat, d_bi, ecc);
}

module part1() {
    lower_cage(r, n_p);
}

module part2() {
    lower_disk(r, d_bo, r_s, n_s);
}

module part3() {
    linear_extrude(5, center=true)
        cycloidal_gear(r, n_p, ecc, d_p, d_bo, d_s, r_s, n_s);
}

module part4() {
        eccentric_disc(d_m, h_flat, d_bi, ecc);
}

module part5() {
    rotate([180])
        upper_disk(r, d_bo, r_s, n_s);
}

module part6() {
    rotate([180])
        upper_cage(r, n_p);
}

if (do_render) {
    rendering();
}
else {
    if (1 == part)
        part1();
    if (2 == part)
        part2();
    if (3 == part)
        part3();
    if (4 == part)
        part4();
    if (5 == part)
        part5();
    if (6 == part)
        part6();
    if (0 == part) {
        translate([0, 0])
            part1();
        translate([50, -5])
            part2();
        translate([90, 20])
            part3();
        translate([45, 45])
            part4();
        translate([-5, 50])
            part5();
        translate([45, 45])
            part6();
    }
}
