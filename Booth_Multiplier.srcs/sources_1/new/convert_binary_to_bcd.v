`timescale 1ns / 1ps

module convert_binary_to_bcd #(parameter DATA_WIDTH=8)
                (input wire clk,
                 input wire reset, // Resets the conversion process
                 input wire start_conversion, // Initiates the conversion
                 input wire input_valid, // Indicates if the binary input is valid
                 input wire [DATA_WIDTH-1:0] binary_input, // Binary input to be converted
                 output reg [DATA_WIDTH-1:0] bcd_output, // Output in BCD format
                 output reg conversion_complete); // Indicates when conversion is complete
    
    // Parameters for BCD digit width and FSM states
    localparam BCD_DIGIT_WIDTH=4; 
    localparam STATE_IDLE=3'b001, // Idle state
               STATE_PROCESS=3'b010, // Conversion in progress
               STATE_COMPLETE=3'b100; // Conversion complete
               
    reg [2:0] current_state, next_state; // FSM state registers
    reg [3:0] bit_counter; // Counts processed bits
    reg [BCD_DIGIT_WIDTH-1:0] tens_place, ones_place; // Registers for BCD digits
    reg [DATA_WIDTH-1:0] binary_register; // Stores binary input during processing
    reg conversion_active; // Indicates an active conversion
    
    // FSM: Update the current state on clock edge
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_IDLE;
        else
            current_state <= next_state;
    end          
    
    // FSM: Determine the next state based on conditions
    always @(*) begin
        case (current_state)
            STATE_IDLE:       next_state = input_valid & conversion_active ? STATE_PROCESS : STATE_IDLE;
            STATE_PROCESS:    next_state = bit_counter == 'd8 ? STATE_COMPLETE : STATE_PROCESS;
            STATE_COMPLETE:   next_state = ~start_conversion ? STATE_IDLE : STATE_COMPLETE;
            default:          next_state = STATE_IDLE;
        endcase
    end         

    // Main conversion process
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers
            bit_counter <= 'd0;
            tens_place <= 'd0;
            ones_place <= 'd0;
            conversion_active <= 1'b0;
            conversion_complete <= 1'b0;
            bcd_output <= 'd0;
        end else begin
            bcd_output <= 'd0;
            case (current_state)
                STATE_IDLE: begin
                    if (input_valid & !conversion_active) begin
                        conversion_active <= 1'b1;
                        // Handle signed numbers by converting negative values to positive
                        if (binary_input[DATA_WIDTH-1])
                            binary_register <= (~binary_input + 1'b1); // Two's complement for negative numbers
                        else
                            binary_register <= binary_input;
                    end
                    if (start_conversion == 1'b0)
                        binary_register <= 'd0;
                    bit_counter <= 'd0;
                    conversion_complete <= 1'b0;
                    {tens_place, ones_place} <= 'd0;
                end
                STATE_PROCESS: begin
                    if (bit_counter != 'd8) begin
                        bit_counter <= bit_counter + 1'b1;
                        binary_register <= (binary_register << 1); // Shift binary input left

                        // Adjust BCD digits using Double-Dabble method
                        if ({ones_place[2:0], binary_register[DATA_WIDTH-1]} < 'd5)
                            {tens_place, ones_place} <= {tens_place[2:0], ones_place, binary_register[DATA_WIDTH-1]};
                        else if (bit_counter + 1'b1 == 'd8)
                            {tens_place, ones_place} <= {tens_place[2:0], ones_place, binary_register[DATA_WIDTH-1]};
                        else
                            {tens_place, ones_place} <= {tens_place[2:0], ones_place, binary_register[DATA_WIDTH-1]} + 4'b0011; // Add 3 if value >= 5
                    end
                end
                STATE_COMPLETE: begin
                    conversion_complete <= 1'b1; // Mark conversion as complete
                    bcd_output <= {tens_place, ones_place}; // Store BCD output
                end
                default: begin
                    ones_place <= ones_place;
                    tens_place <= tens_place;
                end
            endcase
        end
    end   
endmodule
