module fpga_top(
    input         clk,
    input         btnC,        // reset
    input         btnU,        // unused
    input  [15:0] sw,
    output [15:0] led
);
    wire [31:0] address     = {22'd0, sw[9:0]};
    wire [31:0] writeData   = {27'd0, sw[14:10]};
    wire        writeEnable = sw[15];
    wire        readEnable  = ~sw[15];
    wire [31:0] readData;
    wire [15:0] led_reg;

    addressDecoderTop mem_sys(.clk(clk), .rst(btnC), .address(address),
        .readEnable(readEnable), .writeEnable(writeEnable), .writeData(writeData),
        .switches(sw), .readData(readData), .leds(led_reg));

    assign led = sw[15] ? led_reg : readData[15:0];
endmodule