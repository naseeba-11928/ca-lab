// Task 3 top level: FSM + Register File + ALU on FPGA
//
// Switches:
//   sw[3:0]   ALUControl (0000 AND | 0001 OR | 0010 ADD | 0011 XOR |
//                         0100 SLL | 0101 SRL | 0110 SUB | 0111 BEQ)
//   sw[4]     WriteEnable for the result write
//   sw[9:5]   rd (destination register for the result write)
//   sw[14:10] rs2 (second source register, operand B)
// LEDs:
//   led[15:13]  FSM state
//   led[11:0]   ALUResult[11:0] (lower bits)



module top_rf_alu_fsm (
    input         clk,
    input         btnRst,
    input  [15:0] sw,
    output [15:0] led
);

    localparam [31:0] CONST_A = 32'h10101010;   //  x1
    localparam [31:0] CONST_B = 32'h01010101;   // x2

    // states
    localparam IDLE            = 3'd0;
    localparam INIT_X1         = 3'd1;
    localparam INIT_X2         = 3'd2;
    localparam READ_REGISTERS  = 3'd3;
    localparam ALU_OPERATION   = 3'd4;
    localparam WRITE_REGISTERS = 3'd5;

    reg [2:0] state;
    wire clk_div, clk_slow;
    clock_divider #(.DIV(25000000)) u_clkdiv (.clk(clk), .clk_out(clk_div));
    BUFG u_bufg (.I(clk_div), .O(clk_slow));

    wire rst;
    debouncer u_deb (.clk(clk), .pbin(btnRst), .pbout(rst));

    wire [31:0] sw_data;
    leds u_sw_if (
        .clk(clk_slow), .rst(rst), .btns(16'd0),
        .writeData(32'd0), .writeEnable(1'b0), .readEnable(1'b1),
        .memAddress(30'd0), .switches(sw), .readData(sw_data)
    );

    reg  [4:0]  rs1, rs2, rd;
    reg  [31:0] WriteData;
    reg         WriteEnable;
    reg         led_we;

    wire [31:0] ReadData1, ReadData2, ALUResult;
    wire        Zero;
    wire [3:0]  ALUControl = sw_data[3:0];
    wire        sw_we      = sw_data[4];
    wire [4:0]  sw_rd      = sw_data[9:5];
    wire [4:0]  sw_rs2     = sw_data[14:10];

    reg_file u_rf (
        .clk(clk_slow), .rst(rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    ALU u_alu (
        .A(ReadData1), .B(ReadData2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult), .Zero(Zero)
    );

    // LED register holds the result (lower bits)
    wire [15:0] res_leds;
    switches u_led_if (
        .clk(clk_slow), .rst(rst),
        .writeData({16'd0, 4'd0, ALUResult[11:0]}),
        .writeEnable(led_we), .readEnable(1'b0),
        .memAddress(30'd0), .readData(), .leds(res_leds)
    );

    assign led = {state, 1'b0, res_leds[11:0]};

    // state register
    always @(posedge clk_slow or posedge rst) begin
        if (rst) state <= IDLE;
        else case (state)
            IDLE:            state <= INIT_X1;
            INIT_X1:         state <= INIT_X2;
            INIT_X2:         state <= READ_REGISTERS;
            READ_REGISTERS:  state <= ALU_OPERATION;
            ALU_OPERATION:   state <= WRITE_REGISTERS;
            WRITE_REGISTERS: state <= READ_REGISTERS;   // repeat forever
            default:         state <= IDLE;
        endcase
    end

    // outputs of each state
    always @(*) begin
        rs1 = 5'd1;                      // operand A is always x1
        rs2 = sw_rs2;                    // operand B chosen by switches
        rd = 5'd0; WriteData = 32'd0;
        WriteEnable = 1'b0; led_we = 1'b0;
        case (state)
            INIT_X1: begin rd = 5'd1; WriteData = CONST_A; WriteEnable = 1'b1; end
            INIT_X2: begin rd = 5'd2; WriteData = CONST_B; WriteEnable = 1'b1; end
            WRITE_REGISTERS: begin
                rd          = sw_rd;        // destination chosen by switches
                WriteData   = ALUResult;
                WriteEnable = sw_we;        // write enable forced by switch
                led_we      = 1'b1;         // always show result on LEDs
            end
            default: ;
        endcase
    end
endmodule





//---without clock----
//// Task 3 top level: FSM + Register File + ALU on FPGA
////
//// Switches:
////   sw[3:0]   ALUControl (0000 AND | 0001 OR | 0010 ADD | 0011 XOR |
////                         0100 SLL | 0101 SRL | 0110 SUB | 0111 BEQ)
////   sw[4]     WriteEnable for the result write
////   sw[9:5]   rd (destination register for the result write)
////   sw[14:10] rs2 (second source register, operand B)
//// LEDs:
////   led[15:13]  FSM state
////   led[11:0]   ALUResult[11:0] (lower bits)
//module top_rf_alu_fsm (
//    input         clk,
//    input         btnRst,
//    input  [15:0] sw,
//    output [15:0] led
//);

//    localparam [31:0] CONST_A = 32'h10101010;   // -> x1
//    localparam [31:0] CONST_B = 32'h01010101;   // -> x2

//    // states
//    localparam IDLE            = 3'd0;
//    localparam INIT_X1         = 3'd1;
//    localparam INIT_X2         = 3'd2;
//    localparam READ_REGISTERS  = 3'd3;
//    localparam ALU_OPERATION   = 3'd4;
//    localparam WRITE_REGISTERS = 3'd5;

//    reg [2:0] state;

//    // Lab 5 interfaces
//    wire rst;
//    debouncer u_deb (.clk(clk), .pbin(btnRst), .pbout(rst));

//    wire [31:0] sw_data;
//    leds u_sw_if (
//        .clk(clk), .rst(rst), .btns(16'd0),
//        .writeData(32'd0), .writeEnable(1'b0), .readEnable(1'b1),
//        .memAddress(30'd0), .switches(sw), .readData(sw_data)
//    );

//    reg  [4:0]  rs1, rs2, rd;
//    reg  [31:0] WriteData;
//    reg         WriteEnable;
//    reg         led_we;

//    wire [31:0] ReadData1, ReadData2, ALUResult;
//    wire        Zero;
//    wire [3:0]  ALUControl = sw_data[3:0];
//    wire        sw_we      = sw_data[4];
//    wire [4:0]  sw_rd      = sw_data[9:5];
//    wire [4:0]  sw_rs2     = sw_data[14:10];

//    reg_file u_rf (
//        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
//        .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
//        .ReadData1(ReadData1), .ReadData2(ReadData2)
//    );

//    ALU u_alu (
//        .A(ReadData1), .B(ReadData2),
//        .ALUControl(ALUControl),
//        .ALUResult(ALUResult), .Zero(Zero)
//    );

//    // LED register holds the result (lower bits)
//    wire [15:0] res_leds;
//    switches u_led_if (
//        .clk(clk), .rst(rst),
//        .writeData({16'd0, 4'd0, ALUResult[11:0]}),
//        .writeEnable(led_we), .readEnable(1'b0),
//        .memAddress(30'd0), .readData(), .leds(res_leds)
//    );

//    assign led = {state, 1'b0, res_leds[11:0]};

//    // state register
//    always @(posedge clk) begin
//        if (rst) state <= IDLE;
//        else case (state)
//            IDLE:            state <= INIT_X1;
//            INIT_X1:         state <= INIT_X2;
//            INIT_X2:         state <= READ_REGISTERS;
//            READ_REGISTERS:  state <= ALU_OPERATION;
//            ALU_OPERATION:   state <= WRITE_REGISTERS;
//            WRITE_REGISTERS: state <= READ_REGISTERS;   // repeat forever
//            default:         state <= IDLE;
//        endcase
//    end

//    // outputs of each state
//    always @(*) begin
//        rs1 = 5'd1;                      // operand A is always x1
//        rs2 = sw_rs2;                    // operand B chosen by switches
//        rd = 5'd0; WriteData = 32'd0;
//        WriteEnable = 1'b0; led_we = 1'b0;
//        case (state)
//            INIT_X1: begin rd = 5'd1; WriteData = CONST_A; WriteEnable = 1'b1; end
//            INIT_X2: begin rd = 5'd2; WriteData = CONST_B; WriteEnable = 1'b1; end
//            WRITE_REGISTERS: begin
//                rd          = sw_rd;        // destination chosen by switches
//                WriteData   = ALUResult;
//                WriteEnable = sw_we;        // write enable forced by switch
//                led_we      = 1'b1;         // always show result on LEDs
//            end
//            default: ;
//        endcase
//    end
//endmodule









//// Task 3 top level: FSM + Register File + ALU on FPGA
////
//// Switches:
////   sw[2:0]  ALU operation (000 AND | 001 OR | 010 ADD | 011 XOR |
////                           100 SLL | 101 SRL | 110 SUB | 111 BEQ)
////   sw[3]    WriteEnable for the result write
////   sw[8:4]  rd (destination register for the result write)
////   sw[13:9] rs2 (second source register, operand B)
//// LEDs:
////   led[15:13]  FSM state
////   led[11:0]   ALUResult[11:0] (lower bits)
//module top_rf_alu_fsm (
//    input         clk,
//    input         btnRst,
//    input  [15:0] sw,
//    output [15:0] led
//);

//    localparam [31:0] CONST_A = 32'h10101010;   // -> x1
//    localparam [31:0] CONST_B = 32'h01010101;   // -> x2

//    // states
//    localparam IDLE            = 3'd0;
//    localparam INIT_X1         = 3'd1;
//    localparam INIT_X2         = 3'd2;
//    localparam READ_REGISTERS  = 3'd3;
//    localparam ALU_OPERATION   = 3'd4;
//    localparam WRITE_REGISTERS = 3'd5;

//    reg [2:0] state;

//    // Lab 5 interfaces
//    wire rst;
//    debouncer u_deb (.clk(clk), .pbin(btnRst), .pbout(rst));

//    wire [31:0] sw_data;
//    leds u_sw_if (
//        .clk(clk), .rst(rst), .btns(16'd0),
//        .writeData(32'd0), .writeEnable(1'b0), .readEnable(1'b1),
//        .memAddress(30'd0), .switches(sw), .readData(sw_data)
//    );

//    reg  [4:0]  rs1, rs2, rd;
//    reg  [31:0] WriteData;
//    reg         WriteEnable;
//    reg         led_we;

//    wire [31:0] ReadData1, ReadData2, ALUResult;
//    wire        Zero;
//    wire [3:0]  ALUControl = {1'b0, sw_data[2:0]};
//    wire        sw_we      = sw_data[3];
//    wire [4:0]  sw_rd      = sw_data[8:4];
//    wire [4:0]  sw_rs2     = sw_data[13:9];

//    reg_file u_rf (
//        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
//        .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
//        .ReadData1(ReadData1), .ReadData2(ReadData2)
//    );

//    ALU u_alu (
//        .A(ReadData1), .B(ReadData2),
//        .ALUControl(ALUControl),
//        .ALUResult(ALUResult), .Zero(Zero)
//    );

//    // LED register holds the result (lower bits)
//    wire [15:0] res_leds;
//    switches u_led_if (
//        .clk(clk), .rst(rst),
//        .writeData({16'd0, 4'd0, ALUResult[11:0]}),
//        .writeEnable(led_we), .readEnable(1'b0),
//        .memAddress(30'd0), .readData(), .leds(res_leds)
//    );

//    assign led = {state, 1'b0, res_leds[11:0]};

//    // state register
//    always @(posedge clk) begin
//        if (rst) state <= IDLE;
//        else case (state)
//            IDLE:            state <= INIT_X1;
//            INIT_X1:         state <= INIT_X2;
//            INIT_X2:         state <= READ_REGISTERS;
//            READ_REGISTERS:  state <= ALU_OPERATION;
//            ALU_OPERATION:   state <= WRITE_REGISTERS;
//            WRITE_REGISTERS: state <= READ_REGISTERS;   // repeat forever
//            default:         state <= IDLE;
//        endcase
//    end

//    // outputs of each state
//    always @(*) begin
//        rs1 = 5'd1;                      // operand A is always x1
//        rs2 = sw_rs2;                    // operand B chosen by switches
//        rd = 5'd0; WriteData = 32'd0;
//        WriteEnable = 1'b0; led_we = 1'b0;
//        case (state)
//            INIT_X1: begin rd = 5'd1; WriteData = CONST_A; WriteEnable = 1'b1; end
//            INIT_X2: begin rd = 5'd2; WriteData = CONST_B; WriteEnable = 1'b1; end
//            WRITE_REGISTERS: begin
//                rd          = sw_rd;        // destination chosen by switches
//                WriteData   = ALUResult;
//                WriteEnable = sw_we;        // write enable forced by switch
//                led_we      = 1'b1;         // always show result on LEDs
//            end
//            default: ;
//        endcase
//    end
//endmodule






















////module top_rf_alu_fsm (
////    input         clk,
////    input         btnRst,     
////    input  [15:0] sw,          
////    output [15:0] led
////);

////    localparam [31:0] CONST_A = 32'h10101010;   // -> x1
////    localparam [31:0] CONST_B = 32'h01010101;   // -> x2

////    // states:
////    localparam IDLE            = 3'd0;
////    localparam INIT_X1         = 3'd1;
////    localparam INIT_X2         = 3'd2;
////    localparam READ_REGISTERS  = 3'd3;
////    localparam ALU_OPERATION   = 3'd4;
////    localparam WRITE_REGISTERS = 3'd5;

////    reg [2:0] state;
////    wire rst;
////    debouncer u_deb (.clk(clk), .pbin(btnRst), .pbout(rst));

////    wire [31:0] sw_data;
////    leds u_sw_if (
////        .clk(clk), .rst(rst), .btns(16'd0),
////        .writeData(32'd0), .writeEnable(1'b0), .readEnable(1'b1),
////        .memAddress(30'd0), .switches(sw), .readData(sw_data)
////    );

////    reg  [4:0]  rs1, rs2, rd;
////    reg  [31:0] WriteData;
////    reg         WriteEnable;
////    reg         led_we;

////    wire [31:0] ReadData1, ReadData2, ALUResult;
////    wire        Zero;
////    wire [3:0]  ALUControl = {1'b0, sw_data[2:0]};

////    reg_file u_rf (
////        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
////        .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
////        .ReadData1(ReadData1), .ReadData2(ReadData2)
////    );

////    ALU u_alu (
////        .A(ReadData1), .B(ReadData2),
////        .ALUControl(ALUControl),
////        .ALUResult(ALUResult), .Zero(Zero)
////    );

////    switches u_led_if (
////        .clk(clk), .rst(rst),
////        // before (upper half)
////        //.writeData({16'd0, ALUResult[31:16]}),
////        // after (lower half)
////        .writeData({16'd0, ALUResult[15:0]}),
////        .writeEnable(led_we), .readEnable(1'b0),
////        .memAddress(30'd0), .readData(), .leds(led)
////    );

////    always @(posedge clk) begin
////        if (rst) state <= IDLE;
////        else case (state)
////            IDLE:            state <= INIT_X1;
////            INIT_X1:         state <= INIT_X2;
////            INIT_X2:         state <= READ_REGISTERS;
////            READ_REGISTERS:  state <= ALU_OPERATION;
////            ALU_OPERATION:   state <= WRITE_REGISTERS;
////            WRITE_REGISTERS: state <= READ_REGISTERS;   // repeat forever
////            default:         state <= IDLE;
////        endcase
////    end

////    always @(*) begin
////        rs1 = 5'd1; rs2 = 5'd2;          // always read x1 and x2
////        rd = 5'd0; WriteData = 32'd0;
////        WriteEnable = 1'b0; led_we = 1'b0;
////        case (state)
////            INIT_X1: begin rd = 5'd1; WriteData = CONST_A; WriteEnable = 1'b1; end
////            INIT_X2: begin rd = 5'd2; WriteData = CONST_B; WriteEnable = 1'b1; end
////            WRITE_REGISTERS: begin
////                rd = 5'd4; WriteData = ALUResult; WriteEnable = 1'b1;  // result -> x4
////                led_we = 1'b1;                                         // show on LEDs
////            end
////            default: ;
////        endcase
////    end
////endmodule