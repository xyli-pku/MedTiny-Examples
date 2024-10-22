//A buffered Queue with only signature defined
automaton <T:type,size:int> Queue(enqueue:in T, dequeue:out T) {
    transitions {}
}

//A message duplicator with only signature defined 
automaton <numOut:int,T:type> Duplicator(input:in T,dupOut:out[numOut] T) {
    transitions {}
}

//A message merger with only signature defined 
automaton <numIn:int,T:type> Merger(mergeIn:in[numIn] T,output:out T) {
    transitions {}
}