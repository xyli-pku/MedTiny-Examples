typedef {Green, Yellow, Red} as Color;
typedef {GO, YIELD0, STOP, YIELD1} as State;
const State.GO as initialState;

automaton light_controller() {
    states {
        State state=initialState;
    }
    transitions {

        state==State.GO -> state=State.YIELD0;

        state==State.YIELD0 -> {
            state=State.STOP;
        }
        state==State.STOP -> {
            state=State.YIELD1;
        }
        state==State.YIELD1 -> {
            state=State.GO;
        }
    }
}