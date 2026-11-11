`timescale 1ns / 1ps
// 1-bit ALU slice: AND, OR, XOR, ADD/SUB (no shift)
// op: 00 AND | 01 OR | 10 XOR | 11 ADD/SUB (full adder, B xor binvert)
module ALU_1bit (
    input  a,
    input  b,
    input  binvert,      // 1 for SUB (invert B)
    input  cin,          // carry in (= SUB at bit 0)
    input  [1:0] op,
    output reg result,
    output cout
);
    wire b_x = b ^ binvert;                       // B xor SUB
    wire sum = a ^ b_x ^ cin;                     // full adder sum
    assign cout = (a & b_x) | (cin & (a ^ b_x));  // full adder carry

    always @(*) begin
        case (op)
            2'b00:   result = a & b;
            2'b01:   result = a | b;
            2'b10:   result = a ^ b;
            default: result = sum;
        endcase
    end
endmodule