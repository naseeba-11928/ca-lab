`timescale 1ns/1ps
module MemorySystem_tb;
    reg clk = 0, rst = 1;
    reg [31:0] address = 0, writeData = 0;
    reg readEnable = 0, writeEnable = 0;
    reg [15:0] switches = 0;
    wire [31:0] readData;
    wire [15:0] leds;
    integer errors = 0;

    addressDecoderTop dut(.clk(clk), .rst(rst), .address(address), .readEnable(readEnable),
        .writeEnable(writeEnable), .writeData(writeData), .switches(switches),
        .readData(readData), .leds(leds));

    always #5 clk = ~clk;   // 10 ns clock

    // write: set address/data, pulse writeEnable for one clock edge

    task write(input [31:0] a, input [31:0] d);
        begin
            address = a; writeData = d; writeEnable = 1; readEnable = 0;
            @(posedge clk); #1 writeEnable = 0;
        end
    endtask
    // read: set address, assert readEnable, wait for the combinational output
    task read(input [31:0] a);
        begin
            address = a; readEnable = 1; writeEnable = 0; #2;
        end
    endtask
    // check: count an error if the value is not what we expected
    task check(input [31:0] got, input [31:0] exp, input [255:0] name);
        begin
            if (got !== exp) errors = errors + 1;
        end
    endtask

    initial begin
        repeat (2) @(posedge clk); #1 rst = 0;

        write(32'd5,   32'hDEADBEEF);              // 00: data memory
        write(32'd255, 32'hCAFEF00D);
        read(32'd5);   check(readData, 32'hDEADBEEF, "mem[5]");
        read(32'd255); check(readData, 32'hCAFEF00D, "mem[255]");

        write(32'h110, 32'h0000A5A5);              // 01: LEDs
        check({16'd0, leds}, 32'hA5A5, "LED write");
        read(32'd16);  check(readData, 32'd0, "LED write did not hit mem[16]");

        switches = 16'h1234;                       // 10: switches
        read(32'h250); check(readData, 32'h1234, "switch read");

        write(32'h250, 32'hFFFF);                  // write to switches: ignored
        check({16'd0, leds}, 32'hA5A5, "switch write ignored");
        read(32'd80);  check(readData, 32'd0, "switch write did not hit mem[80]");

        write(32'h350, 32'h1111);                  // 11: unused
        check({16'd0, leds}, 32'hA5A5, "unused write ignored");
        read(32'h350); check(readData, 32'd0, "unused read = 0");
        read(32'd80);  check(readData, 32'd0, "unused write did not hit mem[80]");

        write(32'h400, 32'h2222);                  // above bit 9: ignored
        read(32'h400); check(readData, 32'd0, "out of range read = 0");
        read(32'd0);   check(readData, 32'd0, "out of range write did not hit mem[0]");

        read(32'd5);   check(readData, 32'hDEADBEEF, "mem[5] intact");

        // Reset test: pulse rst, memory and LEDs must clear
        rst = 1; @(posedge clk); #1 rst = 0;
        read(32'd5);   check(readData, 32'd0, "mem[5] cleared by reset");
        read(32'd255); check(readData, 32'd0, "mem[255] cleared by reset");
        check({16'd0, leds}, 32'd0, "LEDs cleared by reset");
    end
endmodule