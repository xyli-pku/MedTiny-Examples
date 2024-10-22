const 120 as x;
const 36 as y; // input values
function <len:int> fill(value:int):int[len];
//fill function is a built-in
function <max:int> bounded_gcd(x,y:int 1..max):int { 
    temps {
        bool found = false;
    }
    statements {
        (x, y) = (x < y)?(x, y):(y, x);
        for _ in fill<2*((int)math.log<2>(max)+1)>(0) {
            //gcd will definitely terminate 
            //in this many steps
            found=y==0;
            (x, y) = found?(x,y):(y, y%x);
        }
        return x;
    }
}

