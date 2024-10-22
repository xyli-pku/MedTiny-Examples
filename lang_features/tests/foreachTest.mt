automaton sat() {
	states {
		int[2**3] result = [0,-1,-2,-3,-4,-5,-6,-7];
		int line = 0;
	}
	inits {}
	transitions {
	    for ii, i in result {
	        line == ii -> i = line;
	    }
	}
}

