typedef {NotThrown,FaceUp,FaceDown} as CoinState;
//A fully defined coin
automaton Coin() { 
    states {
        CoinState side=CoinState.NotThrown;
    }

    transitions {
        non-deterministic {
            side==CoinState.NotThrown -> {
                side=CoinState.FaceUp;
            }
            side==CoinState.NotThrown -> {
                side=CoinState.FaceDown;
            }
        }
    }
}