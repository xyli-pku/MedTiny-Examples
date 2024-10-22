typedef {GREEN, YELLOW, RED} as Color; //equivalent to int 0..2
typddef Color.GREEN as myGreen;
typedef int 0..255 as uint8;
typedef int 0..2**32-1 as uint32;
typedef uint8[24] as tcp_header;
typedef (tcp_header,uint8[2**16-25]) as tcp_packet;
typedef {numberator:int;denominator:int;} as Rational;
typedef {real_part:real;imaginary_part:real;} as Complex_Number;

const 3.14159265 as PI;
const 27.18E-1 as euler;
const [PI,2.718] as magic;
const "Hello" as greeting;
const 2**4096 as largeNum;