`timescale 1ns / 1ps
module DataMemory(
    input         clk,
    input         rst,             // reset (btnC): clears every word to 0
    input         MemWrite,        // write strobe from the decoder
    input  [8:0]  address,         // word index 0..511
    input  [31:0] write_data,
    output [31:0] read_data
);
    reg [31:0] mem [0:511];        // the memory array
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            // Reset has priority: clear all 512 words on the clock edge
            for (i = 0; i < 512; i = i + 1)
                mem[i] <= 32'd0;
        end else if (MemWrite)
            mem[address] <= write_data;   // normal write
    end

    // Read is combinational (no clock needed)
    assign read_data = mem[address];
endmodule