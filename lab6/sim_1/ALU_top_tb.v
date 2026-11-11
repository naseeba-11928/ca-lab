`timescale 1ns / 1ps
// Testbench for ALU_top (FSM + ALU + debouncer)
// Presses the step button to walk the FSM through every operation and
// checks the LED output in each state.
module ALU_top_tb;
    reg         clk = 0;
    reg         btnRst = 0;
    reg         btnStep = 0;
    reg  [3:0]  sw = 4'b0000;
    wire [15:0] led;
    integer     c, errors = 0;
    reg  [31:0] exp;

    ALU_top dut (.clk(clk), .btnRst(btnRst), .btnStep(btnStep), .sw(sw), .led(led));

    always #5 clk = ~clk;                     // 100 MHz clock

    localparam [31:0] OP_A = 32'h10101010;
    localparam [31:0] OP_B = 32'h01010101;
    localparam [4:0]  SH   = 5'd1;            // OP_B[4:0]

    function [31:0] expected(input [3:0] ctrl);
        case (ctrl)
            4'b0000: expected = OP_A & OP_B;
            4'b0001: expected = OP_A | OP_B;
            4'b0010: expected = OP_A + OP_B;
            4'b0011: expected = OP_A ^ OP_B;
            4'b0100: expected = OP_A << SH;
            4'b0101: expected = OP_A >> SH;
            4'b0110: expected = OP_A - OP_B;
            4'b0111: expected = OP_A - OP_B;
            default: expected = 32'b0;
        endcase
    endfunction

    // one button press: hold high, release, wait
    task press;
        begin
            btnStep = 1;
            repeat (4) @(posedge clk);
            btnStep = 0;
            repeat (4) @(posedge clk);
            #1;
        end
    endtask

    task check(input [15:0] exp_led, input [127:0] what);
        begin
            if (led !== exp_led) begin
                errors = errors + 1;
                $display("FAIL ctrl=%b %0s: led=%h expected %h", sw, what, led, exp_led);
            end else
                $display("PASS ctrl=%b %0s: led=%h", sw, what, led);
        end
    endtask

    initial begin
        $dumpfile("ALU_top_tb.vcd");
        $dumpvars(0, ALU_top_tb);

        // reset
        btnRst = 1; repeat (3) @(posedge clk); btnRst = 0; #1;

        for (c = 0; c < 8; c = c + 1) begin
            exp = expected(c[3:0]);
            sw = c[3:0];
            press; check(exp[31:16],      "high16 ");       // press 1: latch sw, show result[31:16]
            press; check({15'b0, (exp == 32'b0)}, "zero   "); // press 2: show Zero flag
            press; check({12'b0, c[3:0]}, "latch  ");       // press 3: back to start, echoes opcode
        end

        // reset in the middle of a sequence returns FSM to the start
        sw = 4'b0010;
        press;
        btnRst = 1; repeat (3) @(posedge clk); btnRst = 0; #1;
        check(16'h0000, "reset  ");

        if (errors == 0) $display("ALU_TOP: ALL TESTS PASSED");
        else             $display("ALU_TOP: %0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule