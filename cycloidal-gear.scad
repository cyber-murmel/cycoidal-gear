use <cycloidal-disc.scad>;



module cycloidal_gear(
    r=50, // rirg radius
    n_p = 8, // number of pins
    ecc=3, // eccentricity
    d_p=5, // outer pin diameter
    d_bo = 17, // bearing outside diameter
    d_s = 5, // spoke pin diameter
    r_s = 50*2/3, // spoke radius
    n_s = 8-1, // number of spokes
    steps=360) {
    difference() {
        cycloidal_disc(r, n_p, ecc, d_p, steps);
        circle(d=d_bo);
        for (a = [0:360/n_s:360-1]) {
            rotate(a) {
                translate([r_s, 0]){
                    circle(r=d_s/2+ecc);
                }
            }
        }
    }
}

cycloidal_gear();
