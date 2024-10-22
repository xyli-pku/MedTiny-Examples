typedef {NotThrown,FaceUp,FaceDown} as CoinState;
//A coin with only its state defined
automaton Coin() { 
    states {
        CoinState side=CoinState.NotThrown;
    }
    transitions {}
}

import defaults; 
//A die with any number of sides with only sides defined
automaton <num_sides:int> Die() { 
    states {
        int 0..num_sides side=0;
        defaults.randomInt<num_sides> rng;
    }
    transitions {}
}

//Two independent coins
automaton TwoCoins() { 
    states {
        Coin coin0;
        Coin coin1;
    }
    inits {
        //coin0.side is not accessible in TwoCoins
    }
    transitions {}
}
//Many six sided dice
automaton <num:int> ManyDice() { 
    states {
        Die<6>[num] dice; 
        //Array of automaton is allowed
    }
    transitions {}
}