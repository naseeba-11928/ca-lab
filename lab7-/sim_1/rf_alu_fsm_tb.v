module rf_alu_fsm_tb;
    reg clk;  reg  rst;
    wire [2:0]  state;  wire [2:0]  op_idx;
    wire [3:0]  ALUControl;  wire [31:0] ALUResult;  wire Zero;

    rf_alu_fsm dut (.clk(clk), .rst(rst),.state(state), .op_idx(op_idx),
        .ALUControl(ALUControl), .ALUResult(ALUResult), .Zero(Zero));

    wire [31:0] x0  = dut.u_rf.regs[0];
    wire [31:0] x1  = dut.u_rf.regs[1];
    wire [31:0] x2  = dut.u_rf.regs[2];
    wire [31:0] x4  = dut.u_rf.regs[4];    // ADD
    wire [31:0] x5  = dut.u_rf.regs[5];    // SUB
    wire [31:0] x6  = dut.u_rf.regs[6];    // AND
    wire [31:0] x7  = dut.u_rf.regs[7];    // OR
    wire [31:0] x8  = dut.u_rf.regs[8];    // XOR
    wire [31:0] x9  = dut.u_rf.regs[9];    // SLL
    wire [31:0] x10 = dut.u_rf.regs[10];   // SRL
    wire [31:0] x11 = dut.u_rf.regs[11];   // BEQ flag

    wire [31:0] ReadData1 = dut.ReadData1;
    wire [31:0] ReadData2 = dut.ReadData2;
    // 10 ns clock
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        #22;
        rst = 0;
        #600;
    end
endmodule
