typedef {Green, Yellow, Red} as Color;
typedef {GO, YIELD0, STOP, YIELD1} as State;
const State.GO as initialState;

automaton light_controller(light0: out Color, light1: out Color) {
    states {
        State state=initialState;
    }
    transitions {
        auto-sync true -> {
            light0.value=state==State.GO?Color.Green:
                          state==State.YIELD0?Color.Yellow:
                          Color.Red;
            light1.value=state==State.STOP?Color.Green:
                          state==State.YIELD1?Color.Yellow:
                          Color.Red;
            sync light0,light1;
        }

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

automaton light(sig: in Color) {
    states { }
    transitions {
        auto-sync true -> {
            sync sig;
        }
    }
}

automaton intersection() {
    states {
        light_controller controller;
        light lights[2];
    }

    inits {
        lights[0].sig <- controller.light0;
        lights[1].sig <- controller.light1;
    }
    transitions { }

}