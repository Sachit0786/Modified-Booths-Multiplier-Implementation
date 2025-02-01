`timescale 1ns / 1ps

module booth_multiplier_fsm #(parameter DATA_WIDTH=4)
                 (input wire clk,
                  input wire reset,
                  input wire start_signal,
                  input wire [DATA_WIDTH-1:0] multiplicand,
                  input wire [DATA_WIDTH-1:0] multiplier,
                  output wire output_valid,
                  output wire [(DATA_WIDTH*2)-1:0] binary_product,
                  output wire [(DATA_WIDTH*2)-1:0] bcd_product);
   
    // Define FSM states
    localparam STATE_IDLE=1'b0,
               STATE_CALCULATING=1'b1;
    
    // Registers for FSM state and control
    reg current_state, next_state;
    reg [(DATA_WIDTH*2)-1:0] shift_accumulator; // Holds intermediate results
    reg prev_multiplier_bit; // Stores the previous bit of the multiplier for Booth's encoding
    reg [DATA_WIDTH-2:0] bit_counter; // Counter to track the number of bits processed
    reg [DATA_WIDTH-1:0] multiplicand_register; // Stores the multiplicand
    reg [DATA_WIDTH-1:0] partial_sum; // Stores the computed partial sum
    reg computation_done; // Flag indicating multiplication completion
    
    // FSM next-state logic
    always @(*) begin
        case (current_state)
            STATE_IDLE: next_state = start_signal ? STATE_CALCULATING : STATE_IDLE;
            STATE_CALCULATING: next_state = ~start_signal ? STATE_IDLE : STATE_CALCULATING;
        endcase
    end
    
    // FSM state transition
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_IDLE;
        else
            current_state <= next_state;
    end
    
    // Booth's multiplication process
    always @(posedge clk) begin
        if (reset) begin
            computation_done <= 1'b0;
            shift_accumulator <= 'd0;
            prev_multiplier_bit <= 1'b0;
            multiplicand_register <= 'd0;
            bit_counter <= DATA_WIDTH;
        end 
        else begin
            case (current_state)
                STATE_IDLE: begin
                    if (start_signal) begin
                        // Initialize registers on start
                        multiplicand_register <= multiplicand;
                        shift_accumulator <= {{DATA_WIDTH{1'b0}}, multiplier}; // Extend multiplier
                    end 
                    else begin
                        multiplicand_register <= 'd0;
                        shift_accumulator <= 'd0;
                    end
                    prev_multiplier_bit <= 1'b0;
                    computation_done <= 1'b0;
                    bit_counter <= DATA_WIDTH;
                end
                STATE_CALCULATING: begin
                    if (bit_counter != 'd0) begin
                        bit_counter <= bit_counter - 1'b1;
                        {shift_accumulator, prev_multiplier_bit} <= {partial_sum[DATA_WIDTH-1], partial_sum, shift_accumulator[DATA_WIDTH-1:0]};
                    end 
                    else
                        computation_done <= 1'b1; // Set computation done flag when complete
                end
            endcase
        end
    end
    
    // Booth encoding logic
    always @(*) begin
        partial_sum = 'd0;
        case ({shift_accumulator[0], prev_multiplier_bit})
            2'b00: partial_sum = shift_accumulator[(DATA_WIDTH*2)-1:DATA_WIDTH]; // No operation
            2'b01: partial_sum = shift_accumulator[(DATA_WIDTH*2)-1:DATA_WIDTH] + multiplicand_register; // Add multiplicand
            2'b10: partial_sum = shift_accumulator[(DATA_WIDTH*2)-1:DATA_WIDTH] - multiplicand_register; // Subtract multiplicand
            2'b11: partial_sum = shift_accumulator[(DATA_WIDTH*2)-1:DATA_WIDTH]; // No operation
        endcase
    end
    
    // Convert binary product to BCD format
    convert_binary_to_bcd #(DATA_WIDTH*2) converter (
        clk,
        reset,
        start_signal,
        computation_done,
        binary_product,
        bcd_product,
        output_valid
    );
   
    assign binary_product = (multiplicand == {1'b1, {DATA_WIDTH-1{1'b0}}} || multiplier == {1'b1, {DATA_WIDTH-1{1'b0}}}) ? (computation_done ? (~shift_accumulator + 1'b1) : 'd0) : computation_done ? shift_accumulator : 'd0;       
endmodule
