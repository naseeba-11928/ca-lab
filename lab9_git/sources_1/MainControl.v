`timescale 1ns / 1ps

// MainControl: decodes opcode[6:0] into datapath control signals
// ALUOp: 00 = force ADD (loads, stores, ADDI)
//        01 = branch compare (BEQ)
//        10 = R-type (ALUControl looks at funct3/funct7)

module MainControl (
    input  wire [6:0] opcode,
    output reg        RegWrite,
    output reg        ALUSrc,
    output reg        MemRead,
    output reg        MemWrite,
    output reg        MemtoReg,
    output reg        Branch,
    output reg  [1:0] ALUOp
);
    localparam OP_RTYPE  = 7'b0110011;  // ADD SUB SLL SRL AND OR XOR
    localparam OP_ITYPE  = 7'b0010011;  // ADDI
    localparam OP_LOAD   = 7'b0000011;  // LB LH LW
    localparam OP_STORE  = 7'b0100011;  // SB SH SW
    localparam OP_BRANCH = 7'b1100011;  // BEQ

    always @(*) begin
        //set to zero, will stay zero unless changed :D
        // to make sure memory is untouched
        RegWrite = 1'b0;
        ALUSrc   = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 1'b0;
        Branch   = 1'b0;
        ALUOp    = 2'b00;

        case (opcode)
            OP_RTYPE: begin
                RegWrite = 1'b1;
                ALUOp    = 2'b10;
            end
            OP_ITYPE: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
            end
            OP_LOAD: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                MemRead  = 1'b1;
                MemtoReg = 1'b1;
            end
            OP_STORE: begin
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
            end
            OP_BRANCH: begin
                Branch   = 1'b1;
                ALUOp    = 2'b01;
            end
            default: ; // unknown opcode: keep safe defaults
        endcase
    end
endmodule