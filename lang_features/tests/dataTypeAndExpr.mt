const 2*4096 as smallNum;
const 2**4096 as largeNum;
typedef int 0 .. 255 as ubyte;
typedef ubyte[1] as ubytelist;
const "Hello, world!" as hello;
typedef {
      nested:ubytelist[1],
      nestednested:ubytelist[1][1]
} as nestedType;

const 3.141592653589793238 as PI;
const 27.18E-1 as euler;
const [PI,2.718] as magic;

typedef {Working, Idle} as Status;

function <e,d:int> testArithParsing (a:ubyte, b:ubyte) : ubyte {
    temporaries {
        ubyte c=1;
        int 1..11 x=2;
        real r=1;
        real r2= 1;
        int 1..2 u= 3;
        int -1..5 u2= -2;
        int -2 ** 255-1 .. 2**255 bound_test=0;
        (int,bool) y=(2,1);
        nestedType[1] nested=[
        {nested:[[1]],
         nestednested:[[[1]]]}
        ];
    }
    statements {
        b = 0;
        b = 0x1;
        bound_test = 0x1FFfad;
        b = 'a';
        b = true;
        b = false;
        b = null;
        b = a;
        r = PI * 2;
        y = (1, true);
        r2 = 3.1e-1;

        //nested[1].nestednested[0][true][false]=1;
        //x = 12;
        return a + d;
    }
}