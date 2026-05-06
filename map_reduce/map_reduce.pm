mdp

const int str_len = 6;
const int mapper_count = 2;
const int combiner_count = 3;
const int mapper_buffer_length = 3;

formula prepare_input_0_0 = 99;
formula prepare_input_1_0 = 97;
formula prepare_input_2_0 = 98;
formula prepare_input_0_1 = 97;
formula prepare_input_1_1 = 99;
formula prepare_input_2_1 = 97;

formula r_result_out_value_0 = r_result_0;
formula r_result_out_value_1 = r_result_1;
formula r_result_out_value_2 = r_result_2;

module driver
    mapper_launched: [0..3] init 0;

    [r_result_out]
        mapper_launched = 2 ->
//            (print_r_result_out_value_0)
//            & (print_r_result_out_value_1)
//            & (print_r_result_out_value_2);
            (mapper_launched' = 3); // manually fixing this bootstrap code

    [m0_text_in]
        mapper_launched < 2 & mapper_launched = 0->
            (mapper_launched'=mapper_launched + 1);
    [m1_text_in]
        mapper_launched < 2 & mapper_launched = 1->
            (mapper_launched'=mapper_launched + 1);
endmodule


formula m0_text_in_0_value=prepare_input_0_0;
formula m0_text_in_1_value=prepare_input_1_0;
formula m0_text_in_2_value=prepare_input_2_0;

module m0_mapper
    m0_pointer: [0 .. 4] init 4;
    m0_text_buff_0: [97 .. 99] init 97;
    m0_text_buff_1: [97 .. 99] init 97;
    m0_text_buff_2: [97 .. 99] init 97;

    [m0_text_in]
        m0_pointer = 4 ->
            (m0_pointer'=0)
            & (m0_text_buff_0'=m0_text_in_0_value)
            & (m0_text_buff_1'=m0_text_in_1_value)
            & (m0_text_buff_2'=m0_text_in_2_value);
    [m0_map_out_arr__mcq0_mergeIn_0__mcq1_mergeIn_0__mcq2_mergeIn_0]
        m0_pointer = 3 ->
            (m0_pointer'=m0_pointer+1);
    [m0_map_out_arr_0__mcq0_mergeIn_0]
        m0_pointer = 0 & m0_text_buff_0 = 97 ->
            (m0_pointer'=m0_pointer+1);
    [m0_map_out_arr_1__mcq1_mergeIn_0]
        m0_pointer = 0 & m0_text_buff_0 = 98 ->
            (m0_pointer'=m0_pointer+1);
    [m0_map_out_arr_2__mcq2_mergeIn_0]
        m0_pointer = 0 & m0_text_buff_0 = 99 ->
            (m0_pointer'=m0_pointer+1);
    [m0_map_out_arr_0__mcq0_mergeIn_0]
        m0_pointer = 1 & m0_text_buff_1 = 97 ->
            (m0_pointer'=m0_pointer+1);
    [m0_map_out_arr_1__mcq1_mergeIn_0]
        m0_pointer = 1 & m0_text_buff_1 = 98 ->
            (m0_pointer'=m0_pointer+1);
    [m0_map_out_arr_2__mcq2_mergeIn_0]
        m0_pointer = 1 & m0_text_buff_1 = 99 ->
            (m0_pointer'=m0_pointer+1);
    [m0_map_out_arr_0__mcq0_mergeIn_0]
        m0_pointer = 2 & m0_text_buff_2 = 97 ->
            (m0_pointer'=m0_pointer+1);
    [m0_map_out_arr_1__mcq1_mergeIn_0]
        m0_pointer = 2 & m0_text_buff_2 = 98 ->
            (m0_pointer'=m0_pointer+1);
    [m0_map_out_arr_2__mcq2_mergeIn_0]
        m0_pointer = 2 & m0_text_buff_2 = 99 ->
            (m0_pointer'=m0_pointer+1);
endmodule


formula m1_text_in_0_value=prepare_input_0_1;
formula m1_text_in_1_value=prepare_input_1_1;
formula m1_text_in_2_value=prepare_input_2_1;

module m1_mapper
    m1_pointer: [0 .. 4] init 4;
    m1_text_buff_0: [97 .. 99] init 97;
    m1_text_buff_1: [97 .. 99] init 97;
    m1_text_buff_2: [97 .. 99] init 97;

    [m1_text_in]
        m1_pointer = 4 ->
            (m1_pointer'=0)
            & (m1_text_buff_0'=m1_text_in_0_value)
            & (m1_text_buff_1'=m1_text_in_1_value)
            & (m1_text_buff_2'=m1_text_in_2_value);
    [m1_map_out_arr__mcq0_mergeIn_0__mcq1_mergeIn_0__mcq2_mergeIn_0]
        m1_pointer = 3 ->
            (m1_pointer'=m1_pointer+1);
    [m1_map_out_arr_0__mcq0_mergeIn_0]
        m1_pointer = 0 & m1_text_buff_0 = 97 ->
            (m1_pointer'=m1_pointer+1);
    [m1_map_out_arr_1__mcq1_mergeIn_0]
        m1_pointer = 0 & m1_text_buff_0 = 98 ->
            (m1_pointer'=m1_pointer+1);
    [m1_map_out_arr_2__mcq2_mergeIn_0]
        m1_pointer = 0 & m1_text_buff_0 = 99 ->
            (m1_pointer'=m1_pointer+1);
    [m1_map_out_arr_0__mcq0_mergeIn_0]
        m1_pointer = 1 & m1_text_buff_1 = 97 ->
            (m1_pointer'=m1_pointer+1);
    [m1_map_out_arr_1__mcq1_mergeIn_0]
        m1_pointer = 1 & m1_text_buff_1 = 98 ->
            (m1_pointer'=m1_pointer+1);
    [m1_map_out_arr_2__mcq2_mergeIn_0]
        m1_pointer = 1 & m1_text_buff_1 = 99 ->
            (m1_pointer'=m1_pointer+1);
    [m1_map_out_arr_0__mcq0_mergeIn_0]
        m1_pointer = 2 & m1_text_buff_2 = 97 ->
            (m1_pointer'=m1_pointer+1);
    [m1_map_out_arr_1__mcq1_mergeIn_0]
        m1_pointer = 2 & m1_text_buff_2 = 98 ->
            (m1_pointer'=m1_pointer+1);
    [m1_map_out_arr_2__mcq2_mergeIn_0]
        m1_pointer = 2 & m1_text_buff_2 = 99 ->
            (m1_pointer'=m1_pointer+1);
endmodule


formula mcq0_mergeIn_0_value=0;
formula mcq0_mergeIn_1_value=0;
formula mcq0_mergeIn_0_value_=1;
formula mcq0_mergeIn_1_value_=1;

module mcq0_MergerQueue
    mcq0_buffer_0: [0 .. 1] init 0;
    mcq0_buffer_1: [0 .. 1] init 0;
    mcq0_buffer_2: [0 .. 1] init 0;
    mcq0_phead: [0 .. 2] init 0;
    mcq0_ptail: [0 .. 2] init 0;

    [m0_map_out_arr__mcq0_mergeIn_0__mcq1_mergeIn_0__mcq2_mergeIn_0]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 0 ->
            (mcq0_buffer_0' = mcq0_mergeIn_0_value)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));
    [m1_map_out_arr__mcq0_mergeIn_1__mcq1_mergeIn_1__mcq2_mergeIn_1]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 0 ->
            (mcq0_buffer_0' = mcq0_mergeIn_1_value)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));

    [m0_map_out_arr__mcq0_mergeIn_0__mcq1_mergeIn_0__mcq2_mergeIn_0]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 1 ->
            (mcq0_buffer_1' = mcq0_mergeIn_0_value)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));
    [m1_map_out_arr__mcq0_mergeIn_1__mcq1_mergeIn_1__mcq2_mergeIn_1]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 1 ->
            (mcq0_buffer_1' = mcq0_mergeIn_1_value)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));

    [m0_map_out_arr__mcq0_mergeIn_0__mcq1_mergeIn_0__mcq2_mergeIn_0]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 2 ->
            (mcq0_buffer_2' = mcq0_mergeIn_0_value)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));
    [m1_map_out_arr__mcq0_mergeIn_1__mcq1_mergeIn_1__mcq2_mergeIn_1]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 2 ->
            (mcq0_buffer_2' = mcq0_mergeIn_1_value)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));

    [m0_map_out_arr_0__mcq0_mergeIn_0]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 0 ->
            (mcq0_buffer_0' = mcq0_mergeIn_0_value_)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));
    [m1_map_out_arr_1__mcq0_mergeIn_1]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 0 ->
            (mcq0_buffer_0' = mcq0_mergeIn_1_value_)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));
    [m0_map_out_arr_0__mcq0_mergeIn_0]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 1 ->
            (mcq0_buffer_1' = mcq0_mergeIn_0_value_)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));
    [m1_map_out_arr_1__mcq0_mergeIn_1]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 1 ->
            (mcq0_buffer_1' = mcq0_mergeIn_1_value_)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));
    [m0_map_out_arr_0__mcq0_mergeIn_0]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 2 ->
            (mcq0_buffer_2' = mcq0_mergeIn_0_value_)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));
    [m1_map_out_arr_1__mcq0_mergeIn_1]
        mod((mcq0_ptail+1),3)!=mcq0_phead & mcq0_phead = 2 ->
            (mcq0_buffer_2' = mcq0_mergeIn_1_value_)
            & (mcq0_phead' = mod(mcq0_phead + 1, 3));

    [mcq0_dequeue__cb0_map_in]
        mcq0_ptail!=mcq0_phead ->
            (mcq0_ptail' = mod(mcq0_ptail + 1, 3));
endmodule

formula mcq1_mergeIn_0_value=0;
formula mcq1_mergeIn_1_value=0;
formula mcq1_mergeIn_0_value_=1;
formula mcq1_mergeIn_1_value_=1;

module mcq1_MergerQueue
    mcq1_buffer_0: [0 .. 1] init 0;
    mcq1_buffer_1: [0 .. 1] init 0;
    mcq1_buffer_2: [0 .. 1] init 0;
    mcq1_phead: [0 .. 2] init 0;
    mcq1_ptail: [0 .. 2] init 0;

    [m0_map_out_arr__mcq0_mergeIn_0__mcq1_mergeIn_0__mcq2_mergeIn_0]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 0 ->
            (mcq1_buffer_0' = mcq1_mergeIn_0_value)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));
    [m1_map_out_arr__mcq0_mergeIn_1__mcq1_mergeIn_1__mcq2_mergeIn_1]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 0 ->
            (mcq1_buffer_0' = mcq1_mergeIn_1_value)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));

    [m0_map_out_arr__mcq0_mergeIn_0__mcq1_mergeIn_0__mcq2_mergeIn_0]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 1 ->
            (mcq1_buffer_1' = mcq1_mergeIn_0_value)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));
    [m1_map_out_arr__mcq0_mergeIn_1__mcq1_mergeIn_1__mcq2_mergeIn_1]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 1 ->
            (mcq1_buffer_1' = mcq1_mergeIn_1_value)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));

    [m0_map_out_arr__mcq0_mergeIn_0__mcq1_mergeIn_0__mcq2_mergeIn_0]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 2 ->
            (mcq1_buffer_2' = mcq1_mergeIn_0_value)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));
    [m1_map_out_arr__mcq0_mergeIn_1__mcq1_mergeIn_1__mcq2_mergeIn_1]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 2 ->
            (mcq1_buffer_2' = mcq1_mergeIn_1_value)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));

    [m0_map_out_arr_0__mcq1_mergeIn_0]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 0 ->
            (mcq1_buffer_0' = mcq1_mergeIn_0_value_)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));
    [m1_map_out_arr_1__mcq1_mergeIn_1]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 0 ->
            (mcq1_buffer_0' = mcq1_mergeIn_1_value_)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));
    [m0_map_out_arr_0__mcq1_mergeIn_0]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 1 ->
            (mcq1_buffer_1' = mcq1_mergeIn_0_value_)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));
    [m1_map_out_arr_1__mcq1_mergeIn_1]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 1 ->
            (mcq1_buffer_1' = mcq1_mergeIn_1_value_)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));
    [m0_map_out_arr_0__mcq1_mergeIn_0]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 2 ->
            (mcq1_buffer_2' = mcq1_mergeIn_0_value_)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));
    [m1_map_out_arr_1__mcq1_mergeIn_1]
        mod((mcq1_ptail+1),3)!=mcq1_phead & mcq1_phead = 2 ->
            (mcq1_buffer_2' = mcq1_mergeIn_1_value_)
            & (mcq1_phead' = mod(mcq1_phead + 1, 3));

    [mcq1_dequeue__cb1_map_in]
        mcq1_ptail!=mcq1_phead ->
            (mcq1_ptail' = mod(mcq1_ptail + 1, 3));
endmodule


formula mcq2_mergeIn_0_value=0;
formula mcq2_mergeIn_1_value=0;
formula mcq2_mergeIn_0_value_=1;
formula mcq2_mergeIn_1_value_=1;

module mcq2_MergerQueue
    mcq2_buffer_0: [0 .. 1] init 0;
    mcq2_buffer_1: [0 .. 1] init 0;
    mcq2_buffer_2: [0 .. 1] init 0;
    mcq2_phead: [0 .. 2] init 0;
    mcq2_ptail: [0 .. 2] init 0;

    [m0_map_out_arr__mcq0_mergeIn_0__mcq1_mergeIn_0__mcq2_mergeIn_0]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 0 ->
            (mcq2_buffer_0' = mcq2_mergeIn_0_value)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));
    [m1_map_out_arr__mcq0_mergeIn_1__mcq1_mergeIn_1__mcq2_mergeIn_1]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 0 ->
            (mcq2_buffer_0' = mcq2_mergeIn_1_value)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));

    [m0_map_out_arr__mcq0_mergeIn_0__mcq1_mergeIn_0__mcq2_mergeIn_0]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 1 ->
            (mcq2_buffer_1' = mcq2_mergeIn_0_value)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));
    [m1_map_out_arr__mcq0_mergeIn_1__mcq1_mergeIn_1__mcq2_mergeIn_1]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 1 ->
            (mcq2_buffer_1' = mcq2_mergeIn_1_value)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));

    [m0_map_out_arr__mcq0_mergeIn_0__mcq1_mergeIn_0__mcq2_mergeIn_0]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 2 ->
            (mcq2_buffer_2' = mcq2_mergeIn_0_value)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));
    [m1_map_out_arr__mcq0_mergeIn_1__mcq1_mergeIn_1__mcq2_mergeIn_1]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 2 ->
            (mcq2_buffer_2' = mcq2_mergeIn_1_value)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));

    [m0_map_out_arr_0__mcq2_mergeIn_0]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 0 ->
            (mcq2_buffer_0' = mcq2_mergeIn_0_value_)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));
    [m1_map_out_arr_1__mcq2_mergeIn_1]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 0 ->
            (mcq2_buffer_0' = mcq2_mergeIn_1_value_)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));
    [m0_map_out_arr_0__mcq2_mergeIn_0]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 1 ->
            (mcq2_buffer_1' = mcq2_mergeIn_0_value_)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));
    [m1_map_out_arr_1__mcq2_mergeIn_1]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 1 ->
            (mcq2_buffer_1' = mcq2_mergeIn_1_value_)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));
    [m0_map_out_arr_0__mcq2_mergeIn_0]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 2 ->
            (mcq2_buffer_2' = mcq2_mergeIn_0_value_)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));
    [m1_map_out_arr_1__mcq2_mergeIn_1]
        mod((mcq2_ptail+1),3)!=mcq2_phead & mcq2_phead = 2 ->
            (mcq2_buffer_2' = mcq2_mergeIn_1_value_)
            & (mcq2_phead' = mod(mcq2_phead + 1, 3));

    [mcq2_dequeue__cb2_map_in]
        mcq2_ptail!=mcq2_phead ->
            (mcq2_ptail' = mod(mcq2_ptail + 1, 3));
endmodule


formula cb0_map_in_value=mcq0_ptail=0?mcq0_buffer_0:
    mcq0_ptail=1?mcq0_buffer_1:
    mcq0_ptail=2?mcq0_buffer_2:0;

module cb0_combiner
    cb0_mapper_done: [0 .. 3] init 0;
    cb0_ch_count: [0 .. 6] init 0;

    [mcq0_dequeue__cb0_map_in]
        cb0_mapper_done < 3 ->
            (cb0_mapper_done'=cb0_map_in_value=1?cb0_mapper_done:mod((cb0_mapper_done+1),3))
            & (cb0_ch_count'=cb0_map_in_value=1?mod((cb0_ch_count+1),3):cb0_ch_count);

    [cb0_reduce_out__r_reduce_in_arr_0]
        cb0_mapper_done = 3 ->
            (cb0_mapper_done'=0)
            & (cb0_ch_count'=0);
endmodule


formula cb1_map_in_value=mcq1_ptail=0?mcq1_buffer_0:
    mcq1_ptail=1?mcq1_buffer_1:
    mcq1_ptail=2?mcq1_buffer_2:0;

module cb1_combiner
    cb1_mapper_done: [0 .. 3] init 0;
    cb1_ch_count: [0 .. 6] init 0;

    [mcq1_dequeue__cb1_map_in]
        cb1_mapper_done < 3 ->
            (cb1_mapper_done'=cb1_map_in_value=1?cb1_mapper_done:mod((cb1_mapper_done+1),3))
            & (cb1_ch_count'=cb1_map_in_value=1?mod((cb1_ch_count+1),3):cb1_ch_count);

    [cb1_reduce_out__r_reduce_in_arr_1]
        cb1_mapper_done = 3 ->
            (cb1_mapper_done'=0)
            & (cb1_ch_count'=0);
endmodule


formula cb2_map_in_value=mcq2_ptail=0?mcq2_buffer_0:
    mcq2_ptail=1?mcq2_buffer_1:
    mcq2_ptail=2?mcq2_buffer_2:0;

module cb2_combiner
    cb2_mapper_done: [0 .. 3] init 0;
    cb2_ch_count: [0 .. 6] init 0;

    [mcq2_dequeue__cb2_map_in]
        cb2_mapper_done < 3 ->
            (cb2_mapper_done'=cb2_map_in_value=1?cb2_mapper_done:mod((cb2_mapper_done+1),3))
            & (cb2_ch_count'=cb2_map_in_value=1?mod((cb2_ch_count+1),3):cb2_ch_count);

    [cb2_reduce_out__r_reduce_in_arr_2]
        cb2_mapper_done = 3 ->
            (cb2_mapper_done'=0)
            & (cb2_ch_count'=0);
endmodule


formula r_reduce_in_arr_0_value=cb0_ch_count;
formula r_reduce_in_arr_1_value=cb1_ch_count;
formula r_reduce_in_arr_2_value=cb2_ch_count;

module r_reducer
    r_processing: [0..3] init 0;
    r_char_count: [0..6] init 0;
    r_result_0: [0..6] init 0;
    r_result_1: [0..6] init 0;
    r_result_2: [0..6] init 0;

    [r_result_out]
        r_char_count = 6 ->
            (r_processing'=0)
            & (r_char_count'=0)
            & (r_result_0'=0)
            & (r_result_1'=0)
            & (r_result_2'=0);

    [cb0_reduce_out__r_reduce_in_arr_0]
        r_processing < 3 & r_processing = 0->
            (r_result_0'=r_reduce_in_arr_0_value)
            & (r_char_count'=mod(r_char_count+r_reduce_in_arr_0_value,7))
            & (r_processing'=r_processing+1);

    [cb0_reduce_out__r_reduce_in_arr_1]
        r_processing < 3 & r_processing = 1->
            (r_result_0'=r_reduce_in_arr_1_value)
            & (r_char_count'=mod(r_char_count+r_reduce_in_arr_1_value,7))
            & (r_processing'=r_processing+1);

    [cb0_reduce_out__r_reduce_in_arr_2]
        r_processing < 3 & r_processing = 2->
            (r_result_0'=r_reduce_in_arr_2_value)
            & (r_char_count'=mod(r_char_count+r_reduce_in_arr_2_value,7))
            & (r_processing'=r_processing+1);
endmodule

