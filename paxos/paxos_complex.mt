
typedef {VALUE, NONE} as Value;

typedef {PREPARE, PROMISE, ACCEPT, ACCEPTED, FINISH} as State;

typedef int as MessageType;

const 2 as qrmNum;
const 6 as bufSize;

automaton <init_ballot: int, ballot_step: int> Proposer (
    prepare_ballot: out int,
    accept_ballot: out int,
    accept_value: out Value,
    promise_id: in int 0..3,
    promise_ballot: in int,
    promise_max_vballot: in int,
    promise_max_value: in Value
) {
    states {
        State s = State.PREPARE;
        int next_ballot = init_ballot;
        int 0..3 promise_count = 0;
        bool promise1 = false;
        bool promise2 = false;
        bool promise3 = false;
        Value candidate_value = Value.NONE;
        int most_recent_ballot = -2;
        int ballot_buffer = -1;
        int 0..3 acceptor_id_buffer = 0;
        int max_vballot_buffer = 0;
        Value max_value_buffer = Value.NONE;
        int 0..3  promise_status = 0;
    }
    transitions {
        // Prepare
        auto-sync s == State.PREPARE -> {
            prepare_ballot.value = next_ballot;
            next_ballot = next_ballot + ballot_step;
            s = State.PROMISE;
            sync prepare_ballot;
        }

        // Promise
        auto-sync (s == State.PROMISE) && (promise_status == 0) -> {
            sync promise_id, promise_ballot, promise_max_vballot, promise_max_value;
            acceptor_id_buffer = promise_id.value;
            ballot_buffer = promise_ballot.value;
            max_vballot_buffer = promise_max_vballot.value;
            max_value_buffer = promise_max_value.value;
            promise_status = 1;
        }

        (promise_status == 1) && (ballot_buffer == next_ballot - ballot_step)
                              && (!promise1 && acceptor_id_buffer == 1) -> {
            promise1 = true;
            promise_count = promise_count + 1;
            promise_status = 2;
        }

        (promise_status == 1) && (ballot_buffer == next_ballot - ballot_step)
                              && (!promise2 && acceptor_id_buffer == 2) -> {
            promise2 = true;
            promise_count = promise_count + 1;
            promise_status = 2;
        }

        (promise_status == 1) && (ballot_buffer == next_ballot - ballot_step)
                              && (!promise3 && acceptor_id_buffer == 3) -> {
            promise3 = true;
            promise_count = promise_count + 1;
            promise_status = 2;
        }

        (promise_status == 2) && (max_vballot_buffer > most_recent_ballot) -> {
            most_recent_ballot = max_vballot_buffer;
            candidate_value = max_value_buffer;
            promise_status = 3;
        }

        (promise_status == 2) && (max_vballot_buffer <= most_recent_ballot) -> {
            promise_status = 3;
        }

        (promise_status == 3) && (promise_count >= qrmNum) -> {
            most_recent_ballot = -1;
            promise1 = false;
            promise2 = false;
            promise3 = false;
            promise_count = 0;
            promise_status = 0;
            s = State.ACCEPT;
        }

        (promise_status == 3) && (promise_count < qrmNum) -> {
            promise_status = 0;
        }

        // Accept
        auto-sync (s == State.ACCEPT) -> {
            accept_ballot.value = next_ballot - ballot_step;
            accept_value.value = candidate_value;
            s = State.FINISH;
            sync accept_ballot, accept_value;
        }
    }
}

