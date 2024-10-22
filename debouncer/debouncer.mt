//A few hardware specific parameters must be defined to reflect the timing conversions beforehand:
const real clock_time = 1e-9; //software operating on 1GHz processor
const real poling_time = 1e-3; //hardware reaction time 1ms
const real delay_time = 5e-2; //filter out glitches under 50 ms

const int led_update_cycle = poling_time / clock_time; 
const int button_update_cycle = poling_time / clock_time; 
const int delay_cycle = delay_time / poling_time; 

//Then, a full controller model can be specified:
automaton delay_controller(raw_signal:in bool, filtered_latch:out bool) {
    states {
        bool output = false;
        bool prev_output = false;
        bool prev_input = false;
        int 0..delay_cycle delay_counter = 0;
    }

    transitions {
        active-only clock % led_update_cycle == 0 && prev_output != output-> {
            prev_output = output; 
            filtered_latch.value = output;
            sync filtered_latch;
        }
    
        passive-only clock % button_update_cycle == 0 && delay_counter == 0-> {
            sync raw_signal;
            prev_input = raw_signal.value;
            output = !prev_input && raw_signal.value:!output:output;
            delay_counter = !prev_input && raw_signal.value?delay_cycle:0;
        }
        
        passive-only clock % button_update_cycle == 0 -> {
            sync raw_signal;
            delay_counter = delay_counter - 1;
        }
    }
}

//To complete the closed entity, we will have to define environment interfacing automaton and link them with the controller:
automaton button_sensor(pressed:out bool);
automaton led_actuator(emit_light:in bool);
automaton debounced_toggle() { \\top level connections
    states {
        button_sensor button;
        led_actuator led;
        delay_controller debouncer;
    }
    inits {
        button.pressed -> delay_controller.raw_signal; //passive link
        led.emit_light <- delay_controller.filtered_latch; //active link
    }
}