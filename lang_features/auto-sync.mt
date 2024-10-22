import defaults; 
//Generalized Queue for both all link styles with auto-sync
automaton <T:type,size:int> Queue_auto(enqueue:in T, dequeue:out T) { 
    states {
        T[size] buffer=defaults.fill<T[size]>(null);
        int 0..size-1 head=0;
        int 0..size-1 tail=0;
    }

    transitions {
        //in both styles, enqueue when queue is not full
        auto-sync (ptail+1 % size)!=phead -> {
            sync enqueue;
            buffer[phead]=enqueue.value;
            phead=(phead+1)%size;
        }
        //in passive style, if queue is full, enqueued value is discarded
        passive-only (ptail+1 % size)==phead -> {
            sync enqueue;
        }
        //in both styles, dequeue when queue is not empty
        auto-sync ptail!=phead -> {
            dequeue.value=buffer[ptail];
            ptail=(ptail+1)%size;
            sync dequeue;
        }
        //in active style, if queue is empty, dequeue a default value 
        active-only ptail==phead -> {
            dequeue.value=defaults.fill<T>(null);
            sync dequeue;
        }
    }
}

//defaults.Producer implemented with auto-sync
automaton <T:type, defaultValue:T> defaultProducer(drain:out T) { 
    transitions {
        active-only true -> {
            drain.value=defaultValue;
            sync drain;
        }
    }
}

//defaults.Consumer implemented with auto-sync
automaton <T:type> defaultConsumer(source:in T) { 
    transitions {
        passive-only true -> {
            sync source;
        }
    }
}

//feeding the queue with incrementing data while dequeuing
//Note that the internal transitions should have a passive style writer and active style reader which is the opposite from the defaults.
automaton test_communication() { 
    states {
        Queue_auto<int,10> queue;
        int counter=0;
    }

    inits {
        queue.enqueue <- internal;
        queue.dequeue -> internal;
    }

    transitions {
        ND { //this configuration has to be non-deterministic
            auto-sync true -> { 
                counter=counter+1;
                queue.enqueue.value=counter;
                sync queue.enqueue;
            } 
            auto-sync true -> {
                sync queue.dequeue;
            } 
        }
    }
}

//A complete die implementation
automaton <num_sides:int> Die() { 
    states {
        int 0..num_sides side=0;
        defaults.randomInt<num_sides> rng;
    }

    inits {
        rng.randint -> internal;
    }

    transitions {
        auto-sync side==0 -> {
            sync rng.randint;
            side=rng.randint.value;
        }
    }
}
//Defaults randomInt implementation, it generates from [0, maxVal-1]
automaton <maxVal:int> defaultRandomInt(randint:out int) { 
    transitions {d
        ND { 
            for i in maxVal {
                passive-only true -> {
                    randint.value=i;
                    sync randint;   
                }
            }
        }
    }
}