automaton <id: int 0..3> Acceptor (
    promise_id: out int 0..3,
    promise_ballot: out int,
    promise_max_vballot: out int,
    promise_max_value: out Value,
    accepted_id: out int 0..3,
    accepted_ballot: out int,
    accepted_value: out Value,
    prepare_ballot: in int,
    accept_ballot: in int,
    accept_value: in Value
) {
    states {
        State s = State.PREPARE;
        int most_recent_ballot = -1;
        int last_accepted_ballot = -1;
        Value last_accepted_value = Value.VALUE;
        int ballot_buffer = -1;
        Value value_buffer = Value.NONE;
        int 0..1 prepare_status = 0;
        int 0..1 accept_status = 0;
    }
    transitions {
        // Prepare
        auto-sync (s == State.PREPARE) && (prepare_status == 0) -> {
            sync prepare_ballot;
            ballot_buffer = prepare_ballot.value;
            prepare_status = 1;
        }

        (prepare_status == 1) && (ballot_buffer > most_recent_ballot) -> {
            most_recent_ballot = ballot_buffer;
            s = State.PROMISE;
            prepare_status = 0;
        }

        (prepare_status == 1) && (ballot_buffer <= most_recent_ballot) -> {
            prepare_status = 0;
        }

        // Promise
        auto-sync (s == State.PROMISE) -> {
            promise_id.value = id;
            promise_ballot.value = most_recent_ballot;
            promise_max_vballot.value = last_accepted_ballot;
            promise_max_value.value = last_accepted_value;
            s = State.PREPARE;
            sync promise_id, promise_ballot, promise_max_vballot, promise_max_value;
        }

        // Accept
        auto-sync (accept_status == 0) -> {
            sync accept_ballot, accept_value;
            ballot_buffer = accept_ballot.value;
            value_buffer = accept_value.value;
            accept_status = 1;
        }

        (accept_status == 1) && (ballot_buffer >= most_recent_ballot) -> {
            most_recent_ballot = ballot_buffer;
            last_accepted_ballot = ballot_buffer;
            last_accepted_value = value_buffer;
            s = State.ACCEPTED;
            accept_status = 0;
        }

        (accept_status == 1) && (ballot_buffer < most_recent_ballot) -> {
            accept_status = 0;
        }

        // Accepted
        auto-sync (s == State.ACCEPTED) -> {
            accepted_id.value = id;
            accepted_ballot.value = last_accepted_ballot;
            accepted_value.value = last_accepted_value;
            s = State.FINISH;
            sync accepted_id, accepted_ballot, accepted_value;
        }
    }
}

automaton Learner (
    accepted_id: in int 0..3,
    accepted_ballot: in int,
    accepted_value: in Value
) {
    states {
        int 0..3 accepted_count = 0;
        bool accepted1 = false;
        bool accepted2 = false;
        bool accepted3 = false;
        int current_ballot = -1;
        Value chosen_value = Value.NONE;
        int ballot_buffer = -1;
        Value value_buffer = Value.NONE;
        int 0..3 acceptor_id_buffer = 0;
        int 0..2 status = 0;
        bool finish = false;
    }
    transitions {
        (finish) -> true;
        auto-sync (status == 0) -> {
            sync accepted_id, accepted_ballot, accepted_value;
            acceptor_id_buffer = accepted_id.value;
            ballot_buffer = accepted_ballot.value;
            value_buffer = accepted_value.value;
            status = 1;
        }

        (status == 1) && (ballot_buffer > current_ballot) && (acceptor_id_buffer == 1) -> {
            current_ballot = ballot_buffer;
            chosen_value = value_buffer;
            accepted_count = 1;
            accepted1 = true;
            accepted2 = false;
            accepted3 = false;
            status = 2;
        }

        (status == 1) && (ballot_buffer > current_ballot) && (acceptor_id_buffer == 2) -> {
            current_ballot = ballot_buffer;
            chosen_value = value_buffer;
            accepted_count = 1;
            accepted1 = false;
            accepted2 = true;
            accepted3 = false;
            status = 2;
        }

        (status == 1) && (ballot_buffer > current_ballot) && (acceptor_id_buffer == 3) -> {
            current_ballot = ballot_buffer;
            chosen_value = value_buffer;
            accepted_count = 1;
            accepted1 = false;
            accepted2 = false;
            accepted3 = true;
            status = 2;
        }

        (status == 1) && (ballot_buffer == current_ballot) && !accepted1 -> {
            accepted_count = accepted_count + 1;
            accepted1 = true;
            status = 2;
        }

        (status == 1) && (ballot_buffer == current_ballot) && !accepted2 -> {
            accepted_count = accepted_count + 1;
            accepted2 = true;
            status = 2;
        }

        (status == 1) && (ballot_buffer == current_ballot) && !accepted3 -> {
            accepted_count = accepted_count + 1;
            accepted3 = true;
            status = 2;
        }

        (status == 2) && (accepted_count > qrmNum) -> {
			finish = true;
            status = 0;
        }

        (status == 2) && (accepted_count <= qrmNum) -> {
            status = 0;
        }
    }
}

