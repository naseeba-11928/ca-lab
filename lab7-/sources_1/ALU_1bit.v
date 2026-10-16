module ALU_1bit (
    input  a,
    input  b,
    input  binvert,      
    input  cin,          
    input  [1:0] op,
    output reg result,
    output cout
);
    wire b_x = b ^ binvert;                       // B xor SUB
    wire sum = a ^ b_x ^ cin;                     // full adder sum
    assign cout = (a & b_x) | (cin & (a ^ b_x));  // full adder carry

    // op: 00 AND | 01 OR | 10 XOR | 11 ADD/SUB (full adder, B xor binvert)
    always @(*) begin
        case (op)
            2'b00:   result = a & b;
            2'b01:   result = a | b;
            2'b10:   result = a ^ b;  
            default: result = sum;
        endcase
    end
endmodule

