// Memory system top: connects the decoder, data memory, LED and switch interfaces.
// NOTE: in the supplied Lab 5 files the module names are swapped:
//   module "leds"     actually implements the SWITCH read interface
//   module "switches" actually implements the LED write interface
// They are instantiated here according to what they really do.
module addressDecoderTop(
    input         clk, rst,
    input  [31:0] address,
    input         readEnable, writeEnable,
    input  [31:0] writeData,
    input  [15:0] switches,
    output [31:0] readData,
    output [15:0] leds
);
    // Strobes from the decoder and read data from each device
    wire DataMemWrite, DataMemRead, LEDWrite, SwitchReadEnable;
    wire [31:0] mem_rd, sw_rd, led_rd_unused;

    // Decide which device is accessed
    AddressDecoder dec(.address(address), .readEnable(readEnable), .writeEnable(writeEnable),
        .DataMemWrite(DataMemWrite), .DataMemRead(DataMemRead),
        .LEDWrite(LEDWrite), .SwitchReadEnable(SwitchReadEnable));

    // Data memory, indexed by the local address (address[7:0])
    DataMemory dmem(.clk(clk), .rst(rst), .MemWrite(DataMemWrite), .address({1'b0, address[7:0]}),
        .write_data(writeData), .read_data(mem_rd));

    // Lab 5 switch interface (file's module named "leds")
    leds sw_if(.clk(clk), .rst(rst), .btns(16'd0), .writeData(writeData),
        .writeEnable(1'b0), .readEnable(SwitchReadEnable), .memAddress(address[29:0]),
        .switches(switches), .readData(sw_rd));

    // Lab 5 LED interface (file's module named "switches")
    switches led_if(.clk(clk), .rst(rst), .writeData(writeData),
        .writeEnable(LEDWrite), .readEnable(1'b0), .memAddress(address[29:0]),
        .readData(led_rd_unused), .leds(leds));

    // Read mux: only the selected device drives readData, otherwise 0
    assign readData = DataMemRead      ? mem_rd :
                      SwitchReadEnable ? sw_rd  : 32'd0;
endmodule