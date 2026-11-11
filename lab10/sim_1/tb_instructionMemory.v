`timescale 1ns / 1ps
module tb_instructionMemory;
    reg  [31:0] pc;
    wire [31:0] inst;
    integer k;

    instructionMemory #(.OPERAND_LENGTH(31)) dut (.instAddress(pc), .instruction(inst));

    // Expected words (from fsm_countdown_fixed.s, hand-assembled)
    reg [31:0] expected [0:28];
    initial begin
        expected[0]=32'h1FC00113; expected[1]=32'h30000293; expected[2]=32'h20000313; expected[3]=32'h30400E93;
        expected[4]=32'h00032023; expected[5]=32'h0002A583; expected[6]=32'hFE058EE3; expected[7]=32'h00058513;
        expected[8]=32'h008000EF; expected[9]=32'hFEDFF06F; expected[10]=32'hFF810113; expected[11]=32'h00112223;
        expected[12]=32'h00812023; expected[13]=32'h00050413; expected[14]=32'h00832023; expected[15]=32'h02040263;
        expected[16]=32'hFFF40413; expected[17]=32'h002623B7; expected[18]=32'h5A038393; expected[19]=32'h000EAE03;
        expected[20]=32'h000E1863; expected[21]=32'hFFF38393; expected[22]=32'hFE039AE3; expected[23]=32'hFDDFF06F;
        expected[24]=32'h00032023; expected[25]=32'h00012403; expected[26]=32'h00412083; expected[27]=32'h00810113;
        expected[28]=32'h00008067;

        for (k = 0; k < 29; k = k + 1) begin
            pc = k * 4; #10;
            if (inst !== expected[k])
                $display("FAIL pc=%h got %h expected %h", pc, inst, expected[k]);
            else
                $display("ok   pc=%h inst=%h", pc, inst);
        end
        $finish;
    end
endmodule
