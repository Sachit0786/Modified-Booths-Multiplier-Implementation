`timescale 1ns / 1ps

module top_module #(parameter DATA_WIDTH=4)
                    (input wire clk,
                     input wire reset,
                     input wire start_signal,
                     input wire [DATA_WIDTH-1:0] multiplicand,
                     input wire [DATA_WIDTH-1:0] multiplier,
                     output wire [DATA_WIDTH-1:0] bcd_multiplicand,
                     output wire [DATA_WIDTH-1:0] bcd_multiplier,
                     output wire valid_output,
                     output wire neg_multiplicand,
                     output wire neg_multiplier,
                     output wire [3:0] anode_select,
                     output wire [6:0] segment_display1,
                     output wire [6:0] segment_display2,
                     output wire [6:0] segment_display3,
                     output wire [(DATA_WIDTH*2)-1:0] binary_result,
                     output wire [(DATA_WIDTH*2)-1:0] bcd_result,
                     output wire res_negative);
    
    
    booth_multiplier_fsm #(DATA_WIDTH) booth_multiplier (
        clk,
        reset,
        start_signal,
        multiplicand,
        multiplier,
        valid_output,
        binary_result,
        bcd_result
    );
    
    assign bcd_multiplicand = (multiplicand[DATA_WIDTH-1]) ? (~multiplicand + 1'b1) : multiplicand;
    assign bcd_multiplier = (multiplier[DATA_WIDTH-1]) ? (~multiplier + 1'b1) : multiplier;
    
    display_controller #(DATA_WIDTH*2) hex_display (
        clk,
        valid_output,
        binary_result[(DATA_WIDTH*2)-1],
        bcd_result,
        anode_select,
        segment_display1,
        segment_display2,
        segment_display3
    );
    
    assign neg_multiplier = multiplier[DATA_WIDTH-1];
    assign neg_multiplicand = multiplicand[DATA_WIDTH-1];
    assign res_negative = binary_result[(DATA_WIDTH*2)-1] & valid_output;
    
endmodule