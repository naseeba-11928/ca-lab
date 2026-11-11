`timescale 1ns / 1ps
module AddressDecoder(
    input  [31:0] address,
    input         readEnable,
    input         writeEnable,
    output        DataMemWrite,
    output        DataMemRead,
    output        LEDWrite,
    output        SwitchReadEnable
);
    wire in_range  = (address[31:10] == 22'd0);          // only 10 LSBs form the map
    wire DataMemSelect = in_range & ~address[9];                //0-511
    wire LEDSelect     = in_range &  address[9] & ~address[8];  //512-767
    wire SwitchSelect  = in_range &  address[9] &  address[8];  // 768-1023

    assign DataMemWrite     = DataMemSelect & writeEnable;
    assign DataMemRead      = DataMemSelect & readEnable;
    assign LEDWrite         = LEDSelect     & writeEnable;   // LEDs are write only
    assign SwitchReadEnable = SwitchSelect  & readEnable;    // Switchesareread only
endmodule
