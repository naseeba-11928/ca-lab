`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 09:38:47 AM
// Design Name: 
// Module Name: alu_control_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//==============================================================
// Testbench: MainControl + ALUControl, all 15 instructions
//==============================================================
`timescale 1ns / 1ps

module alu_control_tb;
    reg  [6:0] opcode;
    reg  [2:0] funct3;
    reg  [6:0] funct7;

    wire       RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    MainControl u_main (
        .opcode(opcode),
        .RegWrite(RegWrite), .ALUSrc(ALUSrc),
        .MemRead(MemRead), .MemWrite(MemWrite),
        .MemtoReg(MemtoReg), .Branch(Branch),
        .ALUOp(ALUOp)
    );

    ALUControl u_alu (
        .ALUOp(ALUOp), .funct3(funct3), .funct7(funct7),
        .ALUControl(ALUControl)
    );

    integer errors = 0;
    integer tests  = 0;

    // exp_main = {RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp[1:0]}
    task check;
        input [6:0] op;
        input [2:0] f3;
        input [6:0] f7;
        input [7:0] exp_main;
        input [3:0] exp_alu;
        reg   [7:0] got_main;
        begin
            opcode = op; funct3 = f3; funct7 = f7;
            #10;
            got_main = {RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp};
            tests = tests + 1;
            if (got_main !== exp_main || ALUControl !== exp_alu)
                errors = errors + 1;
        end
    endtask

    initial begin
        // R-type
        check(7'b0110011, 3'b000, 7'b0000000, 8'b10000010, 4'b0010); // ADD
        check(7'b0110011, 3'b000, 7'b0100000, 8'b10000010, 4'b0110); // SUB
        check(7'b0110011, 3'b001, 7'b0000000, 8'b10000010, 4'b0100); // SLL
        check(7'b0110011, 3'b100, 7'b0000000, 8'b10000010, 4'b0011); // XOR
        check(7'b0110011, 3'b101, 7'b0000000, 8'b10000010, 4'b0101); // SRL
        check(7'b0110011, 3'b110, 7'b0000000, 8'b10000010, 4'b0001); // OR
        check(7'b0110011, 3'b111, 7'b0000000, 8'b10000010, 4'b0000); // AND
        
        // ADDI 
        check(7'b0010011, 3'b000, 7'b0100000, 8'b11000000, 4'b0010); // ADDI
        // Loads
        check(7'b0000011, 3'b000, 7'b0000000, 8'b11101000, 4'b0010); // LB
        check(7'b0000011, 3'b001, 7'b0000000, 8'b11101000, 4'b0010); // LH
        check(7'b0000011, 3'b010, 7'b0000000, 8'b11101000, 4'b0010); // LW
        // Stores
        check(7'b0100011, 3'b000, 7'b0000000, 8'b01010000, 4'b0010); // SB
        check(7'b0100011, 3'b001, 7'b0000000, 8'b01010000, 4'b0010); // SH
        check(7'b0100011, 3'b010, 7'b0000000, 8'b01010000, 4'b0010); // SW
        // Branch
        check(7'b1100011, 3'b000, 7'b0000000, 8'b00000101, 4'b0111); // BEQ
        // Unknown opcode
        check(7'b1111111, 3'b000, 7'b0000000, 8'b00000000, 4'b0010); // BADOP

        #10;
        $finish;
    end
endmodule