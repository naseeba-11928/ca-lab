`timescale 1ns / 1ps
module ALU_tb;
    reg  [31:0] A, B;
    reg  [3:0]  ALUControl;
    wire [31:0] ALUResult;
    wire        Zero;
    integer errors = 0;

    ALU dut (.A(A), .B(B), .ALUControl(ALUControl), .ALUResult(ALUResult), .Zero(Zero));

    task check(input [3:0] ctrl, input [31:0] a, input [31:0] b,
               input [31:0] exp_res, input exp_zero);
        begin
            ALUControl = ctrl; A = a; B = b;
            #10;
            if (ALUResult !== exp_res || Zero !== exp_zero) begin
                errors = errors + 1;
                $display("FAIL ctrl=%b A=%h B=%h -> res=%h zero=%b (exp %h, %b)",
                         ctrl, a, b, ALUResult, Zero, exp_res, exp_zero);
            end else
                $display("PASS ctrl=%b A=%h B=%h -> res=%h zero=%b",
                         ctrl, a, b, ALUResult, Zero);
        end
    endtask

    initial begin
        $dumpfile("ALU_tb.vcd");
        $dumpvars(0, ALU_tb);

        // AND, OR, ADD, XOR, SLL, SRL, SUB, BEQ with Lab operands
        check(4'b0000, 32'h10101010, 32'h01010101, 32'h00000000, 1'b1); // AND
        check(4'b0001, 32'h10101010, 32'h01010101, 32'h11111111, 1'b0); // OR
        check(4'b0010, 32'h10101010, 32'h01010101, 32'h11111111, 1'b0); // ADD
        check(4'b0011, 32'h10101010, 32'h01010101, 32'h11111111, 1'b0); // XOR
        check(4'b0100, 32'h10101010, 32'h01010101, 32'h20202020, 1'b0); // SLL by 1
        check(4'b0101, 32'h10101010, 32'h01010101, 32'h08080808, 1'b0); // SRL by 1
        check(4'b0110, 32'h10101010, 32'h01010101, 32'h0F0F0F0F, 1'b0); // SUB
        check(4'b0111, 32'h10101010, 32'h01010101, 32'h0F0F0F0F, 1'b0); // BEQ not equal
        check(4'b0111, 32'hABCD1234, 32'hABCD1234, 32'h00000000, 1'b1); // BEQ equal

        // Corner cases
        check(4'b0010, 32'hFFFFFFFF, 32'h00000001, 32'h00000000, 1'b1); // ADD overflow wrap
        check(4'b0110, 32'h00000000, 32'h00000001, 32'hFFFFFFFF, 1'b0); // SUB underflow
        check(4'b0100, 32'h00000001, 32'h0000001F, 32'h80000000, 1'b0); // SLL by 31
        check(4'b0101, 32'h80000000, 32'h0000001F, 32'h00000001, 1'b0); // SRL by 31
        check(4'b0100, 32'hDEADBEEF, 32'h00000000, 32'hDEADBEEF, 1'b0); // shift by 0
        check(4'b1111, 32'h12345678, 32'h9ABCDEF0, 32'h00000000, 1'b1); // invalid op

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule