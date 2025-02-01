`timescale 1ns / 1ps

module input_TwosCompToAbs #(
    parameter N = 4  // Number of bits in input (2's complement form)
)(
    input wire signed [N-1:0] twos_comp,  // N-bit input (2's complement value)
    output wire [N-1:0] abs_value   // Absolute value output
);

    assign abs_value = (twos_comp[N-1]) ? -twos_comp : twos_comp;
endmodule
