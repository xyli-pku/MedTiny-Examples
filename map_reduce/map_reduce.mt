const 120 as str_len;
const 5 as mapper_count;
const 26 as combiner_count;
const str_len/mapper_count as mapper_buffer_length;

function <length:int> fill(content:int):int[length];
function prepare_input():int[mapper_buffer_length][mapper_count];
function print():void;

automaton mapper(text_in: in char[mapper_buffer_length], map_out_arr[combiner_count]: out int 0..1) {
    states {
        int 0..mapper_buffer_length+1 pointer = mapper_buffer_length+1;
        char[mapper_buffer_length] text_buff = fill<mapper_buffer_length>('A');
    }
    transitions {
        auto-sync pointer == mapper_buffer_length + 1 -> {
            sync text_in;
            //text_buff=text_in.value;
            pointer = 0;
        }

        auto-sync pointer == mapper_buffer_length -> {
            for o in map_out_arr {
                o.value=0;
            }
            pointer = pointer + 1;
            sync map_out_arr;
        }

        for oi,o in map_out_arr {
            auto-sync text_buff[pointer] == 'a' + oi -> {
                o.value=1;
                pointer = pointer + 1;
                sync o;
            }
        }
    }
}

automaton combiner(map_in: in int 0..1, reduce_out: out int 0..str_len) {
    states {
        int 0..mapper_count mapper_done = 0;
        int 0..str_len count = 0;
    }
    transitions {
        auto-sync mapper_done < mapper_count -> {
            sync map_in;
            (mapper_done,count) = map_in.value?(mapper_done,count+1):(mapper_done+1,count);
        }

        auto-sync mapper_done == mapper_count -> {
            reduce_out.value=count;
            mapper_done = 0;
            count = 0;
            sync reduce_out;
        }
    }
}

automaton reducer(reduce_in_arr[combiner_count]: in int 0..str_len, result_out: out int 0..str_len [combiner_count]) {
    states {
        int 0..combiner_count processing = 0;
        int 0..str_len char_count = 0;
        int 0..str_len [combiner_count] result = fill<combiner_count>(0);
    }
    transitions {
        auto-sync char_count == str_len -> {
            result_out.value=result;
            processing = 0;
            char_count = 0;
            result = fill<combiner_count>(0);
            sync result_out;
        }

        auto-sync processing < combiner_count -> {
            sync reduce_in_arr[processing];
            result[processing] = reduce_in_arr[processing].value;
            char_count = char_count + result[processing];
            processing = processing + 1;
        }
    }
}

automaton driver() {
    states {
        mapper mappers[mapper_count];
        combiner combiners[combiner_count];
        reducer t_result;
        int 0..mapper_count mapper_launched = 0;
    }
    inits {
        for m in mappers {
            for ci,c in combiners {
                m.map_out_arr[ci] -> c.map_in;
            }
        }
        for ci,c in combiners{
            c.reduce_out->t_result.reduce_in[ci];
        }
    }

    transitions {
        auto-sync mapper_launched == mapper_count -> {
            sync t_result.result_out;
            print(t_result_result_out.value);
        }

        for o in prepare_input() {
            auto-sync mapper_launched<mapper_count-> {
                mappers[mapper_launched].text_in.value=o;
                mapper_launched = mapper_launched + 1;
                sync mappers[mapper_launched].text_in;
            }
        }
    }
}