// 32-bit ALU built from 32 x ALU_1bit (ripple-carry) + Shifter
// ALUControl: 0000 AND | 0001 OR | 0010 ADD | 0011 XOR
//             0100 SLL | 0101 SRL | 0110 SUB | 0111 BEQ

module ALU (
    input  [31:0] A,
    input  [31:0] B,
    input  [3:0]  ALUControl,
    output reg [31:0] ALUResult,
    output        Zero
);
    // controler
    // ALUControl: 0000 and , 0001 or , 0010 add  , 0011 xor
    //             0100 sll , 0101 srl ,  0110 sub  , 0111 beq

    reg [1:0] op;
    reg       sub;
    reg       use_shift;
    reg       valid;
    always @(*) begin
        op = 2'b11; sub = 1'b0; use_shift = 1'b0; valid = 1'b1;
        case (ALUControl)
            4'b0000: op = 2'b00;                    // and 
            4'b0001: op = 2'b01;                    // or
            4'b0010: op = 2'b11;                    // add
            4'b0011: op = 2'b10;                    // sox
            4'b0100,
            4'b0101: use_shift = 1'b1;              // sll / srl
            4'b0110,
            4'b0111: begin op = 2'b11; sub = 1'b1; end // SUB / BEQ
            default: valid = 1'b0;
        endcase
    end

    //32 ripple carry  for 1 bit slices
    wire [31:0] slice_out;
    wire [32:0] carry;
    assign carry[0] = sub;     // Cin = SUB

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : bit_slice
            ALU_1bit u (
                .a(A[i]), .b(B[i]),
                .binvert(sub), .cin(carry[i]),
                .op(op),
                .result(slice_out[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    wire [31:0] shift_out;   // shifting 
    Shifter sh (.A(A), .shamt(B[4:0]), .right(ALUControl[0]), .Y(shift_out));

    always @(*) begin     //  final result selectionn
        if 
            (!valid) ALUResult = 32'b0;
        else if 
            (use_shift) ALUResult = shift_out;
        else  
            ALUResult = slice_out;
    end

    assign Zero = (ALUResult == 32'b0);
endmodule
