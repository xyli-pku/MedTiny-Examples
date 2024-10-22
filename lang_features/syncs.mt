automaton <T:type,size:int> Queue(enqueue:in T, dequeue:out T) {
    transitions {}
}

//Two connected Queues with of different sizes
automaton <T:type> TwoQueues(enqueue:in T, dequeue:out T) { 
    states {
        Queue<10> q0;
        Queue<20> q1;
    }
    initializations {
        enqueue->q0.enqueue;
        q0.dequeue->q1.enqueue;
        q1.dequeue->dequeue;
    }
}

//defaults.Producer implementation value producer in active style
automaton <T:type, defaultValue:T> defaultProducer(drain:out T) { 
    transitions {
        !drain.readReady -> drain.writeReady=0;
        drain.readReady -> {
            drain.value=defaultValue;
            drain.writeReady=true;
            sync drain;
        }
    }
}

//defaults.Consumer implementation which discards all data in passive style
automaton <T:type> defaultConsumer(source:in T) { 
    transitions {
        !source.writeReady -> source.readReady=false;
        source.writeReady -> {
            sync source;
            source.readReady=true;
        }
    }
}

//Fully defined duplicator that splits a data from one port to multiple ports in passive style
automaton <numOut:int,T:type> Duplicator_manual(input:in T,dupOut:out[numOut] T) {
    transitions {
        !input.writeReady -> input.readReady=false;
        
        input.writeReady -> {
            sync input;
            input.readReady=true;
            for oi in dupOut {
                oi.value=input.value;
                oi.writeReady=true;
            }
            sync dupOut;
        }

        for oi in dupOut {
            !oi.readReady -> oi.writeReady=false;
        }
    }
}

//Fully defined merger that choose the first readable port using manual flag manipulation in active style
import defaults; 
automaton <numIn:int,T:type> Merger_manual(mergeIn:in[numIn] T,output:out T) {
    transitions {
        !output.readReady -> output.writeReady=0;
        for ii in mergeIn {
            !ii.readReady -> ii.readReady=true;
            ii.writeReady && output.readReady-> {
                sync ii; 
                output.value=ii.value;
                output.writeReady=true;
                ii.readReady=false;
                sync output;
            }
        }
    
        output.readReady -> {
            output.value=defaults.fill<T>(null);
            output.writeReady=true;
            sync output;
        }
    }
}


//Queue fully defined using manual flag manipulation with active enqueue and passive dequeue  
//A ring buffer Queue 
automaton <T:type,size:int> Queue_manual(enqueue:in T, dequeue:out T) { 
    states {
        T[size] buffer=defaults.fill<T[size]>(null);
        int 0..size-1 phead=0;
        int 0..size-1 ptail=0;
    }

    transitions {
        //always enqueue when queue is not full
        (ptail+1 % size)!=phead && !enqueue.readReady -> {
            enqueue.readReady=true;
        }
        enqueue.writeReady -> {
            sync enqueue;
            buffer[phead]=enqueue.value;
            phead=(phead+1)%size;
            enqueue.readReady=false;
        }
        //always dequeue when queue is not empty
        ptail!=phead && !dequeue.writeReady -> {
            dequeue.value=buffer[ptail];
            ptail=(ptail+1)%size;
            dequeue.writeReady=true;
            sync dequeue;
        }
        dequeue.readReady -> {
            dequeue.writeReady=false;
        }    
    }
    
}