const int proposer_init_ballot = 0;
const int proposer_ballot_step = 2;
module proposer_Proposer
    proposer_s : [0..5] init 0;
    proposer_next_ballot : int init 0;
    proposer_promise_count : [0..3] init 0;
    proposer_promise1 : bool init false;
    proposer_promise2 : bool init false;
    proposer_promise3 : bool init false;
    proposer_candidate_value : [0..3] init 0;
    proposer_most_recent_ballot : int init -2;
    proposer_ballot_buffer : int init -1;
    proposer_acceptor_id_buffer : [0..3] init 0;
    proposer_max_vballot_buffer : int init 0;
    proposer_max_value_buffer : [0..3] init 0;
    proposer_promise_status : [0..3] init 0;

    [proposer_send_prepare1] proposer_s=0 -> (proposer_next_ballot'=proposer_next_ballot+2)&(proposer_s'=1);
    [proposer_recv_promise1] proposer_s=1&proposer_promise_status=0 -> (proposer_acceptor_id_buffer'=acceptor1_proposer_promise_id)&(proposer_ballot_buffer'=acceptor1_proposer_promise_ballot)&(proposer_max_vballot_buffer'=acceptor1_proposer_promise_max_vballot)&(proposer_max_value_buffer'=acceptor1_proposer_promise_max_value)&(proposer_promise_status'=1);
    [proposer_recv_promise2] proposer_s=1&proposer_promise_status=0 -> (proposer_acceptor_id_buffer'=acceptor2_proposer_promise_id)&(proposer_ballot_buffer'=acceptor2_proposer_promise_ballot)&(proposer_max_vballot_buffer'=acceptor2_proposer_promise_max_vballot)&(proposer_max_value_buffer'=acceptor2_proposer_promise_max_value)&(proposer_promise_status'=1);
    [proposer_recv_promise3] proposer_s=1&proposer_promise_status=0 -> (proposer_acceptor_id_buffer'=acceptor3_proposer_promise_id)&(proposer_ballot_buffer'=acceptor3_proposer_promise_ballot)&(proposer_max_vballot_buffer'=acceptor3_proposer_promise_max_vballot)&(proposer_max_value_buffer'=acceptor3_proposer_promise_max_value)&(proposer_promise_status'=1);
    [] proposer_promise_status=1&proposer_ballot_buffer=proposer_next_ballot-2&!proposer_promise1&proposer_acceptor_id_buffer=1 -> (proposer_promise1'=true)&(proposer_promise_count'=proposer_promise_count+1)&(proposer_promise_status'=2);
    [] proposer_promise_status=1&proposer_ballot_buffer=proposer_next_ballot-2&!proposer_promise2&proposer_acceptor_id_buffer=2 -> (proposer_promise2'=true)&(proposer_promise_count'=proposer_promise_count+1)&(proposer_promise_status'=2);
    [] proposer_promise_status=1&proposer_ballot_buffer=proposer_next_ballot-2&!proposer_promise3&proposer_acceptor_id_buffer=3 -> (proposer_promise3'=true)&(proposer_promise_count'=proposer_promise_count+1)&(proposer_promise_status'=2);
    [] proposer_promise_status=2&proposer_max_vballot_buffer>proposer_most_recent_ballot -> (proposer_most_recent_ballot'=proposer_max_vballot_buffer)&(proposer_candidate_value'=proposer_max_value_buffer)&(proposer_promise_status'=3);
    [] proposer_promise_status=2&proposer_max_vballot_buffer<=proposer_most_recent_ballot -> (proposer_promise_status'=3);
    [] proposer_promise_status=3&proposer_promise_count>=2 -> (proposer_most_recent_ballot'=-1)&(proposer_promise1'=false)&(proposer_promise2'=false)&(proposer_promise3'=false)&(proposer_promise_count'=0)&(proposer_promise_status'=0)&(proposer_s'=2);
    [] proposer_promise_status=3&proposer_promise_count<2 -> (proposer_promise_status'=0);
    [proposer_send_accept1] proposer_s=2 -> (proposer_s'=4);
endmodule
const int acceptor1_id = 1;
const int acceptor1_value = 1;
module acceptor1_Acceptor
    acceptor1_s : [0..5] init 0;
    acceptor1_most_recent_ballot : int init -1;
    acceptor1_last_accepted_ballot : int init -1;
    acceptor1_last_accepted_value : [0..3] init acceptor1_value;
    acceptor1_ballot_buffer : int init -1;
    acceptor1_value_buffer : [0..3] init 0;
    acceptor1_prepare_status : [0..1] init 0;
    acceptor1_accept_status : [0..1] init 0;

    [acceptor1_recv_prepare1] acceptor1_s=0&acceptor1_prepare_status=0 -> (acceptor1_ballot_buffer'=proposer_acceptor1_prepare_ballot)&(acceptor1_prepare_status'=1);
    [] acceptor1_prepare_status=1&acceptor1_ballot_buffer>acceptor1_most_recent_ballot -> (acceptor1_most_recent_ballot'=acceptor1_ballot_buffer)&(acceptor1_s'=1)&(acceptor1_prepare_status'=0);
    [] acceptor1_prepare_status=1&acceptor1_ballot_buffer<=acceptor1_most_recent_ballot -> (acceptor1_prepare_status'=0);
    [acceptor1_send_promise] acceptor1_s=1 ->(acceptor1_s'=0);
    [acceptor1_recv_accept1] acceptor1_accept_status=0 -> (acceptor1_ballot_buffer'=proposer_acceptor1_accept_ballot)&(acceptor1_value_buffer'=proposer_acceptor1_accept_value)&(acceptor1_accept_status'=1);
    [] acceptor1_accept_status=1&acceptor1_ballot_buffer>=acceptor1_most_recent_ballot -> (acceptor1_most_recent_ballot'=acceptor1_ballot_buffer)&(acceptor1_last_accepted_ballot'=acceptor1_ballot_buffer)&(acceptor1_last_accepted_value'=acceptor1_value_buffer)&(acceptor1_s'=3)&(acceptor1_accept_status'=0);
    [] acceptor1_accept_status=1&acceptor1_ballot_buffer<acceptor1_most_recent_ballot -> (acceptor1_accept_status'=0);
    [send_notify1] acceptor1_s=3 -> (acceptor1_s'=4);
endmodule
const int acceptor2_id = 2;
const int acceptor2_value = 2;
module acceptor2_Acceptor
    acceptor2_s : [0..5] init 0;
    acceptor2_most_recent_ballot : int init -1;
    acceptor2_last_accepted_ballot : int init -1;
    acceptor2_last_accepted_value : [0..3] init acceptor2_value;
    acceptor2_ballot_buffer : int init -1;
    acceptor2_value_buffer : [0..3] init 0;
    acceptor2_prepare_status : [0..1] init 0;
    acceptor2_accept_status : [0..1] init 0;

    [acceptor2_recv_prepare1] acceptor2_s=0&acceptor2_prepare_status=0 -> (acceptor2_ballot_buffer'=proposer_acceptor2_prepare_ballot)&(acceptor2_prepare_status'=1);
    [] acceptor2_prepare_status=1&acceptor2_ballot_buffer>acceptor2_most_recent_ballot -> (acceptor2_most_recent_ballot'=acceptor2_ballot_buffer)&(acceptor2_s'=1)&(acceptor2_prepare_status'=0);
    [] acceptor2_prepare_status=1&acceptor2_ballot_buffer<=acceptor2_most_recent_ballot -> (acceptor2_prepare_status'=0);
    [acceptor2_send_promise] acceptor2_s=1 -> (acceptor2_s'=0);
    [acceptor2_recv_accept1] acceptor2_accept_status=0 -> (acceptor2_ballot_buffer'=proposer_acceptor2_accept_ballot)&(acceptor2_value_buffer'=proposer_acceptor2_accept_value)&(acceptor2_accept_status'=1);
    [] acceptor2_accept_status=1&acceptor2_ballot_buffer>=acceptor2_most_recent_ballot -> (acceptor2_most_recent_ballot'=acceptor2_ballot_buffer)&(acceptor2_last_accepted_ballot'=acceptor2_ballot_buffer)&(acceptor2_last_accepted_value'=acceptor2_value_buffer)&(acceptor2_s'=3)&(acceptor2_accept_status'=0);
    [] acceptor2_accept_status=1&acceptor2_ballot_buffer<acceptor2_most_recent_ballot -> (acceptor2_accept_status'=0);
    [send_notify2] acceptor2_s=3 -> (acceptor2_s'=4);
endmodule
const int acceptor3_id = 3;
const int acceptor3_value = 3;
module acceptor3_Acceptor
    acceptor3_s : [0..5] init 0;
    acceptor3_most_recent_ballot : int init -1;
    acceptor3_last_accepted_ballot : int init -1;
    acceptor3_last_accepted_value : [0..3] init acceptor3_value;
    acceptor3_ballot_buffer : int init -1;
    acceptor3_value_buffer : [0..3] init 0;
    acceptor3_prepare_status : [0..1] init 0;
    acceptor3_accept_status : [0..1] init 0;

    [acceptor3_recv_prepare1] acceptor3_s=0&acceptor3_prepare_status=0 -> (acceptor3_ballot_buffer'=proposer_acceptor3_prepare_ballot)&(acceptor3_prepare_status'=1);
    [] acceptor3_prepare_status=1&acceptor3_ballot_buffer>acceptor3_most_recent_ballot -> (acceptor3_most_recent_ballot'=acceptor3_ballot_buffer)&(acceptor3_s'=1)&(acceptor3_prepare_status'=0);
    [] acceptor3_prepare_status=1&acceptor3_ballot_buffer<=acceptor3_most_recent_ballot -> (acceptor3_prepare_status'=0);
    [acceptor3_send_promise] acceptor3_s=1 -> (acceptor3_s'=0);
    [acceptor3_recv_accept1] acceptor3_accept_status=0 -> (acceptor3_ballot_buffer'=proposer_acceptor3_accept_ballot)&(acceptor3_value_buffer'=proposer_acceptor3_accept_value)&(acceptor3_accept_status'=1);
    [] acceptor3_accept_status=1&acceptor3_ballot_buffer>=acceptor3_most_recent_ballot -> (acceptor3_most_recent_ballot'=acceptor3_ballot_buffer)&(acceptor3_last_accepted_ballot'=acceptor3_ballot_buffer)&(acceptor3_last_accepted_value'=acceptor3_value_buffer)&(acceptor3_s'=3)&(acceptor3_accept_status'=0);
    [] acceptor3_accept_status=1&acceptor3_ballot_buffer<acceptor3_most_recent_ballot -> (acceptor3_accept_status'=0);
    [send_notify3] acceptor3_s=3 -> (acceptor3_s'=4);
endmodule
module learner_Learner
    learner_accepted_count : [0..3] init 0;
    learner_accepted1 : bool init false;
    learner_accepted2 : bool init false;
    learner_accepted3 : bool init false;
    learner_current_ballot : int init -1;
    learner_chosen_value : [0..3] init 0;
    learner_ballot_buffer : int init -1;
    learner_value_buffer : [0..2] init 1;
    learner_acceptor_id_buffer : [0..3] init 0;
    learner_status : [0..2] init 0;
    learner_finish : bool init false;

    [succeed] learner_finish -> true;
    [recv_notify1] learner_status=0 -> (learner_acceptor_id_buffer'=acceptor1_learner_accepted_id)&(learner_ballot_buffer'=acceptor1_learner_accepted_ballot)&(learner_value_buffer'=acceptor1_learner_accepted_value)&(learner_status'=1);
    [recv_notify2] learner_status=0 -> (learner_acceptor_id_buffer'=acceptor2_learner_accepted_id)&(learner_ballot_buffer'=acceptor2_learner_accepted_ballot)&(learner_value_buffer'=acceptor2_learner_accepted_value)&(learner_status'=1);
    [recv_notify3] learner_status=0 -> (learner_acceptor_id_buffer'=acceptor3_learner_accepted_id)&(learner_ballot_buffer'=acceptor3_learner_accepted_ballot)&(learner_value_buffer'=acceptor3_learner_accepted_value)&(learner_status'=1);
    [] learner_status=1&learner_ballot_buffer>learner_current_ballot&learner_acceptor_id_buffer=1 -> (learner_current_ballot'=learner_ballot_buffer)&(learner_chosen_value'=learner_value_buffer)&(learner_accepted_count'=1)&(learner_accepted1'=true)&(learner_accepted2'=false)&(learner_accepted3'=false)&(learner_status'=2);
    [] learner_status=1&learner_ballot_buffer>learner_current_ballot&learner_acceptor_id_buffer=2 -> (learner_current_ballot'=learner_ballot_buffer)&(learner_chosen_value'=learner_value_buffer)&(learner_accepted_count'=1)&(learner_accepted1'=false)&(learner_accepted2'=true)&(learner_accepted3'=false)&(learner_status'=2);
    [] learner_status=1&learner_ballot_buffer>learner_current_ballot&learner_acceptor_id_buffer=3 -> (learner_current_ballot'=learner_ballot_buffer)&(learner_chosen_value'=learner_value_buffer)&(learner_accepted_count'=1)&(learner_accepted1'=false)&(learner_accepted2'=false)&(learner_accepted3'=true)&(learner_status'=2);
    [] learner_status=1&learner_ballot_buffer=learner_current_ballot&!learner_accepted1 -> (learner_accepted_count'=learner_accepted_count+1)&(learner_accepted1'=true)&(learner_status'=2);
    [] learner_status=1&learner_ballot_buffer=learner_current_ballot&!learner_accepted2 -> (learner_accepted_count'=learner_accepted_count+1)&(learner_accepted2'=true)&(learner_status'=2);
    [] learner_status=1&learner_ballot_buffer=learner_current_ballot&!learner_accepted3 -> (learner_accepted_count'=learner_accepted_count+1)&(learner_accepted3'=true)&(learner_status'=2);
    [] learner_status=2&learner_accepted_count>2 -> (learner_finish'=true)&(learner_status'=0);
    [] learner_status=2&learner_accepted_count<=2 -> (learner_status'=0);
endmodule
module proposer_acceptor1_prepare_PrepareAsync
    proposer_acceptor1_prepare_ballot : int init -255;

    [proposer_send_prepare1] proposer_acceptor1_prepare_ballot=-255 -> (proposer_acceptor1_prepare_ballot'=proposer_next_ballot);
    [acceptor1_recv_prepare1] proposer_acceptor1_prepare_ballot!=-255 -> (proposer_acceptor1_prepare_ballot'=-255);
endmodule
module proposer_acceptor2_prepare_PrepareAsync
    proposer_acceptor2_prepare_ballot : int init -255;

    [proposer_send_prepare1] proposer_acceptor2_prepare_ballot=-255 -> (proposer_acceptor2_prepare_ballot'=proposer_next_ballot);
    [acceptor2_recv_prepare1] proposer_acceptor2_prepare_ballot!=-255 -> (proposer_acceptor2_prepare_ballot'=-255);
endmodule
module proposer_acceptor3_prepare_PrepareAsync
    proposer_acceptor3_prepare_ballot : int init -255;

    [proposer_send_prepare1] proposer_acceptor3_prepare_ballot=-255 -> (proposer_acceptor3_prepare_ballot'=proposer_next_ballot);
    [acceptor3_recv_prepare1] proposer_acceptor3_prepare_ballot!=-255 -> (proposer_acceptor3_prepare_ballot'=-255);
endmodule
module proposer_acceptor1_accept_AcceptAsync
    proposer_acceptor1_accept_ballot : int init -255;
    proposer_acceptor1_accept_value : [0..3] init 0;

    [proposer_send_accept1] proposer_acceptor1_accept_ballot=-255 -> (proposer_acceptor1_accept_ballot'=proposer_next_ballot-2)&(proposer_acceptor1_accept_value'=proposer_candidate_value);
    [acceptor1_recv_accept1] proposer_acceptor1_accept_ballot!=-255 -> (proposer_acceptor1_accept_ballot'=-255)&(proposer_acceptor1_accept_value'=0);
endmodule
module proposer_acceptor2_accept_AcceptAsync
    proposer_acceptor2_accept_ballot : int init -255;
    proposer_acceptor2_accept_value : [0..3] init 0;

    [proposer_send_accept1] proposer_acceptor2_accept_ballot=-255 -> (proposer_acceptor2_accept_ballot'=proposer_next_ballot-2)&(proposer_acceptor2_accept_value'=proposer_candidate_value);
    [acceptor2_recv_accept1] proposer_acceptor2_accept_ballot!=-255 -> (proposer_acceptor2_accept_ballot'=-255)&(proposer_acceptor2_accept_value'=0);
endmodule
module proposer_acceptor3_accept_AcceptAsync
    proposer_acceptor3_accept_ballot : int init -255;
    proposer_acceptor3_accept_value : [0..3] init 0;

    [proposer_send_accept1] proposer_acceptor3_accept_ballot=-255 -> (proposer_acceptor3_accept_ballot'=proposer_next_ballot-2)&(proposer_acceptor3_accept_value'=proposer_candidate_value);
    [acceptor3_recv_accept1] proposer_acceptor3_accept_ballot!=-255 -> (proposer_acceptor3_accept_ballot'=-255)&(proposer_acceptor3_accept_value'=0);
endmodule
module acceptor1_proposer_promise_PromiseAsync
    acceptor1_proposer_promise_id : [0..3] init 0;
    acceptor1_proposer_promise_ballot : int init -255;
    acceptor1_proposer_promise_max_vballot : int init -255;
    acceptor1_proposer_promise_max_value : [0..3] init 0;

    [acceptor1_send_promise] acceptor1_proposer_promise_ballot=-255 -> (acceptor1_proposer_promise_id'=1)&(acceptor1_proposer_promise_ballot'=acceptor1_most_recent_ballot)&(acceptor1_proposer_promise_max_vballot'=acceptor1_last_accepted_ballot)&(acceptor1_proposer_promise_max_value'=acceptor1_last_accepted_value);
    [proposer_recv_promise1] acceptor1_proposer_promise_ballot!=-255 -> (acceptor1_proposer_promise_id'=0)&(acceptor1_proposer_promise_ballot'=-255)&(acceptor1_proposer_promise_max_vballot'=-255)&(acceptor1_proposer_promise_max_value'=0);
endmodule
module acceptor2_proposer_promise_PromiseAsync
    acceptor2_proposer_promise_id : [0..3] init 0;
    acceptor2_proposer_promise_ballot : int init -255;
    acceptor2_proposer_promise_max_vballot : int init -255;
    acceptor2_proposer_promise_max_value : [0..3] init 0;

    [acceptor2_send_promise] acceptor2_proposer_promise_ballot=-255 -> (acceptor2_proposer_promise_id'=2)&(acceptor2_proposer_promise_ballot'=acceptor2_most_recent_ballot)&(acceptor2_proposer_promise_max_vballot'=acceptor2_last_accepted_ballot)&(acceptor2_proposer_promise_max_value'=acceptor2_last_accepted_value);
    [proposer_recv_promise2] acceptor2_proposer_promise_ballot!=-255 -> (acceptor2_proposer_promise_id'=0)&(acceptor2_proposer_promise_ballot'=-255)&(acceptor2_proposer_promise_max_vballot'=-255)&(acceptor2_proposer_promise_max_value'=0);
endmodule
module acceptor3_proposer_promise_PromiseAsync
    acceptor3_proposer_promise_id : [0..3] init 0;
    acceptor3_proposer_promise_ballot : int init -255;
    acceptor3_proposer_promise_max_vballot : int init -255;
    acceptor3_proposer_promise_max_value : [0..3] init 0;

    [acceptor3_send_promise] acceptor3_proposer_promise_ballot=-255 -> (acceptor3_proposer_promise_id'=3)&(acceptor3_proposer_promise_ballot'=acceptor3_most_recent_ballot)&(acceptor3_proposer_promise_max_vballot'=acceptor3_last_accepted_ballot)&(acceptor3_proposer_promise_max_value'=acceptor3_last_accepted_value);
    [proposer_recv_promise3] acceptor3_proposer_promise_ballot!=-255 -> (acceptor3_proposer_promise_id'=0)&(acceptor3_proposer_promise_ballot'=-255)&(acceptor3_proposer_promise_max_vballot'=-255)&(acceptor3_proposer_promise_max_value'=0);
endmodule
module acceptor1_learner_accepted_AcceptedAsync
    acceptor1_learner_accepted_id : [0..3] init 0;
    acceptor1_learner_accepted_ballot : int init -255;
    acceptor1_learner_accepted_value : [0..3] init 0;

    [send_notify1] acceptor1_learner_accepted_ballot=-255 -> (acceptor1_learner_accepted_id'=1)&(acceptor1_learner_accepted_ballot'=acceptor1_last_accepted_ballot)&(acceptor1_learner_accepted_value'=acceptor1_last_accepted_value);
    [recv_notify1] acceptor1_learner_accepted_ballot!=-255 -> (acceptor1_learner_accepted_id'=0)&(acceptor1_learner_accepted_ballot'=-255)&(acceptor1_learner_accepted_value'=0);
endmodule
module acceptor2_learner_accepted_AcceptedAsync
    acceptor2_learner_accepted_id : [0..3] init 0;
    acceptor2_learner_accepted_ballot : int init -255;
    acceptor2_learner_accepted_value : [0..3] init 0;

    [send_notify2] acceptor2_learner_accepted_ballot=-255 -> (acceptor2_learner_accepted_id'=2)&(acceptor2_learner_accepted_ballot'=acceptor2_last_accepted_ballot)&(acceptor2_learner_accepted_value'=acceptor2_last_accepted_value);
    [recv_notify2] acceptor2_learner_accepted_ballot!=-255 -> (acceptor2_learner_accepted_id'=0)&(acceptor2_learner_accepted_ballot'=-255)&(acceptor2_learner_accepted_value'=0);
endmodule
module acceptor3_learner_accepted_AcceptedAsync
    acceptor3_learner_accepted_id : [0..3] init 0;
    acceptor3_learner_accepted_ballot : int init -255;
    acceptor3_learner_accepted_value : [0..3] init 0;

    [send_notify3] acceptor3_learner_accepted_ballot=-255 -> (acceptor3_learner_accepted_id'=3)&(acceptor3_learner_accepted_ballot'=acceptor3_last_accepted_ballot)&(acceptor3_learner_accepted_value'=acceptor3_last_accepted_value);
    [recv_notify3] acceptor3_learner_accepted_ballot!=-255 -> (acceptor3_learner_accepted_id'=0)&(acceptor3_learner_accepted_ballot'=-255)&(acceptor3_learner_accepted_value'=0);
endmodule
module Paxos

endmodule
