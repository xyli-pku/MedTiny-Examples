automaton ifthenelse() {
    states {
	int x=3;
	int y=1;
	bool starting=true;
    }
    transitions {
	starting -> {
	    if ( y<0 ) then { y=-y; } else { };
	    if ( x<0 ) then { x=-x; } else { };
	    starting=false;
	}
	true -> if ( x>y ) then { y=y+1; } else { };
    }
}