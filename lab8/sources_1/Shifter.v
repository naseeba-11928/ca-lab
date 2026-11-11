
// 32-bit logical shifter: SLL (right=0) / SRL (right=1)
module Shifter (
    input  [31:0] A,
    input  [4:0]  shamt,
    input         right,
    output [31:0] Y
);
    assign Y = right ? (A >> shamt) : (A << shamt);
endmodule
