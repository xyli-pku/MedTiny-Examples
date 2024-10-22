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
	              status_left, status_right: out State, wake_left, wake_right: in void,

				  sits: out void, quits:out void) {
	states {
        State state=State.THINKING;
    }

	transitions {
	    auto-sync true -> {
	        status_left.value=state;
	        sync status_left;
	    }

	    auto-sync true -> {
	        status_right.value=state;
	        sync status_right;
	    }

        state==State.THINKING -> {
			sleep(hunger_time);
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
            sync wake_left;
            state=State.HUNGRY;
        }

        auto-sync state==State.WAITING -> {
            sync wake_right;
            state=State.HUNGRY;
        }

		state==State.EATING -> {
			sleep(eating_time);
			state=State.WAKING;
        }

		auto-sync state==State.WAKING -> {
			state=State.LEAVING;
			sync left_wake, right_wake;
		}

		auto-sync state==State.LEAVING -> {
			sync left_status, right_status;
			state=((left_status.value==State.WAITING || left_status.value==State.HUNGRY)
			       || (right_status.value==State.WAITING || right_status.value==State.HUNGRY))?
			       State.WAKING:State.CALMING;

		}

		auto-sync state==State.CALMING -> {
			sleep(calming_time);
			state=State.THINKING;
            sync quits;
		}
    }
}

automaton <size:int,initial_value:int> semaphore(post0,post1,post2,post3,post4:in void,wait0,wait1,wait2,wait3,wait4:in void) {
    states {
        int 0..initial_value counter=initial_value;
    }
	transitions {
        auto-sync true -> {
            sync post0;
            counter=counter+1;
        }
        auto-sync true -> {
            sync post1;
            counter=counter+1;
        }
        auto-sync true -> {
            sync post2;
            counter=counter+1;
        }
        auto-sync true -> {
            sync post3;
            counter=counter+1;
        }
        auto-sync true -> {
            sync post4;
            counter=counter+1;
        }
        auto-sync counter>0 -> {
            sync wait0;
            counter=counter-1;
        }
        auto-sync counter>0 -> {
            sync wait1;
            counter=counter-1;
        }
        auto-sync counter>0 -> {
            sync wait2;
            counter=counter-1;
        }
        auto-sync counter>0 -> {
            sync wait3;
            counter=counter-1;
        }
        auto-sync counter>0 -> {
            sync wait4;
            counter=counter-1;
        }
    }
}

automaton table() {
	states {
	    semaphore<N,SEATS> coordinator;
		philosopher<SIMULATION_DELAY*2,SIMULATION_DELAY,SIMULATION_DELAY> p0;
		philosopher<SIMULATION_DELAY*2,SIMULATION_DELAY,SIMULATION_DELAY> p1;
		philosopher<SIMULATION_DELAY*2,SIMULATION_DELAY,SIMULATION_DELAY> p2;
		philosopher<SIMULATION_DELAY*2,SIMULATION_DELAY,SIMULATION_DELAY> p3;
		philosopher<SIMULATION_DELAY*2,SIMULATION_DELAY,SIMULATION_DELAY> p4;
	}
	inits {
            coordinator.post0 <-p0.quits;
            coordinator.wait0 <-p0.sits;
            p0.wake_left->p4.right_wake;
            p0.wake_right->p1.left_wake;
            p0.status_left->p4.right_status;
            p0.status_right->p1.left_status;

           coordinator.post1<-p1.quits;
           coordinator.wait1<-p1.sits;
           p1.wake_left->p0.right_wake;
           p1.wake_right->p2.left_wake;
           p1.status_left->p0.right_status;
           p1.status_right->p2.left_status;

           coordinator.post2<-p2.quits;
           coordinator.wait2<-p2.sits;
           p2.wake_left->p1.right_wake;
           p2.wake_right->p3.left_wake;
           p2.status_left->p1.right_status;
           p2.status_right->p3.left_status;

           coordinator.post3<-p3.quits;
           coordinator.wait3<-p3.sits;
           p3.wake_left->p2.right_wake;
           p3.wake_right->p4.left_wake;
           p3.status_left->p2.right_status;
           p3.status_right->p4.left_status;

           coordinator.post4<-p4.quits;
           coordinator.wait4<-p4.sits;
           p4.wake_left->p3.right_wake;
           p4.wake_right->p0.left_wake;
           p4.status_left->p3.right_status;
           p4.status_right->p0.left_status;
	}
	transitions {}
}