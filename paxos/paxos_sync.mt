typedef {VALUE, NONE} as Value;

typedef {PREPARE, PROMISE, ACCEPT, ACCEPTED, FINISH} as State;

const 2 as qrmNum;

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

automaton Paxos() {
    states {
        Proposer<0, 2> proposer1;
        Proposer<1, 2> proposer2;
        Acceptor<1> acceptor1;
        Acceptor<2> acceptor2;
        Acceptor<3> acceptor3;
        Learner learner;
    }
    inits {}
    transitions {}
}
