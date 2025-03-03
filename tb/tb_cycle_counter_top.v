`timescale 1ns/1ps

module tb_cycle_counter_top;
  
  // ----------------------------------
  // Testbench signals
  // ----------------------------------
  reg         clk;
  reg         rst_n;
  reg         valid_in;
  wire        ready_out;
  reg  [7:0]  data_in;
  wire        count_done;
  reg	      test_fail;

  integer    clock_count;
   
  // ----------------------------------
  // Instantiate the DUT
  // ----------------------------------
  cycle_counter_top dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .valid_in   (valid_in),
    .ready_out  (ready_out),
    .data_in    (data_in),
    .count_done (count_done)
  );

  // ----------------------------------
  // Clock Generation
  // ----------------------------------
  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD/2) clk = ~clk;

  // ----------------------------------
  // Clock Counter
  // ----------------------------------
  // This increments every time we get a rising edge.
  always @(posedge clk) begin
    clock_count <= clock_count + 1;
     if (clock_count > 50) begin
	$display("count_done not received in required number of clock cycles, terminating - test FAIL");
	$finish_and_return(1);
     end
  end
   
  // ----------------------------------
  // Initial / Reset / Simulation Control
  // ----------------------------------
  initial begin
    // Initialize signals
    clk       = 0;
    rst_n     = 0;
    valid_in  = 0;
    data_in   = 8'd0;
    clock_count = 0;
    test_fail = 0;
     

    // Apply reset
    #20;      // Wait 20 ns
    rst_n = 1;

    // Wait a few cycles before starting
    #20;

    // ----------------------------------
    // Test #1: Count 8 cycles
    // ----------------------------------
    send_data(8'd8);

    // ----------------------------------
    // Test #2: Count 3 cycles
    // ----------------------------------
    send_data(8'd3);

    // ----------------------------------
    // Test #3: Count 10 cycles
    // ----------------------------------
    send_data(8'd10);

    // End of tests
    #50;
    $display("All tests completed.");

    $finish_and_return(test_fail);
  end

  // ----------------------------------
  // Task to send data via valid/ready handshake
  // ----------------------------------
  task send_data(input [7:0] value);
    integer start_count, end_count;
    begin
      // Wait until DUT is ready
      wait (ready_out == 1);

      
      // Drive valid_in, data_in
      @(posedge clk);
      valid_in <= 1'b1;
      data_in  <= value;
      $display("[%0t ps] Sending data_in = %0d...", $time, value);

      // Hold valid_in for at least one cycle until the DUT captures it
      @(posedge clk);
      valid_in <= 1'b0;
      data_in  <= 8'd0;  // not strictly necessary but can keep signals clean
      #1 start_count = clock_count;
//     $display("start_count = %d",start_count);
      
      // Now the DUT should move to COUNT. We wait until count_done is asserted
      wait (count_done == 1);
      #1 end_count = clock_count;
//     $display("end_count = %d",end_count);
       
      $display("[%0t ps] DUT completed counting for value = %0d.", $time, value);
       
      $display("[%0t ps] Counting from start to finish took %0d clock cycles, expected %0d.",
                $time, (end_count - start_count), value+2);
      $display("-----------------------------------------------------");
      if ((end_count - start_count - 2) != value) begin
	 test_fail = 1;
	 $display("FAIL");
      end
       
    end
  endtask

endmodule
