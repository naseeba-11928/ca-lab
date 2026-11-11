// ALUControl: ALUOp + funct3 + funct7 -> ALUControl[3:0]
// Output encoding:
//   0000 AND | 0001 OR  | 0010 ADD | 0011 XOR
//   0100 SLL | 0101 SRL | 0110 SUB | 0111 BEQ

module ALUControl (
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] ALUControl
);
    localparam AND_OP = 4'b0000;
    localparam OR_OP  = 4'b0001;
    localparam ADD_OP = 4'b0010;
    localparam XOR_OP = 4'b0011;
    localparam SLL_OP = 4'b0100;
    localparam SRL_OP = 4'b0101;
    localparam SUB_OP = 4'b0110;
    localparam BEQ_OP = 4'b0111;

    always @(*) begin
        ALUControl = ADD_OP;                 

        case (ALUOp)
            2'b00: ALUControl = ADD_OP;      // LW/LH/LB, SW/SH/SB, ADDI
            2'b01: ALUControl = BEQ_OP;      // BEQ
            2'b10: begin                     // R-type: decode funct7 + funct3
                case ({funct7, funct3})
                    10'b0000000_000: ALUControl = ADD_OP;
                    10'b0100000_000: ALUControl = SUB_OP;
                    10'b0000000_001: ALUControl = SLL_OP;
                    10'b0000000_100: ALUControl = XOR_OP;
                    10'b0000000_101: ALUControl = SRL_OP;
                    10'b0000000_110: ALUControl = OR_OP;
                    10'b0000000_111: ALUControl = AND_OP;
                    default:         ALUControl = ADD_OP;  // unsupported R-type
                endcase
            end
            default: ALUControl = ADD_OP;    // ALUOp = 11 unused
        endcase
    end
endmodule
