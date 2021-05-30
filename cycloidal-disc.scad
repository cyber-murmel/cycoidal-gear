module cycloid(r=50, n=10, ecc=3, steps=$fn) {
    render() {
        polygon([ for (a = [0:360/steps:360])
            [
                r * cos(a) + ecc * cos(n * a),
                r * sin(a) + ecc * sin(n * a)
            ]
        ]);
    }
}

module cycloidal_disc(r=50, n=10, ecc=3, d_o=5, steps=360) {
    // substract offset outline from cycloid
    difference(){
        cycloid(r, n, ecc, steps);
        // offset outline
        minkowski() {
            // generate outline
            difference(){
                minkowski() {
                    cycloid(r, n, ecc, steps);
                    circle(r=0.0001);
                }
                cycloid(r, n, ecc, steps);
            }
            circle(d=d_o);
        }
    }
}

cycloidal_disc();