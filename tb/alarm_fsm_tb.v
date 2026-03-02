// alarm_fsm_tb.v  –  Testbench for alarm_fsm
// ECE3300  Exercise: Finite State Machine
//
// Self-checking testbench.  All tests print PASS or FAIL.
// Uses $finish_and_return(test_fail) so that GitHub Actions
// sees a non-zero exit code and marks the commit red on failure.

`timescale 1ns/1ps

module alarm_fsm_tb;

    // ---- DUT signals ----
    reg  clk, rst;
    reg  arm_home, arm_away, disarm;
    reg  door_sensor, window_sensor, motion_sensor;
    wire alarm_armed, alarm_active, home_mode;

    // ---- Pass/fail tracking ----
    reg test_fail;  // stays 0 unless a check fails

    // ---- Instantiate DUT ----
    alarm_fsm dut (
        .clk          (clk),
        .rst          (rst),
        .arm_home     (arm_home),
        .arm_away     (arm_away),
        .disarm       (disarm),
        .door_sensor  (door_sensor),
        .window_sensor(window_sensor),
        .motion_sensor(motion_sensor),
        .alarm_armed  (alarm_armed),
        .alarm_active (alarm_active),
        .home_mode    (home_mode)
    );

    // ---- 10 ns clock ----
    initial clk = 0;
    always  #5 clk = ~clk;

    // ---- Helper: clear all control inputs ----
    task clear_inputs;
        begin
            arm_home = 0; arm_away = 0; disarm = 0;
            door_sensor = 0; window_sensor = 0; motion_sensor = 0;
        end
    endtask

    // ---- Helper: check outputs one cycle after last posedge ----
    task check;
        input exp_armed;
        input exp_active;
        input exp_home;
        input [8*24:1] label;
        begin
            @(posedge clk); #1;
            if (alarm_armed  !== exp_armed  ||
                alarm_active !== exp_active ||
                home_mode    !== exp_home) begin
                $display("FAIL  [%-24s]  armed=%b active=%b home=%b  (exp %b %b %b)",
                         label,
                         alarm_armed, alarm_active, home_mode,
                         exp_armed,   exp_active,   exp_home);
                test_fail = 1;
            end else begin
                $display("PASS  [%-24s]  armed=%b active=%b home=%b",
                         label, alarm_armed, alarm_active, home_mode);
            end
        end
    endtask

    // ================================================================
    initial begin
        $dumpfile("alarm_fsm_tb.vcd");
        $dumpvars(0, alarm_fsm_tb);

        test_fail = 0;
        rst = 1; clear_inputs;

        // Hold reset two cycles
        @(posedge clk); @(posedge clk); #1;
        rst = 0;

        // ------------------------------------------------------------
        // Test 1 – After reset system is IDLE
        // ------------------------------------------------------------
        check(0, 0, 0, "1: IDLE after reset");

        // ------------------------------------------------------------
        // Test 2 – arm_away -> ARMED_AWAY
        // ------------------------------------------------------------
        arm_away = 1; @(posedge clk); #1; arm_away = 0;
        check(1, 0, 0, "2: ARMED_AWAY");

        // ------------------------------------------------------------
        // Test 3 – Stay in ARMED_AWAY with no sensors
        // ------------------------------------------------------------
        check(1, 0, 0, "3: ARMED_AWAY no sensor");

        // ------------------------------------------------------------
        // Test 4 – Motion triggers alarm in AWAY mode
        // ------------------------------------------------------------
        motion_sensor = 1; @(posedge clk); #1; motion_sensor = 0;
        check(0, 1, 0, "4: TRIGGERED motion/AWAY");

        // ------------------------------------------------------------
        // Test 5 – Alarm stays active without disarm
        // ------------------------------------------------------------
        check(0, 1, 0, "5: TRIGGERED stays");

        // ------------------------------------------------------------
        // Test 6 – Disarm -> IDLE
        // ------------------------------------------------------------
        disarm = 1; @(posedge clk); #1; disarm = 0;
        check(0, 0, 0, "6: IDLE after disarm");

        // ------------------------------------------------------------
        // Test 7 – arm_home -> ARMED_HOME, home_mode asserted
        // ------------------------------------------------------------
        arm_home = 1; @(posedge clk); #1; arm_home = 0;
        check(1, 0, 1, "7: ARMED_HOME");

        // ------------------------------------------------------------
        // Test 8 – Motion does NOT trigger in HOME mode
        // ------------------------------------------------------------
        motion_sensor = 1; @(posedge clk); #1; motion_sensor = 0;
        check(1, 0, 1, "8: HOME motion ignored");

        // ------------------------------------------------------------
        // Test 9 – Door DOES trigger in HOME mode
        // ------------------------------------------------------------
        door_sensor = 1; @(posedge clk); #1; door_sensor = 0;
        check(0, 1, 0, "9: TRIGGERED door/HOME");

        // ------------------------------------------------------------
        // Test 10 – Disarm from TRIGGERED -> IDLE
        // ------------------------------------------------------------
        disarm = 1; @(posedge clk); #1; disarm = 0;
        check(0, 0, 0, "10: IDLE after disarm");

        // ------------------------------------------------------------
        // Test 11 – Window triggers in HOME mode
        // ------------------------------------------------------------
        arm_home = 1; @(posedge clk); #1; arm_home = 0;
        window_sensor = 1; @(posedge clk); #1; window_sensor = 0;
        check(0, 1, 0, "11: TRIGGERED window/HOME");
        disarm = 1; @(posedge clk); #1; disarm = 0;

        // ------------------------------------------------------------
        // Test 12 – Door triggers in AWAY mode
        // ------------------------------------------------------------
        arm_away = 1; @(posedge clk); #1; arm_away = 0;
        door_sensor = 1; @(posedge clk); #1; door_sensor = 0;
        check(0, 1, 0, "12: TRIGGERED door/AWAY");
        disarm = 1; @(posedge clk); #1; disarm = 0;

        // ------------------------------------------------------------
        // Test 13 – Window triggers in AWAY mode
        // ------------------------------------------------------------
        arm_away = 1; @(posedge clk); #1; arm_away = 0;
        window_sensor = 1; @(posedge clk); #1; window_sensor = 0;
        check(0, 1, 0, "13: TRIGGERED window/AWAY");
        disarm = 1; @(posedge clk); #1; disarm = 0;

        // ------------------------------------------------------------
        // Test 14 – Disarm while IDLE is a no-op
        // ------------------------------------------------------------
        disarm = 1; @(posedge clk); #1; disarm = 0;
        check(0, 0, 0, "14: IDLE disarm noop");

        // ------------------------------------------------------------
        // Test 15 – Sync reset from ARMED_HOME
        // ------------------------------------------------------------
        arm_home = 1; @(posedge clk); #1; arm_home = 0;
        rst = 1; @(posedge clk); #1; rst = 0;
        check(0, 0, 0, "15: IDLE reset/ARMED_HOME");

        // ------------------------------------------------------------
        // Test 16 – Sync reset from TRIGGERED
        // ------------------------------------------------------------
        arm_away = 1; @(posedge clk); #1; arm_away = 0;
        motion_sensor = 1; @(posedge clk); #1; motion_sensor = 0;
        rst = 1; @(posedge clk); #1; rst = 0;
        check(0, 0, 0, "16: IDLE reset/TRIGGERED");

        // ============================================================
        $display("----------------------------------------");
        if (test_fail)
            $display("RESULT: FAIL – one or more tests did not pass");
        else
            $display("RESULT: PASS – all tests passed");
        $display("----------------------------------------");

        $finish_and_return(test_fail);
    end

endmodule
