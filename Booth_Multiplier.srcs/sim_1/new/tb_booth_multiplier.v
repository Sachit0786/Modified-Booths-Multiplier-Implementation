`timescale 1ns / 1ps

module tb_booth_radix_2();
    parameter DATA_WIDTH = 4;
    
    reg clk_signal;
    reg reset_signal;
    reg start_signal;
    
    reg [DATA_WIDTH-1:0] multiplicand_input;
    wire [DATA_WIDTH-1:0] bcd_multiplicand_input;
    wire neg_multiplicand;
    
    reg [DATA_WIDTH-1:0] multiplier_input;
    wire [DATA_WIDTH-1:0] bcd_multiplier_input;
    wire neg_multiplier;
    
    wire [(DATA_WIDTH*2)-1:0] binary_result;
    wire [(DATA_WIDTH*2)-1:0] bcd_result;
    wire result_valid;
    wire res_negative;
    
    wire [3:0] anode_select;
    wire [6:0] segment_output1;
    wire [6:0] segment_output2;
    wire [6:0] segment_output3;
    
    
    top_module #(DATA_WIDTH) DUT (  clk_signal, 
                                    reset_signal, 
                                    start_signal, 
                                    multiplicand_input,
                                    multiplier_input, 
                                    bcd_multiplicand_input,
                                    bcd_multiplier_input,
                                    result_valid, 
                                    neg_multiplicand,
                                    neg_multiplier, 
                                    anode_select,
                                    segment_output1,
                                    segment_output2,
                                    segment_output3, 
                                    binary_result, 
                                    bcd_result, 
                                    res_negative );
    
    always #3.5 clk_signal = ~clk_signal;
    
    initial begin
        clk_signal = 0;
        reset_signal = 1;
        start_signal = 0;
        multiplicand_input = 0;
        multiplier_input = 0;
        
        @(posedge clk_signal);
        @(posedge clk_signal) reset_signal = 0;
        @(posedge clk_signal);
        @(posedge clk_signal) begin
            multiplicand_input = 7;
            multiplier_input = 4;
        end
        
        @(posedge clk_signal);
        @(posedge clk_signal) start_signal = 1;
        
        while (result_valid == 1'b0) @(posedge clk_signal);
        
        start_signal = 0;
        @(posedge clk_signal);
        @(posedge clk_signal) reset_signal = 1;
        @(posedge clk_signal);
        @(posedge clk_signal) reset_signal = 0;
        
        @(posedge clk_signal) begin
            multiplicand_input = -3;
            multiplier_input = 5;
        end
        
        @(posedge clk_signal);
        @(posedge clk_signal) start_signal = 1;
        
        while (result_valid == 1'b0) @(posedge clk_signal);
        
        start_signal = 0;
        @(posedge clk_signal);
        @(posedge clk_signal) reset_signal = 1;
        @(posedge clk_signal);
        @(posedge clk_signal) reset_signal = 0;

        @(posedge clk_signal);
        @(posedge clk_signal);
        
        @(posedge clk_signal) begin
            multiplicand_input = -8;
            multiplier_input = 7;
        end
        
        @(posedge clk_signal);
        @(posedge clk_signal) start_signal = 1;
        
        while (result_valid == 1'b0) @(posedge clk_signal);
        
        start_signal = 0;
        
        @(posedge clk_signal);
        @(posedge clk_signal) reset_signal = 1;
        @(posedge clk_signal);
        @(posedge clk_signal) reset_signal = 0;

        @(posedge clk_signal);
        @(posedge clk_signal);
        
        @(posedge clk_signal) begin
            multiplicand_input = 7;
            multiplier_input = 7;
        end
        
        @(posedge clk_signal);
        @(posedge clk_signal) start_signal = 1;
        
        while (result_valid == 1'b0) @(posedge clk_signal);
        start_signal = 0;
        
        @(posedge clk_signal);
        @(posedge clk_signal) reset_signal = 1;
        @(posedge clk_signal);
        @(posedge clk_signal) reset_signal = 0;

        @(posedge clk_signal);
        @(posedge clk_signal);
        
        @(posedge clk_signal) begin
            multiplicand_input = -8;
            multiplier_input = -8;
        end
        
        @(posedge clk_signal);
        @(posedge clk_signal) start_signal = 1;
        
        while (result_valid == 1'b0) @(posedge clk_signal);
        start_signal = 0;
        
        repeat(5) @(posedge clk_signal);
        
        $finish;
    end
endmodule
