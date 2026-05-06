pta

const double clock_time = 0.000000001;
const double poling_time = 0.001;
const double delay_time = 0.05;

const int led_update_cycle = 1000000;
const int button_update_cycle = 1000000;
const int delay_cycle = 50; // Corrected from 20

// Port mappings via formulas
formula debounced_toggle_button_pressed_readReady=debounced_toggle_debouncer_raw_signal_readReady;
formula debounced_toggle_debouncer_raw_signal_writeReady=debounced_toggle_button_pressed_writeReady;
formula debounced_toggle_debouncer_raw_signal_value=debounced_toggle_button_pressed_value;

formula debounced_toggle_debouncer_filtered_latch_readReady=debounced_toggle_led_emit_light_readReady;
formula debounced_toggle_led_emit_light_writeReady=debounced_toggle_debouncer_filtered_latch_writeReady;
formula debounced_toggle_led_emit_light_value=debounced_toggle_debouncer_filtered_latch_value;

module debounced_toggle
   entity_clock: clock;
   
   // Added invariant to bound the clock and force transitions
   invariant entity_clock <= led_update_cycle endinvariant
   
   // Reset the clock once the cycle limit is hit to create continuous polling
   [tick] entity_clock = led_update_cycle -> (entity_clock' = 0);
endmodule

module debounced_toggle_led
   debounced_toggle_led_emit_light_readReady: [0..1] init 0;
endmodule

module debounced_toggle_button
   debounced_toggle_button_pressed_writeReady: [0..1] init 0;
   debounced_toggle_button_pressed_value: [0..1] init 0;
endmodule

module debounced_toggle_debouncer
   debounced_toggle_debouncer_raw_signal_readReady: [0..1] init 0;

   debounced_toggle_debouncer_filtered_latch_writeReady: [0..1] init 0;
   debounced_toggle_debouncer_filtered_latch_value: [0..1] init 0;
   
   debounced_toggle_debouncer_output: [0..1] init 0;
   debounced_toggle_debouncer_prev_output: [0..1] init 0;
   debounced_toggle_debouncer_prev_input: [0..1] init 0;
   
   debounced_toggle_delay_counter: [0..delay_cycle] init 0;

   // Work around pta model not supporting X operator, because it is ambiguous whether it's next clock or next state
   obs_61_premise : [0..1] init 0;
   obs_63_premise : [0..1] init 0;
   obs_64_prev_counter : [0..delay_cycle] init 0;
   obs_step_taken : [0..1] init 0;

   // active-only transition
   [] entity_clock = led_update_cycle & debounced_toggle_debouncer_prev_output != debounced_toggle_debouncer_output ->
        (debounced_toggle_debouncer_prev_output' = debounced_toggle_debouncer_output) &
        (debounced_toggle_debouncer_filtered_latch_value' = debounced_toggle_debouncer_output) &
        (debounced_toggle_debouncer_filtered_latch_writeReady' = 1) &
        // Update Observers
        (obs_61_premise' = (debounced_toggle_debouncer_raw_signal_value=1 & debounced_toggle_debouncer_prev_input=0 & debounced_toggle_delay_counter=0 ? 1 : 0)) &
        (obs_63_premise' = (debounced_toggle_debouncer_prev_output != debounced_toggle_debouncer_output ? 1 : 0)) &
        (obs_64_prev_counter' = debounced_toggle_delay_counter) &
        (obs_step_taken' = 1);

   // passive-only transition (counter == 0)
   [] entity_clock = button_update_cycle & debounced_toggle_delay_counter = 0 ->
        (debounced_toggle_debouncer_prev_input' = debounced_toggle_debouncer_raw_signal_value) &
        (debounced_toggle_debouncer_output' = (debounced_toggle_debouncer_prev_input=0 & debounced_toggle_debouncer_raw_signal_value=1) ? (1 - debounced_toggle_debouncer_output) : debounced_toggle_debouncer_output) &
        (debounced_toggle_delay_counter' = (debounced_toggle_debouncer_prev_input=0 & debounced_toggle_debouncer_raw_signal_value=1) ? delay_cycle : 0) &
        (debounced_toggle_debouncer_raw_signal_readReady' = 1) &
        // Update Observers
        (obs_61_premise' = (debounced_toggle_debouncer_raw_signal_value=1 & debounced_toggle_debouncer_prev_input=0 & debounced_toggle_delay_counter=0 ? 1 : 0)) &
        (obs_63_premise' = (debounced_toggle_debouncer_prev_output != debounced_toggle_debouncer_output ? 1 : 0)) &
        (obs_64_prev_counter' = debounced_toggle_delay_counter) &
        (obs_step_taken' = 1);

   // passive-only transition (counter > 0)
   [] entity_clock = button_update_cycle & debounced_toggle_delay_counter > 0 ->
        (debounced_toggle_delay_counter' = debounced_toggle_delay_counter - 1) &
        (debounced_toggle_debouncer_raw_signal_readReady' = 1) &
        // Update Observers
        (obs_61_premise' = (debounced_toggle_debouncer_raw_signal_value=1 & debounced_toggle_debouncer_prev_input=0 & debounced_toggle_delay_counter=0 ? 1 : 0)) &
        (obs_63_premise' = (debounced_toggle_debouncer_prev_output != debounced_toggle_debouncer_output ? 1 : 0)) &
        (obs_64_prev_counter' = debounced_toggle_delay_counter) &
        (obs_step_taken' = 1);

endmodule