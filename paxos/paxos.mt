typedef {NONE, VALUE1, VALUE2, VALUE2} as Value;

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

automaton <id: int 0..3, value: Value> Acceptor (
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
        Value last_accepted_value = value;
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

const -255 as NO_MESSAGE;

automaton PrepareAsync (
    in_ballot: in int,
    out_ballot: out int
) {
    states {
        int ballot = NO_MESSAGE;
    }
    transitions {
        auto-sync (ballot == NO_MESSAGE) -> {
            sync in_ballot;
            ballot = in_ballot.value;
        }

        auto-sync (ballot != NO_MESSAGE) -> {
            out_ballot.value = ballot;
            ballot = NO_MESSAGE;
            sync out_ballot;
        }
    }
}

automaton PromiseAsync (
    in_id: in int 0..3,
    in_ballot: in int,
    in_max_vballot: in int,
    in_max_value: in Value,
    out_id: out int 0..3,
    out_ballot: out int,
    out_max_vballot: out int,
    out_max_value: out Value
) {
    states {
        int 0..3 id = 0;
        int ballot = NO_MESSAGE;
        int max_vballot = NO_MESSAGE;
        Value max_value = Value.NONE;
    }
    transitions {
        auto-sync (ballot == NO_MESSAGE) -> {
            sync in_id, in_ballot, in_max_vballot, in_max_value;
            id = in_id.value;
            ballot = in_ballot.value;
            max_vballot = in_max_vballot.value;
            max_value = in_max_value.value;
        }

        auto-sync (ballot != NO_MESSAGE) -> {
            out_id.value = id;
            out_ballot.value = ballot;
            out_max_vballot.value = max_vballot;
            out_max_value.value = max_value;
            id = 0;
            ballot = NO_MESSAGE;
            max_vballot = NO_MESSAGE;
            max_value = Value.NONE;
            sync out_id, out_ballot, out_max_vballot, out_max_value;
        }
    }
}

automaton AcceptAsync (
    in_ballot: in int,
    in_value: in Value,
    out_ballot: out int,
    out_value: out Value
) {
    states {
        int ballot = NO_MESSAGE;
        Value value = Value.NONE;
    }
    transitions {
        auto-sync (ballot == NO_MESSAGE) -> {
            sync in_ballot, in_value;
            ballot = in_ballot.value;
            value = in_value.value;
        }

        auto-sync (ballot != NO_MESSAGE) -> {
            out_ballot.value = ballot;
            out_value.value = value;
            ballot = NO_MESSAGE;
            value = Value.NONE;
            sync out_ballot, out_value;
        }
    }
}

automaton AcceptedAsync (
    in_id: in int 0..3,
    in_ballot: in int,
    in_value: in Value,
    out_id: out int 0..3,
    out_ballot: out int,
    out_value: out Value
) {
    states {
        int 0..3 id = 0;
        int ballot = NO_MESSAGE;
        Value value = Value.NONE;
    }
    transitions {
        auto-sync (ballot == NO_MESSAGE) -> {
            sync in_id, in_ballot, in_value;
            id = in_id.value;
            ballot = in_ballot.value;
            value = in_value.value;
        }

        auto-sync (ballot != NO_MESSAGE) -> {
            out_id.value = id;
            out_ballot.value = ballot;
            out_value.value = value;
            id = 0;
            ballot = NO_MESSAGE;
            value = Value.NONE;
            sync out_id, out_ballot, out_value;
        }
    }
}

automaton Paxos() {
    states {
        Proposer<0, 2> proposer;
        Acceptor<1> acceptor1;
        Acceptor<2> acceptor2;
        Acceptor<3> acceptor3;
        Learner learner;

        PrepareAsync proposer_acceptor1_prepare;
        PrepareAsync proposer_acceptor2_prepare;
        PrepareAsync proposer_acceptor3_prepare;

        AcceptAsync proposer_acceptor1_accept;
        AcceptAsync proposer_acceptor2_accept;
        AcceptAsync proposer_acceptor3_accept;

        PromiseAsync acceptor1_proposer_promise;
        PromiseAsync acceptor2_proposer_promise;
        PromiseAsync acceptor3_proposer_promise;

        AcceptedAsync acceptor1_learner_accepted;
        AcceptedAsync acceptor2_learner_accepted;
        AcceptedAsync acceptor3_learner_accepted;
    }
    inits {
        proposer.prepare_ballot -> proposer_acceptor1_prepare.in_ballot;
        proposer.prepare_ballot -> proposer_acceptor2_prepare.in_ballot;
        proposer.prepare_ballot -> proposer_acceptor3_prepare.in_ballot;
        proposer_acceptor1_prepare.out_ballot -> acceptor1.prepare_ballot;
        proposer_acceptor2_prepare.out_ballot -> acceptor2.prepare_ballot;
        proposer_acceptor3_prepare.out_ballot -> acceptor3.prepare_ballot;

        proposer.accept_ballot -> proposer_acceptor1_accept.in_ballot;
        proposer.accept_ballot -> proposer_acceptor2_accept.in_ballot;
        proposer.accept_ballot -> proposer_acceptor3_accept.in_ballot;
        proposer.accept_value -> proposer_acceptor1_accept.in_value;
        proposer.accept_value -> proposer_acceptor2_accept.in_value;
        proposer.accept_value -> proposer_acceptor3_accept.in_value;
        proposer_acceptor1_accept.out_ballot -> acceptor1.accept_ballot;
        proposer_acceptor2_accept.out_ballot -> acceptor2.accept_ballot;
        proposer_acceptor3_accept.out_ballot -> acceptor3.accept_ballot;
        proposer_acceptor1_accept.out_value -> acceptor1.accept_value;
        proposer_acceptor2_accept.out_value -> acceptor2.accept_value;
        proposer_acceptor3_accept.out_value -> acceptor3.accept_value;

        acceptor1.promise_id -> acceptor1_proposer_promise.in_id;
        acceptor2.promise_id -> acceptor2_proposer_promise.in_id;
        acceptor3.promise_id -> acceptor3_proposer_promise.in_id;
        acceptor1.promise_ballot -> acceptor1_proposer_promise.in_ballot;
        acceptor2.promise_ballot -> acceptor2_proposer_promise.in_ballot;
        acceptor3.promise_ballot -> acceptor3_proposer_promise.in_ballot;
        acceptor1.promise_max_vballot -> acceptor1_proposer_promise.in_max_vballot;
        acceptor2.promise_max_vballot -> acceptor2_proposer_promise.in_max_vballot;
        acceptor3.promise_max_vballot -> acceptor3_proposer_promise.in_max_vballot;
        acceptor1.promise_max_value -> acceptor1_proposer_promise.in_max_value;
        acceptor2.promise_max_value -> acceptor2_proposer_promise.in_max_value;
        acceptor3.promise_max_value -> acceptor3_proposer_promise.in_max_value;
        acceptor1_proposer_promise.out_id -> proposer.promise_id;
        acceptor2_proposer_promise.out_id -> proposer.promise_id;
        acceptor3_proposer_promise.out_id -> proposer.promise_id;
        acceptor1_proposer_promise.out_ballot -> proposer.promise_ballot;
        acceptor2_proposer_promise.out_ballot -> proposer.promise_ballot;
        acceptor3_proposer_promise.out_ballot -> proposer.promise_ballot;
        acceptor1_proposer_promise.out_max_vballot -> proposer.promise_max_vballot;
        acceptor2_proposer_promise.out_max_vballot -> proposer.promise_max_vballot;
        acceptor3_proposer_promise.out_max_vballot -> proposer.promise_max_vballot;
        acceptor1_proposer_promise.out_max_value -> proposer.promise_max_value;
        acceptor2_proposer_promise.out_max_value -> proposer.promise_max_value;
        acceptor3_proposer_promise.out_max_value -> proposer.promise_max_value;

        acceptor1.accepted_id -> acceptor1_learner_accepted.in_id;
        acceptor2.accepted_id -> acceptor2_learner_accepted.in_id;
        acceptor3.accepted_id -> acceptor3_learner_accepted.in_id;
        acceptor1.accepted_ballot -> acceptor1_learner_accepted.in_ballot;
        acceptor2.accepted_ballot -> acceptor2_learner_accepted.in_ballot;
        acceptor3.accepted_ballot -> acceptor3_learner_accepted.in_ballot;
        acceptor1.accepted_value -> acceptor1_learner_accepted.in_value;
        acceptor2.accepted_value -> acceptor2_learner_accepted.in_value;
        acceptor3.accepted_value -> acceptor3_learner_accepted.in_value;
        acceptor1_learner_accepted.out_id -> learner.accepted_id;
        acceptor2_learner_accepted.out_id -> learner.accepted_id;
        acceptor3_learner_accepted.out_id -> learner.accepted_id;
        acceptor1_learner_accepted.out_ballot -> learner.accept_ballot;
        acceptor2_learner_accepted.out_ballot -> learner.accept_ballot;
        acceptor3_learner_accepted.out_ballot -> learner.accept_ballot;
        acceptor1_learner_accepted.out_value -> learner.accept_value;
        acceptor2_learner_accepted.out_value -> learner.accept_value;
        acceptor3_learner_accepted.out_value -> learner.accept_value;
    }
    transitions {}
}
