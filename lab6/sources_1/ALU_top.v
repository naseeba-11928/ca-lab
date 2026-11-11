`timescale 1ns / 1ps
// Top-level: ALU + FSM, using the Lab 5 modules:
//   debouncer  - button debounce
//   leds       - (Lab 5 name) reads the switches  -> readData
//   switches   - (Lab 5 name) drives the LEDs     -> leds register
// sw[3:0]  -> ALUControl (read through the Lab 5 'leds' module)
// btnStep  -> advance FSM (through the debouncer)
// led[15:0]-> top 16 bits ALUResult[31:16], or Zero flag (through the Lab 5 'switches' module)
module ALU_top (
    input         clk,
    input         btnRst,
    input         btnStep,
    input  [3:0]  sw,
    output [15:0] led
);
    // Fixed operands
    localparam [31:0] OP_A = 32'h10101010;
    localparam [31:0] OP_B = 32'h01010101;

    // ---- Lab 5 debouncer ----
    wire step_clean;
    debouncer db_step (.clk(clk), .pbin(btnStep), .pbout(step_clean));

    // Rising-edge detect -> one-cycle pulse
    reg step_d;
    always @(posedge clk) step_d <= step_clean;
    wire step_pulse = step_clean & ~step_d;

    // ---- Lab 5 switch interface (module is named 'leds' in Lab 5) ----
    wire [31:0] sw_read;
    leds sw_if (
        .clk(clk), .rst(btnRst),
        .btns(16'd0),
        .writeData(32'd0), .writeEnable(1'b0),
        .readEnable(1'b1), .memAddress(30'd0),
        .switches({12'd0, sw}),
        .readData(sw_read)
    );
    wire [3:0] sw_val = sw_read[3:0];

    // ---- ALU ----
    reg  [3:0]  alu_ctrl;
    wire [31:0] alu_result;
    wire        alu_zero;
    ALU alu0 (.A(OP_A), .B(OP_B), .ALUControl(alu_ctrl),
              .ALUResult(alu_result), .Zero(alu_zero));

    // ---- FSM ----
    localparam S_LATCH = 2'd0,  // showing opcode echo; next press latches switches
               S_HIGH  = 2'd1,  // show ALUResult[31:16] (top half)
               S_ZERO  = 2'd2;  // show Zero flag on led[0]
    reg [1:0] state;

    always @(posedge clk) begin
        if (btnRst) begin
            state    <= S_LATCH;
            alu_ctrl <= 4'b0000;
        end else if (step_pulse) begin
            case (state)
                S_LATCH: begin alu_ctrl <= sw_val; state <= S_HIGH; end
                S_HIGH:  state <= S_ZERO;
                S_ZERO:  state <= S_LATCH;
                default: state <= S_LATCH;
            endcase
        end
    end

    // ---- value to display ----
    reg [15:0] led_value;
    always @(*) begin
        case (state)
            S_LATCH: led_value = {12'b0, alu_ctrl};
            S_HIGH:  led_value = alu_result[31:16];
            S_ZERO:  led_value = {15'b0, alu_zero};
            default: led_value = 16'b0;
        endcase
    end

    // ---- Lab 5 LED interface (module is named 'switches' in Lab 5) ----
    // Writes led_value into the LED register every clock cycle.
    switches led_if (
        .clk(clk), .rst(btnRst),
        .writeData({16'd0, led_value}), .writeEnable(1'b1),
        .readEnable(1'b0), .memAddress(30'd0),
        .readData(),
        .leds(led)
    );
endmodule
