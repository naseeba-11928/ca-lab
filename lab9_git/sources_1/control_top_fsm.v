//==============================================================
// Control_top: switches -> FSM -> MainControl/ALUControl -> LEDs
//
// Switch map (SW0 = LSB):
//   SW[6:0]  = opcode[6:0]
//   SW[9:7]  = funct3[2:0]
//   SW[10]   = funct7[5]   (only funct7 bit that matters; rest forced to 0)
//   SW[15:11]= unused
//
// LED map:
//   LED0 RegWrite   LED1 ALUSrc   LED2 MemRead   LED3 MemWrite
//   LED4 MemtoReg   LED5 Branch   LED[7:6]  ALUOp
//   LED[11:8] ALUControl          LED[13:12] FSM state (debug)
//
// btn_db must be the DEBOUNCED button level from the Lab 5 module.
// Press the button to latch the switches and update the LEDs.
//==============================================================

module Control_top (
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] sw,
    input  wire        btn_db,
    output wire [15:0] led
);
    localparam S_WAIT    = 2'd0; 
    localparam S_LATCH   = 2'd1; 
    localparam S_DECODE  = 2'd2; 
    localparam S_DISPLAY = 2'd3;  

    reg [1:0] state;
    reg [11:0] led_r;   // latched control outputs
    assign led = {2'b00, state, led_r};   

    // button rising-edge detect 
    reg btn_prev;
    wire btn_press = btn_db & ~btn_prev;

    //instruction fields
    reg [6:0] opcode_r;
    reg [2:0] funct3_r;
    reg       f7b5_r;

    wire [6:0] funct7_w = {1'b0, f7b5_r, 5'b00000};

    // control units
    wire       RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    MainControl u_main (
        .opcode(opcode_r),
        .RegWrite(RegWrite), .ALUSrc(ALUSrc),
        .MemRead(MemRead), .MemWrite(MemWrite),
        .MemtoReg(MemtoReg), .Branch(Branch),
        .ALUOp(ALUOp)
    );

    ALUControl u_alu (
        .ALUOp(ALUOp), .funct3(funct3_r), .funct7(funct7_w),
        .ALUControl(ALUControl)
    );

    // FSM
    always @(posedge clk) begin
        if (rst) begin
            state    <= S_WAIT;
            btn_prev <= 1'b0;
            opcode_r <= 7'd0;
            funct3_r <= 3'd0;
            f7b5_r   <= 1'b0;
            led_r    <= 12'd0;
        end else begin
            btn_prev <= btn_db;
            case (state)
                S_WAIT:    if (btn_press) state <= S_LATCH;
                S_LATCH: begin
                    opcode_r <= sw[6:0];
                    funct3_r <= sw[9:7];
                    f7b5_r   <= sw[10];
                    state    <= S_DECODE;
                end
                S_DECODE:  state <= S_DISPLAY;
                S_DISPLAY: begin
                    led_r <= {ALUControl, ALUOp,
                              Branch, MemtoReg, MemWrite, MemRead, ALUSrc, RegWrite};
                    state <= S_WAIT;
                end
                default:   state <= S_WAIT;
            endcase
        end
    end
endmodule