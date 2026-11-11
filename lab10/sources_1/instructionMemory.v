`timescale 1ns / 1ps
// Byte-addressed instruction memory (little-endian), 256 bytes = 64 instructions.
module instructionMemory #(
    parameter OPERAND_LENGTH = 31
)(
    input  [OPERAND_LENGTH:0] instAddress,
    output reg [31:0]         instruction
);

    reg [7:0] memory [0:255];

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) memory[i] = 8'h00;
        $readmemh("fsm_program.mem", memory);   // add fsm_program.mem to the project sources
    end

    // Combinational fetch: 4 consecutive bytes form one instruction.
    // Only the low 8 bits of the PC index the 256-byte array.
    always @(*) begin
        instruction = { memory[instAddress[7:0] + 8'd3],
                        memory[instAddress[7:0] + 8'd2],
                        memory[instAddress[7:0] + 8'd1],
                        memory[instAddress[7:0]] };
    end

endmodule