automaton <NullMessage: int> FaultyAsync (
    inPort: in int, outPort: out int
) {
    states {
        int buffer1 = NullMessage;
        int buffer2 = NullMessage;
        int buffer3 = NullMessage;
        int buffer4 = NullMessage;
        int buffer5 = NullMessage;
        int buffer6 = NullMessage;
        int tmp = NullMessage;
        int 0..5 front = 0;
        int 0..5 rear = 0;
        int 0..1 status = 0;
    }
    transitions {
        !inPort.readReady && (rear == 0) && (buffer1 == NullMessage) -> inPort.readReady = true;
        !inPort.readReady && (rear == 1) && (buffer2 == NullMessage) -> inPort.readReady = true;
        !inPort.readReady && (rear == 2) && (buffer3 == NullMessage) -> inPort.readReady = true;
        !inPort.readReady && (rear == 3) && (buffer4 == NullMessage) -> inPort.readReady = true;
        !inPort.readReady && (rear == 4) && (buffer5 == NullMessage) -> inPort.readReady = true;
        !inPort.readReady && (rear == 5) && (buffer6 == NullMessage) -> inPort.readReady = true;

        !outPort.writeReady && (front == 0) && (buffer1 != NullMessage) -> outPort.writeReady = true;
        !outPort.writeReady && (front == 1) && (buffer2 != NullMessage) -> outPort.writeReady = true;
        !outPort.writeReady && (front == 2) && (buffer3 != NullMessage) -> outPort.writeReady = true;
        !outPort.writeReady && (front == 3) && (buffer4 != NullMessage) -> outPort.writeReady = true;
        !outPort.writeReady && (front == 4) && (buffer5 != NullMessage) -> outPort.writeReady = true;
        !outPort.writeReady && (front == 5) && (buffer6 != NullMessage) -> outPort.writeReady = true;

        outPort.writeReady && (front == 0) && (buffer1 == NullMessage) -> outPort.writeReady = false;
        outPort.writeReady && (front == 1) && (buffer2 == NullMessage) -> outPort.writeReady = false;
        outPort.writeReady && (front == 2) && (buffer3 == NullMessage) -> outPort.writeReady = false;
        outPort.writeReady && (front == 3) && (buffer4 == NullMessage) -> outPort.writeReady = false;
        outPort.writeReady && (front == 4) && (buffer5 == NullMessage) -> outPort.writeReady = false;
        outPort.writeReady && (front == 5) && (buffer6 == NullMessage) -> outPort.writeReady = false;

        ND {
            // enqueue at any time, so message may get lost due to the circular buffer
            (status == 0) && inPort.readReady && inPort.writeReady -> {
                sync inPort;
                tmp = inPort.value;
                status = 1;
            }
            
            (status == 1) && (rear == 0) -> {
                buffer1 = tmp;
                rear = 1;
                status = 0;
            }

            (status == 1) && (rear == 1) -> {
                buffer2 = tmp;
                rear = 2;
                status = 0;
            }

            (status == 1) && (rear == 2) -> {
                buffer3 = tmp;
                rear = 3;
                status = 0;
            }

            (status == 1) && (rear == 3) -> {
                buffer4 = tmp;
                rear = 4;
                status = 0;
            }

            (status == 1) && (rear == 4) -> {
                buffer5 = tmp;
                rear = 5;
                status = 0;
            }

            (status == 1) && (rear == 5) -> {
                buffer6 = tmp;
                rear = 0;
                status = 0;
            }

            // dequeue at any time
            outPort.readReady && outPort.writeReady && (front == 0) -> {
                outPort.value = buffer1;
                buffer1 = NullMessage;
                front = 1;
                sync outPort;
            }

            outPort.readReady && outPort.writeReady && (front == 1) -> {
                outPort.value = buffer2;
                buffer2 = NullMessage;
                front = 2;
                sync outPort;
            }

            outPort.readReady && outPort.writeReady && (front == 2) -> {
                outPort.value = buffer3;
                buffer3 = NullMessage;
                front = 3;
                sync outPort;
            }

            outPort.readReady && outPort.writeReady && (front == 3) -> {
                outPort.value = buffer4;
                buffer4 = NullMessage;
                front = 4;
                sync outPort;
            }

            outPort.readReady && outPort.writeReady && (front == 4) -> {
                outPort.value = buffer5;
                buffer5 = NullMessage;
                front = 5;
                sync outPort;
            }

            outPort.readReady && outPort.writeReady && (front == 5) -> {
                outPort.value = buffer6;
                buffer6 = NullMessage;
                front = 0;
                sync outPort;
            }

            // duplicate a message at the tail
            (rear == 0) && (buffer6 != NullMessage) -> {
                buffer1 = buffer6;
                rear = 0;
            }

            (rear == 1) && (buffer1 != NullMessage) -> {
                buffer2 = buffer1;
                rear = 0;
            }

            (rear == 2) && (buffer2 != NullMessage) -> {
                buffer3 = buffer2;
                rear = 0;
            }

            (rear == 3) && (buffer3 != NullMessage) -> {
                buffer4 = buffer3;
                rear = 0;
            }

            (rear == 4) && (buffer4 != NullMessage) -> {
                buffer5 = buffer4;
                rear = 0;
            }

            (rear == 5) && (buffer5 != NullMessage) -> {
                buffer6 = buffer5;
                rear = 0;
            }
        }
    }
}

