## Clock Signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## Reset Button
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## Start Signal Button
set_property PACKAGE_PIN T18 [get_ports start_signal]
set_property IOSTANDARD LVCMOS33 [get_ports start_signal]

## Multiplicand Input (4-bit Switches)
set_property PACKAGE_PIN V17 [get_ports {multiplicand[0]}]
set_property PACKAGE_PIN V16 [get_ports {multiplicand[1]}]
set_property PACKAGE_PIN W16 [get_ports {multiplicand[2]}]
set_property PACKAGE_PIN W17 [get_ports {multiplicand[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {multiplicand[*]}]

## Multiplier Input (4-bit Switches)
set_property PACKAGE_PIN W15 [get_ports {multiplier[0]}]
set_property PACKAGE_PIN V15 [get_ports {multiplier[1]}]
set_property PACKAGE_PIN W14 [get_ports {multiplier[2]}]
set_property PACKAGE_PIN W13 [get_ports {multiplier[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {multiplier[*]}]

## 7-Segment Display (Common Anode Select)
set_property PACKAGE_PIN U8 [get_ports {anode_select[0]}]
set_property PACKAGE_PIN V8 [get_ports {anode_select[1]}]
set_property PACKAGE_PIN U5 [get_ports {anode_select[2]}]
set_property PACKAGE_PIN V5 [get_ports {anode_select[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_select[*]}]

## 7-Segment Display Segments at ones place (A-G)
set_property PACKAGE_PIN W6 [get_ports {segment_display1[0]}]
set_property PACKAGE_PIN W7 [get_ports {segment_display1[1]}]
set_property PACKAGE_PIN V6 [get_ports {segment_display1[2]}]
set_property PACKAGE_PIN U7 [get_ports {segment_display1[3]}]
set_property PACKAGE_PIN V7 [get_ports {segment_display1[4]}]
set_property PACKAGE_PIN U6 [get_ports {segment_display1[5]}]
set_property PACKAGE_PIN V4 [get_ports {segment_display1[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment_display1[*]}]

## 7-Segment Display Segments at tens place (A-G)
set_property PACKAGE_PIN W10 [get_ports {segment_display2[0]}]
set_property PACKAGE_PIN W11 [get_ports {segment_display2[1]}]
set_property PACKAGE_PIN V10 [get_ports {segment_display2[2]}]
set_property PACKAGE_PIN U11 [get_ports {segment_display2[3]}]
set_property PACKAGE_PIN V11 [get_ports {segment_display2[4]}]
set_property PACKAGE_PIN U10 [get_ports {segment_display2[5]}]
set_property PACKAGE_PIN V9 [get_ports {segment_display2[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment_display2[*]}]

## 7-Segment Display Segments for sign place (A-G)
set_property PACKAGE_PIN W12 [get_ports {segment_display3[0]}]
set_property PACKAGE_PIN W13 [get_ports {segment_display3[1]}]
set_property PACKAGE_PIN V12 [get_ports {segment_display3[2]}]
set_property PACKAGE_PIN U13 [get_ports {segment_display3[3]}]
set_property PACKAGE_PIN V13 [get_ports {segment_display3[4]}]
set_property PACKAGE_PIN U12 [get_ports {segment_display3[5]}]
set_property PACKAGE_PIN V14 [get_ports {segment_display3[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segment_display3[*]}]

## Negative Flag Outputs (LEDs)
set_property PACKAGE_PIN U4 [get_ports neg_multiplicand_led]
set_property PACKAGE_PIN V3 [get_ports neg_multiplier_led]
set_property PACKAGE_PIN W3 [get_ports res_negative_led]
set_property IOSTANDARD LVCMOS33 [get_ports neg_multiplicand_led neg_multiplier_led res_negative_led]

## Valid Output Indicator LED
set_property PACKAGE_PIN U16 [get_ports valid_output_led]
set_property IOSTANDARD LVCMOS33 [get_ports valid_output_led]
