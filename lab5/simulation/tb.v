module tb_top_fsm_system;
    reg clk;
    reg pbin;
    reg [15:0] physical_sw;
    wire [15:0] physical_leds;

    top_fsm_system dut (.clk(clk), .pbin(pbin),
        .physical_sw (physical_sw),
        .physical_leds (physical_leds));

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        pbin        = 1'b1;
        physical_sw = 16'd0;
        #40;

        pbin = 1'b0;
        @(posedge clk);

        // CASE 1: Full Countdown Test (4 -> 0)
        physical_sw = 16'd4;
        @(posedge clk);
        physical_sw = 16'd0;

        repeat (4) @(posedge dut.tick);
        @(posedge clk);

        #50;
        
        // CASE 2: Mid-Countdown Reset Test
        physical_sw = 16'd10;
        @(posedge clk);
        physical_sw = 16'd0;

        repeat (2) @(posedge dut.tick);

        // reset midway through countdown
        pbin = 1'b1;
        #20;
        pbin = 1'b0;
        @(posedge clk);

        #50;
        $finish;
    end

endmodule