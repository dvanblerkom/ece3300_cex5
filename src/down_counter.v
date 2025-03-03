module down_counter (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        enable,     // When 1, decrement count each cycle
    input  wire        load,       // When 1, load the new value into the counter
    input  wire [7:0]  load_value, // Value to be loaded
    output wire [7:0]  count_out,  // Current count
    output wire        done        // Asserted when count == 0
);
    // Internal register for counting
    reg [7:0] count_reg;

    // Synchronous process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_reg <= 8'd0;
        end else begin
            if (load) begin
                // Load new counter value
                count_reg <= load_value;
            end else if (enable && (count_reg != 8'd0)) begin
                // Decrement count if enabled and not already zero
                count_reg <= count_reg - 1'b1;
            end
        end
    end

    // Output signals
    assign count_out = count_reg;
    assign done      = (count_reg == 8'd0);

endmodule
