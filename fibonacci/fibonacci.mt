//import defaults;
//function <n:int> fibonacci():int {
//    temps {
//        int[n] fib=defaults.array<int,n,0>();
//    }
//    statements {
//        for i in n {
//            fib[i]=i==0?0:
//                   i==1?1:
//                   fib[i-1]+fib[i-2];
//        }
        /* With n==3, the above for loop unfolds to
            fib[0]=(0==0||0==1)?1:
                   fib[0-1]+fib[0-2];
            fib[1]=(1==0||1==1)?1:
                   fib[1-1]+fib[1-2];
            fib[2]=(2==0||2==1)?1:
                   fib[2-1]+fib[2-2];
        */
//        return fib[n-1];
//    }
//}

function fibonacci10(n:int 0..9):int {
    temps {
        int[10] fib=[0,0,0,0,0,0,0,0,0,0];
    }
    statements {
        for i in n {
            fib[i]=i==0?0:
                   i==1?1:
                   fib[i-1]+fib[i-2];
        }
        return fib[n];
    }
}

const 10 as maxlen;
function fill0():int[maxlen] {
    statements {
        for i in maxlen {
            retVal[i]=0;
        }
        return retVal;
    }
}
function fibonacci(n:int 0..maxlen-1):int {
    temps {
        int[maxlen] fib=fill0();
    }
    statements {
        for i in maxlen {
            fib[i]=i==0?0:
                   i==1?1:
                   fib[i-1]+fib[i-2];
        }
        return fib[n];
    }
}

function <n:int> fibrec():int {
    statements {
        return n>2?
               fibrec<n-2>()+fibrec<n-1>():
                   n==1||n==0?1:0;
    }
}