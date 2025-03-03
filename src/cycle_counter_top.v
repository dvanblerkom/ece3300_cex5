
module cycle_counter_top (
   input wire	   clk,
   input wire	   rst_n,
   // Upstream handshake
   input wire	   valid_in,
   output reg	   ready_out,
   input wire [7:0] data_in,
   // completion indicator
   output reg	   count_done
);

   // State encoding
   localparam	   IDLE  = 2'b00;
   localparam	   LOAD  = 2'b01;
   localparam	   COUNT = 2'b10;
   localparam	   DONE  = 2'b11;
   
   reg [1:0]	   current_state, next_state;
   
   //--------------------------------------
   // Down Counter Instantiation
   //--------------------------------------
   wire [7:0]	   count_val;
   wire		   count_done_flag;
   
   // Control signals for down_counter
   reg		   cnt_enable;
   reg		   cnt_load;
   reg [7:0]	   cnt_load_value;
   
   down_counter u_down_counter (
	.clk         (clk),
	.rst_n       (rst_n),
	.enable      (cnt_enable),
	.load        (cnt_load),
	.load_value  (cnt_load_value),
	.count_out   (count_val),
	.done        (count_done_flag)
   );
   
   //--------------------------------------
   // Sequential State Update
   //--------------------------------------
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         current_state <= IDLE;
      end else begin
         current_state <= next_state;
	 $display("At time %0t ps, current state is %0b, next state is %0b", $time, current_state, next_state);
      end
   end
   
   //--------------------------------------
   // grab the data when ready and valid are both high
   //--------------------------------------
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         cnt_load_value <= 0;
      end else begin
         if (ready_out & valid_in)
	   cnt_load_value <= data_in;
      end
   end
   
   //--------------------------------------
   // Next-State logic
   //--------------------------------------
   always @(*) begin
      // Default assignment - stay in current state
      next_state      = current_state;
      
      case (current_state)
        //----------------------------------------------
        // IDLE: set ready_out high, Wait for valid_in
        //----------------------------------------------
        IDLE: begin

// -->> add code

        end
	
        //----------------------------------------------
        // LOAD: load the down counter, immediately go to COUNT
        //----------------------------------------------
	LOAD: begin

// -->> add code

	end
	
        //----------------------------------------------
        // COUNT: Enable the counter until it is done
        //----------------------------------------------
        COUNT: begin

// -->> add code

        end
	
        //----------------------------------------------
        // DONE: assert done flag and go back to IDLE
        //----------------------------------------------
        DONE: begin

// -->> add code

        end
	
        //----------------------------------------------
        default: begin
           next_state = IDLE;
        end
      endcase
   end
   
   //--------------------------------------
   // Control logic
   //--------------------------------------
   always @(*) begin
      // Default assignments
      cnt_enable      = 1'b0;
      cnt_load        = 1'b0;
      ready_out  = 1'b0;
      count_done = 1'b0;
      
      case (current_state)
        //----------------------------------------------
        // IDLE: set ready_out high, Wait for valid_in
        //----------------------------------------------
        IDLE: begin

// -->> add code

        end
	
        //----------------------------------------------
        // LOAT: load the down counter
        //----------------------------------------------
	LOAD: begin

// -->> add code

	end
	
        //----------------------------------------------
        // COUNT: Enable the counter until it is done
        //----------------------------------------------
        COUNT: begin

// -->> add code

        end
	
        //----------------------------------------------
        // DONE: Assert valid_out, wait for ready_in
        //----------------------------------------------
        DONE: begin

// -->> add code

        end
	
      endcase
   end
   
endmodule
