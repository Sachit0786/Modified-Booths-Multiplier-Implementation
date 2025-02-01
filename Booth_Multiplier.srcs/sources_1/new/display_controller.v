`timescale 1ns / 1ps

module display_controller #(parameter DATA_WIDTH=8)
                           (input wire clk,
                            input wire multiplication_valid, // Indicates if the multiplication result is valid
                            input wire product_sign_bit, // Sign bit of the product (1 for negative, 0 for positive)
                            input wire [DATA_WIDTH-1:0] bcd_result, // BCD result of the multiplication
                            output wire [3:0] anode_select,
                            output wire [6:0] segment_display1, // 7-segment display output 1
                            output wire [6:0] segment_display2, // 7-segment display output 2
                            output wire [6:0] segment_display3 // 7-segment display output 3
                            );
    
    assign anode_select = 4'b1000;
    // Registers to store 7-segment display values for each digit
    reg [6:0] segment_digit1 = 7'b1000000;
    reg [6:0] segment_digit2 = 7'b1000000;
    reg [6:0] segment_digit3 = 7'b1111111;
    
    reg enable_refresh = 1'b0; // Flag to enable display refresh
    reg [16:0] refresh_counter = 'd0; // Counter for controlling refresh rate
    
    // Wires to hold converted hex values from BCD
    wire [6:0] hex_digit1;
    wire [6:0] hex_digit2;
    
    // Convert BCD input to 7-segment hex representation
    convert_to_segment_display converter0 (bcd_result[3:0], hex_digit1);
    convert_to_segment_display converter1 (bcd_result[DATA_WIDTH-1:4], hex_digit2);
    
    
    // Refresh counter logic to control the refresh rate of the display
    always @(posedge clk) begin
        if (enable_refresh)
            enable_refresh <= 1'b0;
        else
            refresh_counter <= refresh_counter + 1'b1;
        
        if (refresh_counter + 1'b1 == 'd100000) begin // Refresh at fixed interval
            enable_refresh <= 1'b1;
            refresh_counter <= 'd0;
        end
    end
    
    // Logic to shift the anode control signal and update segment digits
    always @(posedge clk or posedge multiplication_valid) begin
        if (enable_refresh) begin
            // Default all digits to blank
            segment_digit1 <= 7'b1000000;
            segment_digit2 <= 7'b1000000;
            segment_digit3 <= 7'b1111111;
        end    
            
        if (multiplication_valid) begin
            segment_digit1 <= hex_digit1; // Display lower hex digit
            segment_digit2 <= hex_digit2; // Display upper hex digit
            
            if (product_sign_bit)
                segment_digit3 <= 7'b0111111; // Display minus sign for negative numbers
            else
                segment_digit3 <= 7'b1111111; // Blank for positive numbers
        end    
    end
    
    assign segment_display1 = segment_digit1;
    assign segment_display2 = segment_digit2;
    assign segment_display3 = segment_digit3;
    
endmodule
