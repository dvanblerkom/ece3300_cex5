// alarm_fsm.v  –  Student assignment file
// ECE3300  Exercise: Finite State Machine
//
// ---------------------------------------------------------------
// Alarm System FSM  (Home / Away mode)
//
// INPUTS
//   clk           – system clock (rising-edge triggered)
//   rst           – synchronous reset, active-high; returns to IDLE
//   arm_home      – pulse high one cycle: arm in HOME mode
//   arm_away      – pulse high one cycle: arm in AWAY mode
//   disarm        – pulse high one cycle: disarm / silence alarm
//   door_sensor   – high when the door is open
//   window_sensor – high when a window is open
//   motion_sensor – high when motion is detected
//
// OUTPUTS
//   alarm_armed   – high whenever the system is armed (any mode)
//   alarm_active  – high whenever the alarm is sounding
//   home_mode     – high when armed in HOME mode (motion ignored)
//
// STATES  (you must implement all four)
//
//   IDLE
//     No outputs asserted.
//     arm_home  ->  ARMED_HOME
//     arm_away  ->  ARMED_AWAY
//
//   ARMED_HOME
//     alarm_armed and home_mode asserted.
//     Motion sensor is IGNORED in this state.
//     disarm           ->  IDLE
//     door OR window   ->  TRIGGERED
//
//   ARMED_AWAY
//     alarm_armed asserted; home_mode NOT asserted.
//     All three sensors are active.
//     disarm                        ->  IDLE
//     door OR window OR motion      ->  TRIGGERED
//
//   TRIGGERED
//     alarm_active asserted.
//     disarm  ->  IDLE
//     (stays here until disarmed)
//
// ---------------------------------------------------------------
// TODO: fill in the module below.  Do not change the port list.
// ---------------------------------------------------------------

module alarm_fsm (
    input  wire clk,
    input  wire rst,
    input  wire arm_home,
    input  wire arm_away,
    input  wire disarm,
    input  wire door_sensor,
    input  wire window_sensor,
    input  wire motion_sensor,
    output reg  alarm_armed,
    output reg  alarm_active,
    output reg  home_mode
);

    // ----- State encoding -----
    // Hint: you need 4 states, so 2 bits is enough
    // Example:
    //   localparam IDLE       = 2'b00;
    //   ...etc...



    // ----- State register (sequential block) -----
    // Hint: on posedge clk, if rst -> IDLE, else state <= next_state



    // ----- Next-state logic (combinational block) -----
    // Hint: case on current state; remember motion is ignored in ARMED_HOME



    // ----- Output logic (combinational, Moore machine) -----
    // Hint:
    //   alarm_armed  is true in ARMED_HOME and ARMED_AWAY
    //   alarm_active is true in TRIGGERED
    //   home_mode    is true only in ARMED_HOME



endmodule
