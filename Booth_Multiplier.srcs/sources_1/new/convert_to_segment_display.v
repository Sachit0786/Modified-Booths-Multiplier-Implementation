`timescale 1ns / 1ps

module bcd_to_hex (
    input wire [3:0] bcd_input,
    output reg [6:0] segment_display
);
    
always @(*) begin
    case (bcd_input)
        4'h0: segment_display = 7'b1000000; // Display 0
        4'h1: segment_display = 7'b1111001; // Display 1
        4'h2: segment_display = 7'b0100100; // Display 2
        4'h3: segment_display = 7'b0110000; // Display 3
        4'h4: segment_display = 7'b0011001; // Display 4
        4'h5: segment_display = 7'b0010010; // Display 5
        4'h6: segment_display = 7'b0000010; // Display 6
        4'h7: segment_display = 7'b1111000; // Display 7
        4'h8: segment_display = 7'b0000000; // Display 8
        4'h9: segment_display = 7'b0010000; // Display 9
        4'hA: segment_display = 7'b0001000; // Display A
        4'hB: segment_display = 7'b0000011; // Display B
        4'hC: segment_display = 7'b1000110; // Display C
        4'hD: segment_display = 7'b0100001; // Display D
        4'hE: segment_display = 7'b0000110; // Display E
        default: segment_display = 7'b0001110; // Display F
    endcase
end

endmodule