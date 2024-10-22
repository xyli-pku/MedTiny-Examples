//sum of two numbers
function sum2(a,b:int):int { 
    statements {
        return a+b;
    }
}

//swap two integers with a temperory
function swapnum(a,b:int):(int,int) { 
    temporaries {
        int c=0;
    }
    statements {
        c=a;
        a=b;
        b=c;
        return (a,b);
    }
}

//swap two variables of any type
function <T:type> swap(a,b:T):(T,T) { 
    statements {
        return (b,a);
    }
}

//count true values
function <length:int> countif(conds:bool[length]):int { 
    temps {
        int result=0;
    }
    statements {
        for c in conds {
            result=result+c; // or as a function call result=sum2(result,c);
        }
        /* With length==5, conds==[0,1,1,0,1], the above for loop unfolds to
            result=result+0;
            result=result+1;
            result=result+1;
            result=result+0;
            result=result+1;
        */
        
        return result;
    }
}

//count odd numbers from [2,7,0,2,2,0,3]
function countodd():int { 
    temps {
        bool[7] conditions=[false,false,false,false,0,0,0];
    }
    statements {
        for index,value in [2,7,0,2,2,0,3] {
            conditions[index]=value%2==1;
        }
        /* The above for statement unfolds to 7 assignments:
            conditions[0]=2%2==1;
            conditions[1]=7%2==1;
            conditions[2]=0%2==1;
            conditions[3]=2%2==1;
            conditions[4]=2%2==1;
            conditions[5]=0%2==1;
            conditions[6]=3%2==1;
        */
        return countif<7>(conditions);
    }
}

