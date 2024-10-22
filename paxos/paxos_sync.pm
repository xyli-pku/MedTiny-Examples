const int proposer1_init_ballot = 0;
const int proposer1_ballot_step = 1;
module proposer1_Proposer
    proposer1_s : [0..5] init 0;
    proposer1_next_ballot : int init 0;
    proposer1_promise_count : [0..3] init 0;
    proposer1_promise1 : bool init false;
    proposer1_promise2 : bool init false;
    proposer1_promise3 : bool init false;
    proposer1_candidate_value : [0..2] init 1;
    proposer1_most_recent_ballot : int init -2;
    proposer1_ballot_buffer : int init -1;
    proposer1_acceptor_id_buffer : [0..3] init 0;
    proposer1_max_vballot_buffer : int init 0;
    proposer1_max_value_buffer : [0..2] init 1;
    proposer1_promise_status : [0..3] init 0;

    [prepare1] proposer1_s=0 -> (proposer1_next_ballot'=proposer1_next_ballot+1)&(proposer1_s'=1);
    [proposer1_promise1] proposer1_s=1&proposer1_promise_status=0 -> (proposer1_acceptor_id_buffer'=1)&(proposer1_ballot_buffer'=acceptor1_most_recent_ballot)&(proposer1_max_vballot_buffer'=acceptor1_last_accepted_ballot)&(proposer1_max_value_buffer'=acceptor1_last_accepted_value)&(proposer1_promise_status'=1);
    [proposer1_promise2] proposer1_s=1&proposer1_promise_status=0 -> (proposer1_acceptor_id_buffer'=2)&(proposer1_ballot_buffer'=acceptor2_most_recent_ballot)&(proposer1_max_vballot_buffer'=acceptor2_last_accepted_ballot)&(proposer1_max_value_buffer'=acceptor2_last_accepted_value)&(proposer1_promise_status'=1);
    [proposer1_promise3] proposer1_s=1&proposer1_promise_status=0 -> (proposer1_acceptor_id_buffer'=3)&(proposer1_ballot_buffer'=acceptor3_most_recent_ballot)&(proposer1_max_vballot_buffer'=acceptor3_last_accepted_ballot)&(proposer1_max_value_buffer'=acceptor3_last_accepted_value)&(proposer1_promise_status'=1);
    [] proposer1_promise_status=1&proposer1_ballot_buffer=proposer1_next_ballot-1&!proposer1_promise1&proposer1_acceptor_id_buffer=1 -> (proposer1_promise1'=true)&(proposer1_promise_count'=proposer1_promise_count+1)&(proposer1_promise_status'=2);
    [] proposer1_promise_status=1&proposer1_ballot_buffer=proposer1_next_ballot-1&!proposer1_promise2&proposer1_acceptor_id_buffer=2 -> (proposer1_promise2'=true)&(proposer1_promise_count'=proposer1_promise_count+1)&(proposer1_promise_status'=2);
    [] proposer1_promise_status=1&proposer1_ballot_buffer=proposer1_next_ballot-1&!proposer1_promise3&proposer1_acceptor_id_buffer=3 -> (proposer1_promise3'=true)&(proposer1_promise_count'=proposer1_promise_count+1)&(proposer1_promise_status'=2);
    [] proposer1_promise_status=2&proposer1_max_vballot_buffer>proposer1_most_recent_ballot -> (proposer1_most_recent_ballot'=proposer1_max_vballot_buffer)&(proposer1_candidate_value'=proposer1_max_value_buffer)&(proposer1_promise_status'=3);
    [] proposer1_promise_status=2&proposer1_max_vballot_buffer<=proposer1_most_recent_ballot -> (proposer1_promise_status'=3);
    [] proposer1_promise_status=3&proposer1_promise_count>=2 -> (proposer1_most_recent_ballot'=-1)&(proposer1_promise1'=false)&(proposer1_promise2'=false)&(proposer1_promise3'=false)&(proposer1_promise_count'=0)&(proposer1_promise_status'=0)&(proposer1_s'=2);
    [] proposer1_promise_status=3&proposer1_promise_count<2 -> (proposer1_promise_status'=0);
    [accept1] proposer1_s=2 ->(proposer1_s'=4);
endmodule
const int proposer2_init_ballot = 0;
const int proposer2_ballot_step = 1;
module proposer2_Proposer
    proposer2_s : [0..5] init 0;
    proposer2_next_ballot : int init 0;
    proposer2_promise_count : [0..3] init 0;
    proposer2_promise1 : bool init false;
    proposer2_promise2 : bool init false;
    proposer2_promise3 : bool init false;
    proposer2_candidate_value : [0..2] init 1;
    proposer2_most_recent_ballot : int init -2;
    proposer2_ballot_buffer : int init -1;
    proposer2_acceptor_id_buffer : [0..3] init 0;
    proposer2_max_vballot_buffer : int init 0;
    proposer2_max_value_buffer : [0..2] init 1;
    proposer2_promise_status : [0..3] init 0;

    [prepare2] proposer2_s=0 -> (proposer2_next_ballot'=proposer2_next_ballot+1)&(proposer2_s'=1);
    [proposer2_promise1] proposer2_s=1&proposer2_promise_status=0 -> (proposer2_acceptor_id_buffer'=1)&(proposer2_ballot_buffer'=acceptor1_most_recent_ballot)&(proposer2_max_vballot_buffer'=acceptor1_last_accepted_ballot)&(proposer2_max_value_buffer'=acceptor1_last_accepted_value)&(proposer2_promise_status'=1);
    [proposer2_promise2] proposer2_s=1&proposer2_promise_status=0 -> (proposer2_acceptor_id_buffer'=2)&(proposer2_ballot_buffer'=acceptor2_most_recent_ballot)&(proposer2_max_vballot_buffer'=acceptor2_last_accepted_ballot)&(proposer2_max_value_buffer'=acceptor2_last_accepted_value)&(proposer2_promise_status'=1);
    [proposer2_promise3] proposer2_s=1&proposer2_promise_status=0 -> (proposer2_acceptor_id_buffer'=3)&(proposer2_ballot_buffer'=acceptor3_most_recent_ballot)&(proposer2_max_vballot_buffer'=acceptor3_last_accepted_ballot)&(proposer2_max_value_buffer'=acceptor3_last_accepted_value)&(proposer2_promise_status'=1);
    [] proposer2_promise_status=1&proposer2_ballot_buffer=proposer2_next_ballot-1&!proposer2_promise1&proposer2_acceptor_id_buffer=1 -> (proposer2_promise1'=true)&(proposer2_promise_count'=proposer2_promise_count+1)&(proposer2_promise_status'=2);
    [] proposer2_promise_status=1&proposer2_ballot_buffer=proposer2_next_ballot-1&!proposer2_promise2&proposer2_acceptor_id_buffer=2 -> (proposer2_promise2'=true)&(proposer2_promise_count'=proposer2_promise_count+1)&(proposer2_promise_status'=2);
    [] proposer2_promise_status=1&proposer2_ballot_buffer=proposer2_next_ballot-1&!proposer2_promise3&proposer2_acceptor_id_buffer=3 -> (proposer2_promise3'=true)&(proposer2_promise_count'=proposer2_promise_count+1)&(proposer2_promise_status'=2);
    [] proposer2_promise_status=2&proposer2_max_vballot_buffer>proposer2_most_recent_ballot -> (proposer2_most_recent_ballot'=proposer2_max_vballot_buffer)&(proposer2_candidate_value'=proposer2_max_value_buffer)&(proposer2_promise_status'=3);
    [] proposer2_promise_status=2&proposer2_max_vballot_buffer<=proposer2_most_recent_ballot -> (proposer2_promise_status'=3);
    [] proposer2_promise_status=3&proposer2_promise_count>=2 -> (proposer2_most_recent_ballot'=-1)&(proposer2_promise1'=false)&(proposer2_promise2'=false)&(proposer2_promise3'=false)&(proposer2_promise_count'=0)&(proposer2_promise_status'=0)&(proposer2_s'=2);
    [] proposer2_promise_status=3&proposer2_promise_count<2 -> (proposer2_promise_status'=0);
    [accept2] proposer2_s=2 ->(proposer2_s'=4);
endmodule
const int acceptor1_id = 1;
module acceptor1_Acceptor
    acceptor1_s : [0..5] init 0;
    acceptor1_most_recent_ballot : int init -1;
    acceptor1_last_accepted_ballot : int init -1;
    acceptor1_last_accepted_value : [0..2] init 0;
    acceptor1_ballot_buffer : int init -1;
    acceptor1_value_buffer : [0..2] init 1;
    acceptor1_prepare_status : [0..1] init 0;
    acceptor1_accept_status : [0..1] init 0;

    [prepare1] acceptor1_s=0&acceptor1_prepare_status=0 -> (acceptor1_ballot_buffer'=proposer1_next_ballot)&(acceptor1_prepare_status'=1);
    [prepare2] acceptor1_s=0&acceptor1_prepare_status=0 -> (acceptor1_ballot_buffer'=proposer2_next_ballot)&(acceptor1_prepare_status'=1);
    [] acceptor1_prepare_status=1&acceptor1_ballot_buffer>acceptor1_most_recent_ballot -> (acceptor1_most_recent_ballot'=acceptor1_ballot_buffer)&(acceptor1_s'=1)&(acceptor1_prepare_status'=0);
    [] acceptor1_prepare_status=1&acceptor1_ballot_buffer<=acceptor1_most_recent_ballot -> (acceptor1_prepare_status'=0);
    [proposer1_promise1] acceptor1_s=1 -> (acceptor1_s'=0);
    [proposer2_promise1] acceptor1_s=1 -> (acceptor1_s'=0);
    [accept1] acceptor1_accept_status=0 -> (acceptor1_ballot_buffer'=proposer1_next_ballot-1)&(acceptor1_value_buffer'=proposer1_candidate_value)&(acceptor1_accept_status'=1);
    [accept2] acceptor1_accept_status=0 -> (acceptor1_ballot_buffer'=proposer2_next_ballot-1)&(acceptor1_value_buffer'=proposer2_candidate_value)&(acceptor1_accept_status'=1);
    [] acceptor1_accept_status=1&acceptor1_ballot_buffer>=acceptor1_most_recent_ballot -> (acceptor1_most_recent_ballot'=acceptor1_ballot_buffer)&(acceptor1_last_accepted_ballot'=acceptor1_ballot_buffer)&(acceptor1_last_accepted_value'=acceptor1_value_buffer)&(acceptor1_s'=3)&(acceptor1_accept_status'=0);
    [] acceptor1_accept_status=1&acceptor1_ballot_buffer<acceptor1_most_recent_ballot -> (acceptor1_accept_status'=0);
    [notify1] acceptor1_s=3 -> (acceptor1_s'=4);
endmodule
const int acceptor2_id = 2;
module acceptor2_Acceptor
    acceptor2_s : [0..5] init 0;
    acceptor2_most_recent_ballot : int init -1;
    acceptor2_last_accepted_ballot : int init -1;
    acceptor2_last_accepted_value : [0..2] init 0;
    acceptor2_ballot_buffer : int init -1;
    acceptor2_value_buffer : [0..2] init 1;
    acceptor2_prepare_status : [0..1] init 0;
    acceptor2_accept_status : [0..1] init 0;

    [prepare1] acceptor2_s=0&acceptor2_prepare_status=0 -> (acceptor2_ballot_buffer'=proposer1_next_ballot)&(acceptor2_prepare_status'=1);
    [prepare2] acceptor2_s=0&acceptor2_prepare_status=0 -> (acceptor2_ballot_buffer'=proposer2_next_ballot)&(acceptor2_prepare_status'=1);
    [] acceptor2_prepare_status=1&acceptor2_ballot_buffer>acceptor2_most_recent_ballot -> (acceptor2_most_recent_ballot'=acceptor2_ballot_buffer)&(acceptor2_s'=1)&(acceptor2_prepare_status'=0);
    [] acceptor2_prepare_status=1&acceptor2_ballot_buffer<=acceptor2_most_recent_ballot -> (acceptor2_prepare_status'=0);
    [proposer1_promise2] acceptor2_s=1 -> (acceptor2_s'=0);
    [proposer2_promise2] acceptor2_s=1 -> (acceptor2_s'=0);
    [accept1] acceptor2_accept_status=0 -> (acceptor2_ballot_buffer'=proposer1_next_ballot-1)&(acceptor2_value_buffer'=proposer1_candidate_value)&(acceptor2_accept_status'=1);
    [accept2] acceptor2_accept_status=0 -> (acceptor2_ballot_buffer'=proposer2_next_ballot-1)&(acceptor2_value_buffer'=proposer2_candidate_value)&(acceptor2_accept_status'=1);
    [] acceptor2_accept_status=1&acceptor2_ballot_buffer>=acceptor2_most_recent_ballot -> (acceptor2_most_recent_ballot'=acceptor2_ballot_buffer)&(acceptor2_last_accepted_ballot'=acceptor2_ballot_buffer)&(acceptor2_last_accepted_value'=acceptor2_value_buffer)&(acceptor2_s'=3)&(acceptor2_accept_status'=0);
    [] acceptor2_accept_status=1&acceptor2_ballot_buffer<acceptor2_most_recent_ballot -> (acceptor2_accept_status'=0);
    [notify2] acceptor2_s=3 -> (acceptor2_s'=4);
endmodule
const int acceptor3_id = 3;
module acceptor3_Acceptor
    acceptor3_s : [0..5] init 0;
    acceptor3_most_recent_ballot : int init -1;
    acceptor3_last_accepted_ballot : int init -1;
    acceptor3_last_accepted_value : [0..2] init 0;
    acceptor3_ballot_buffer : int init -1;
    acceptor3_value_buffer : [0..2] init 1;
    acceptor3_prepare_status : [0..1] init 0;
    acceptor3_accept_status : [0..1] init 0;

    [prepare1] acceptor3_s=0&acceptor3_prepare_status=0 -> (acceptor3_ballot_buffer'=proposer1_next_ballot)&(acceptor3_prepare_status'=1);
    [prepare2] acceptor3_s=0&acceptor3_prepare_status=0 -> (acceptor3_ballot_buffer'=proposer2_next_ballot)&(acceptor3_prepare_status'=1);
    [] acceptor3_prepare_status=1&acceptor3_ballot_buffer>acceptor3_most_recent_ballot -> (acceptor3_most_recent_ballot'=acceptor3_ballot_buffer)&(acceptor3_s'=1)&(acceptor3_prepare_status'=0);
    [] acceptor3_prepare_status=1&acceptor3_ballot_buffer<=acceptor3_most_recent_ballot -> (acceptor3_prepare_status'=0);
    [proposer1_promise3] acceptor3_s=1 -> (acceptor3_s'=0);
    [proposer2_promise3] acceptor3_s=1 -> (acceptor3_s'=0);
    [accept1] acceptor3_accept_status=0 -> (acceptor3_ballot_buffer'=proposer1_next_ballot-1)&(acceptor3_value_buffer'=proposer1_candidate_value)&(acceptor3_accept_status'=1);
    [accept2] acceptor3_accept_status=0 -> (acceptor3_ballot_buffer'=proposer2_next_ballot-1)&(acceptor3_value_buffer'=proposer2_candidate_value)&(acceptor3_accept_status'=1);
    [] acceptor3_accept_status=1&acceptor3_ballot_buffer>=acceptor3_most_recent_ballot -> (acceptor3_most_recent_ballot'=acceptor3_ballot_buffer)&(acceptor3_last_accepted_ballot'=acceptor3_ballot_buffer)&(acceptor3_last_accepted_value'=acceptor3_value_buffer)&(acceptor3_s'=3)&(acceptor3_accept_status'=0);
    [] acceptor3_accept_status=1&acceptor3_ballot_buffer<acceptor3_most_recent_ballot -> (acceptor3_accept_status'=0);
    [notify3] acceptor3_s=3 -> (acceptor3_s'=4);
endmodule
module learner_Learner
    learner_accepted_count : [0..3] init 0;
    learner_accepted1 : bool init false;
    learner_accepted2 : bool init false;
    learner_accepted3 : bool init false;
    learner_current_ballot : int init -1;
    learner_chosen_value : [0..2] init 1;
    learner_ballot_buffer : int init -1;
    learner_value_buffer : [0..2] init 1;
    learner_acceptor_id_buffer : [0..3] init 0;
    learner_status : [0..2] init 0;
    learner_finish : bool init false;

    [succeed] learner_finish -> true;
    [notify1] learner_status=0 -> (learner_acceptor_id_buffer'=1)&(learner_ballot_buffer'=acceptor1_last_accepted_ballot)&(learner_value_buffer'=acceptor1_last_accepted_value)&(learner_status'=1);
    [notify2] learner_status=0 -> (learner_acceptor_id_buffer'=2)&(learner_ballot_buffer'=acceptor2_last_accepted_ballot)&(learner_value_buffer'=acceptor2_last_accepted_value)&(learner_status'=1);
    [notify3] learner_status=0 -> (learner_acceptor_id_buffer'=3)&(learner_ballot_buffer'=acceptor3_last_accepted_ballot)&(learner_value_buffer'=acceptor3_last_accepted_value)&(learner_status'=1);
    [] learner_status=1&learner_ballot_buffer>learner_current_ballot&learner_acceptor_id_buffer=1 -> (learner_current_ballot'=learner_ballot_buffer)&(learner_chosen_value'=learner_value_buffer)&(learner_accepted_count'=1)&(learner_accepted1'=true)&(learner_accepted2'=false)&(learner_accepted3'=false)&(learner_status'=2);
    [] learner_status=1&learner_ballot_buffer>learner_current_ballot&learner_acceptor_id_buffer=2 -> (learner_current_ballot'=learner_ballot_buffer)&(learner_chosen_value'=learner_value_buffer)&(learner_accepted_count'=1)&(learner_accepted1'=false)&(learner_accepted2'=true)&(learner_accepted3'=false)&(learner_status'=2);
    [] learner_status=1&learner_ballot_buffer>learner_current_ballot&learner_acceptor_id_buffer=3 -> (learner_current_ballot'=learner_ballot_buffer)&(learner_chosen_value'=learner_value_buffer)&(learner_accepted_count'=1)&(learner_accepted1'=false)&(learner_accepted2'=false)&(learner_accepted3'=true)&(learner_status'=2);
    [] learner_status=1&learner_ballot_buffer=learner_current_ballot&!learner_accepted1 -> (learner_accepted_count'=learner_accepted_count+1)&(learner_accepted1'=true)&(learner_status'=2);
    [] learner_status=1&learner_ballot_buffer=learner_current_ballot&!learner_accepted2 -> (learner_accepted_count'=learner_accepted_count+1)&(learner_accepted2'=true)&(learner_status'=2);
    [] learner_status=1&learner_ballot_buffer=learner_current_ballot&!learner_accepted3 -> (learner_accepted_count'=learner_accepted_count+1)&(learner_accepted3'=true)&(learner_status'=2);
    [] learner_status=2&learner_accepted_count>2 -> (learner_status'=0)&(learner_finish'=true);
    [] learner_status=2&learner_accepted_count<=2 -> (learner_status'=0);
endmodule
module Paxos

endmodule
