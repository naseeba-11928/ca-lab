module top_fsm_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    wire rst_clean;
    wire [31:0] switch_data;
    wire [31:0] led_write_data;
    wire slow_clk;

    // Debounce reset button
    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );

    // Module to read physical switches
    leds led (
        .clk(clk), 
        .rst(rst_clean),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(30'd0),
        .switches(physical_sw),
        .readData(switch_data)
    );

    // Module to drive physical LEDs
    switches switch (
        .clk(clk), 
        .rst(rst_clean),
        .writeData(led_write_data),
        .writeEnable(1'b1),
        .readEnable(1'b0), 
        .memAddress(30'd0),
        .readData(),
        .leds(physical_leds)
    );

    // Generates the slow clock tick
    clock_divider ticker (
        .clk_in(clk),
        .rst(rst_clean),
        .clk_out(slow_clk)
    );

    // Edge detector: convert slow_clk rising edge to single-cycle tick
    reg slow_clk_d1, slow_clk_d2;
    always @(posedge clk) begin
        if (rst_clean) begin
            slow_clk_d1 <= 1'b0;
            slow_clk_d2 <= 1'b0;
        end else begin
            slow_clk_d1 <= slow_clk;
            slow_clk_d2 <= slow_clk_d1;
        end
    end
    wire tick = slow_clk_d1 & ~slow_clk_d2;

    wire [15:0] counter_val;
    wire        fsm_state;

    // FSM Counter instantiation
    fsm_counter #(.WIDTH(16)) u_fsm_counter (
        .clk         (clk),
        .rst         (rst_clean),
        .tick        (tick),
        .sw_val      (switch_data[15:0]),
        .counter_out (counter_val),
        .state_out   (fsm_state)
    );

    assign led_write_data = {16'd0, counter_val};

endmodule


//module clock_divider #(
//    parameter MAX_COUNT = 50_000_000 - 1 // Override to 2 in testbench for fast sim
//)(
//    input wire clk_in,
//    input wire rst,
//    output reg clk_out
//);
//    reg [25:0] count = 0;

//    always @(posedge clk_in) begin
//        if (rst) begin
//            count   <= 0;
//            clk_out <= 0;
//        end else if (count == MAX_COUNT) begin
//            count   <= 0;
//            clk_out <= ~clk_out;
//        end else begin
//            count   <= count + 1;
//        end
//    end
//endmodule