automaton Paxos () {
    states {
        Proposer<0, 2> proposer;
        Acceptor<0> acceptor1;
        Acceptor<1> acceptor2;
        Acceptor<2> acceptor3;
        Learner learner;

        FaultyAsync<0> proposer_acceptor1_prepare_ballot;
        FaultyAsync<0> proposer_acceptor2_prepare_ballot;
        FaultyAsync<0> proposer_acceptor3_prepare_ballot;

        FaultyAsync<0> acceptor1_proposer_promise_ballot;
        FaultyAsync<0> acceptor2_proposer_promise_ballot;
        FaultyAsync<0> acceptor3_proposer_promise_ballot;

        FaultyAsync<0> acceptor1_proposer_promise_id;
        FaultyAsync<0> acceptor2_proposer_promise_id;
        FaultyAsync<0> acceptor3_proposer_promise_id;

        FaultyAsync<0> acceptor1_proposer_promise_max_vballot;
        FaultyAsync<0> acceptor2_proposer_promise_max_vballot;
        FaultyAsync<0> acceptor3_proposer_promise_max_vballot;

        FaultyAsync<0> acceptor1_proposer_promise_max_value;
        FaultyAsync<0> acceptor2_proposer_promise_max_value;
        FaultyAsync<0> acceptor3_proposer_promise_max_value;

        FaultyAsync<0> proposer_acceptor1_accept_ballot;
        FaultyAsync<0> proposer_acceptor2_accept_ballot;
        FaultyAsync<0> proposer_acceptor3_accept_ballot;

        FaultyAsync<0> proposer_acceptor1_accept_value;
        FaultyAsync<0> proposer_acceptor2_accept_value;
        FaultyAsync<0> proposer_acceptor3_accept_value;

        FaultyAsync<0> acceptor1_learner_accepted_ballot;
        FaultyAsync<0> acceptor2_learner_accepted_ballot;
        FaultyAsync<0> acceptor3_learner_accepted_ballot;

        FaultyAsync<0> acceptor1_learner_accepted_id;
        FaultyAsync<0> acceptor2_learner_accepted_id;
        FaultyAsync<0> acceptor3_learner_accepted_id;

        FaultyAsync<0> acceptor1_learner_accepted_value;
        FaultyAsync<0> acceptor2_learner_accepted_value;
        FaultyAsync<0> acceptor3_learner_accepted_value;
    }
    inits {
        proposer.prepare_ballot -> proposer_acceptor1_prepare_ballot.inPort; proposer_acceptor1_prepare_ballot.outPort -> acceptor1.prepare_ballot;
        proposer.prepare_ballot -> proposer_acceptor2_prepare_ballot.inPort; proposer_acceptor2_prepare_ballot.outPort -> acceptor2.prepare_ballot;
        proposer.prepare_ballot -> proposer_acceptor3_prepare_ballot.inPort; proposer_acceptor3_prepare_ballot.outPort -> acceptor3.prepare_ballot;

        acceptor1.promise_ballot -> acceptor1_proposer_promise_ballot.inPort; acceptor1_proposer_promise_ballot.outPort -> proposer.promise_ballot;
        acceptor2.promise_ballot -> acceptor2_proposer_promise_ballot.inPort; acceptor2_proposer_promise_ballot.outPort -> proposer.promise_ballot;
        acceptor3.promise_ballot -> acceptor3_proposer_promise_ballot.inPort; acceptor3_proposer_promise_ballot.outPort -> proposer.promise_ballot;
        acceptor1.promise_id -> acceptor1_proposer_promise_id.inPort; acceptor1_proposer_promise_id.outPort -> proposer.promise_id;
        acceptor2.promise_id -> acceptor2_proposer_promise_id.inPort; acceptor2_proposer_promise_id.outPort -> proposer.promise_id;
        acceptor3.promise_id -> acceptor3_proposer_promise_id.inPort; acceptor3_proposer_promise_id.outPort -> proposer.promise_id;
        acceptor1.promise_max_vballot -> acceptor1_proposer_promise_max_vballot.inPort; acceptor1_proposer_promise_max_vballot.outPort -> proposer.promise_max_vballot;
        acceptor2.promise_max_vballot -> acceptor2_proposer_promise_max_vballot.inPort; acceptor2_proposer_promise_max_vballot.outPort -> proposer.promise_max_vballot;
        acceptor3.promise_max_vballot -> acceptor3_proposer_promise_max_vballot.inPort; acceptor3_proposer_promise_max_vballot.outPort -> proposer.promise_max_vballot;
        acceptor1.promise_max_value -> acceptor1_proposer_promise_max_value.inPort; acceptor1_proposer_promise_max_value.outPort -> proposer.promise_max_value;
        acceptor2.promise_max_value -> acceptor2_proposer_promise_max_value.inPort; acceptor2_proposer_promise_max_value.outPort -> proposer.promise_max_value;
        acceptor3.promise_max_value -> acceptor3_proposer_promise_max_value.inPort; acceptor3_proposer_promise_max_value.outPort -> proposer.promise_max_value;
        
        proposer.accept_ballot -> proposer_acceptor1_accept_ballot.inPort; proposer_acceptor1_accept_ballot.outPort -> acceptor1.accept_ballot;
        proposer.accept_ballot -> proposer_acceptor2_accept_ballot.inPort; proposer_acceptor2_accept_ballot.outPort -> acceptor2.accept_ballot;
        proposer.accept_ballot -> proposer_acceptor3_accept_ballot.inPort; proposer_acceptor3_accept_ballot.outPort -> acceptor3.accept_ballot;
        proposer.accept_value -> proposer_acceptor1_accept_value.inPort; proposer_acceptor1_accept_value.outPort -> acceptor1.accept_value;
        proposer.accept_value -> proposer_acceptor2_accept_value.inPort; proposer_acceptor2_accept_value.outPort -> acceptor2.accept_value;
        proposer.accept_value -> proposer_acceptor3_accept_value.inPort; proposer_acceptor3_accept_value.outPort -> acceptor3.accept_value;

        acceptor1.accepted_ballot -> acceptor1_learner_accepted_ballot.inPort; acceptor1_learner_accepted_ballot.outPort -> learner.accepted_ballot;
        acceptor2.accepted_ballot -> acceptor2_learner_accepted_ballot.inPort; acceptor2_learner_accepted_ballot.outPort -> learner.accepted_ballot;
        acceptor3.accepted_ballot -> acceptor3_learner_accepted_ballot.inPort; acceptor3_learner_accepted_ballot.outPort -> learner.accepted_ballot;
        acceptor1.accepted_value -> acceptor1_learner_accepted_value.inPort; acceptor1_learner_accepted_value.outPort -> learner.accepted_value;
        acceptor2.accepted_value -> acceptor2_learner_accepted_value.inPort; acceptor2_learner_accepted_value.outPort -> learner.accepted_value;
        acceptor3.accepted_value -> acceptor3_learner_accepted_value.inPort; acceptor3_learner_accepted_value.outPort -> learner.accepted_value;
        acceptor1.accepted_id -> acceptor1_learner_accepted_id.inPort; acceptor1_learner_accepted_id.outPort -> learner.accepted_id;
        acceptor2.accepted_id -> acceptor2_learner_accepted_id.inPort; acceptor2_learner_accepted_id.outPort -> learner.accepted_id;
        acceptor3.accepted_id -> acceptor3_learner_accepted_id.inPort; acceptor3_learner_accepted_id.outPort -> learner.accepted_id;
    }
    transitions {}
}
