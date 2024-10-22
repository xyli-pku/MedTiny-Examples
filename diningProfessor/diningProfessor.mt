function sleep(time:real) {}

const 5 as N;
const 2 as SIMULATION_DELAY;
const 2 as SEATS;

typedef {WAKING, LEAVING, CALMING, THINKING,
              REQUEST_SEAT, SEATING, HUNGRY, QUIT_SEAT, WAITING,
			  EATING } as State;
typedef {THINKING, HUNGRY, EATING } as Output;

function LEFT(name:int):int {
	statements {
		return (name + N - 1) % N;
	}
}

function RIGHT(name:int):int {
	statements {
		return (name + 1) % N;
	}
}

automaton <eating_time:real, hunger_time:real, calming_time:real>
      philosopher(left_status: in State, left_wake: out void,
	              right_status: in State, right_wake: out void,
	              status: out State, wake: in void,

				  sits: out void, quits:out void) {
	states {
        State state=State.THINKING;
    }

	transitions {
        state==State.THINKING -> {
			//sleep(hunger_time);
			state=State.REQUEST_SEAT;
        }

        auto-sync state==State.REQUEST_SEAT -> {
            state=State.SEATING;
            sync sits;
        }

		auto-sync state==State.HUNGRY -> {
			sync left_status,right_status;
			state=(left_status.value!=State.EATING && right_status.value!=State.EATING)?
				State.EATING:State.QUIT_SEAT;
        }

		auto-sync state==State.QUIT_SEAT -> {
            state=State.WAITING;
            sync quits;
        }

        auto-sync state==State.WAITING -> {
            sync wake;
            state=State.HUNGRY;
        }

		state==State.EATING -> {
			//sleep(eating_time);
			state=State.WAKING;
        }

		auto-sync state==State.WAKING -> {
			state==State.LEAVING;
			sync left_wake, right_wake;
		}

		auto-sync state==State.LEAVING -> {
			sync left_status, right_status;
			state=((left_status.value==State.WAITING || left_status.value==State.HUNGRY)
			       || (right_status.value==State.WAITING || right_status.value==State.HUNGRY))?
			       State.WAKING:State.CALMING;

		}

		auto-sync state==State.CALMING -> {
			sync quits;
			//sleep(calming_time);
			state==State.THINKING;
		}
    }
}

automaton <size:int> semaphore(post[size]:in void,wait[size]:in void) {
    states {
        int 0..N counter=SEATS;
    }
	transitions {

    }
}

automaton <size:int,eleType:type> duplicator(input:in eleType,dupOut[size]:out eleType) {
    states {
        semaphore<size> sem;
    }
    transitions {
        auto-sync true -> {
            sync input;
            for oi in dupOut {
                oi.value=input.value;
            }
            sync dupOut;
        }
    }
}

automaton table() {
	states {
		philosopher<SIMULATION_DELAY*2,SIMULATION_DELAY,SIMULATION_DELAY> p[N];
		duplicator<2,State> wakeDup[N];
		duplicator<2,State> statusDup[N];
		semaphore<N> coordinator;
	}
	inits {
       for i,pi in p {
           coordinator.post[i]<-pi.quits;
           coordinator.wait[i]<-pi.sits;
           pi.wake->wakeDup[i].input;
           wakeDup[i].dupOut[0]->p[LEFT(i)].right_wake;
           wakeDup[i].dupOut[1]->p[RIGHT(i)].left_wake;
           pi.status->statusDup[i].input;
           statusDup[i].dupOut[0]->p[LEFT(i)].right_status;
           statusDup[i].dupOut[1]->p[RIGHT(i)].left_status;
       }
	}
	transitions {}
}