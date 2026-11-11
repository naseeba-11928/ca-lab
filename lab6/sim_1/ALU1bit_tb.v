`timescale 1ns / 1ps
// Exhaustive test of the 1-bit ALU (all 2^6 input combinations)
module ALU_1bit_tb;
    reg a, b, binvert, cin;
    reg [1:0] op;
    wire result, cout;
    integer i, errors = 0;
    reg exp_res, exp_cout, bx;

    ALU_1bit dut (.a(a), .b(b), .binvert(binvert), .cin(cin),
                  .op(op), .result(result), .cout(cout));

    initial begin
        $dumpfile("ALU_1bit_tb.vcd");
        $dumpvars(0, ALU_1bit_tb);
        for (i = 0; i < 64; i = i + 1) begin
            {op, binvert, cin, a, b} = i[5:0];
            #5;
            bx = b ^ binvert;
            case (op)
                2'b00: exp_res = a & b;
                2'b01: exp_res = a | b;
                2'b10: exp_res = a ^ b;
                2'b11: exp_res = a ^ bx ^ cin;
            endcase
            exp_cout = (a & bx) | (cin & (a ^ bx));
            if (result !== exp_res || cout !== exp_cout) begin
                errors = errors + 1;
                $display("FAIL op=%b a=%b b=%b binv=%b cin=%b -> res=%b cout=%b (exp %b %b)",
                         op, a, b, binvert, cin, result, cout, exp_res, exp_cout);
            end
        end
        if (errors == 0) $display("1-BIT ALU: ALL 64 TESTS PASSED");
        else             $display("1-BIT ALU: %0d FAILED", errors);
        $finish;
    end
endmodule
