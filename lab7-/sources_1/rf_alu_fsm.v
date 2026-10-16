module rf_alu_fsm (
    input         clk,
    input         rst,
    // debug outputs for the waveform
    output reg [2:0]  state,
    output reg [2:0]  op_idx,
    output     [3:0]  ALUControl,
    output     [31:0] ALUResult,
    output            Zero
);

    localparam [31:0] CONST_A = 32'h10101010;   // -> x1
    localparam [31:0] CONST_B = 32'h01010101;   // -> x2

    // states
    localparam IDLE            = 3'd0;
    localparam INIT_X1         = 3'd1;
    localparam INIT_X2         = 3'd2;
    localparam READ_REGISTERS  = 3'd3;
    localparam ALU_OPERATION   = 3'd4;
    localparam WRITE_REGISTERS = 3'd5;

    reg  [4:0]  rs1, rs2, rd;
    reg  [31:0] WriteData;
    reg         WriteEnable;
    reg  [3:0]  op_code;
    reg  [4:0]  dest_reg;

    wire [31:0] ReadData1, ReadData2;

    reg_file u_rf (
        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    ALU u_alu (
        .A(ReadData1), .B(ReadData2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult), .Zero(Zero)
    );

    // operation table: op_idx -> ALU opcode and destination register
    always @(*) begin
        case (op_idx)
            3'd0: begin op_code = 4'b0010; dest_reg = 5'd4;  end // ADD -> x4
            3'd1: begin op_code = 4'b0110; dest_reg = 5'd5;  end // SUB -> x5
            3'd2: begin op_code = 4'b0000; dest_reg = 5'd6;  end // AND -> x6
            3'd3: begin op_code = 4'b0001; dest_reg = 5'd7;  end // OR  -> x7
            3'd4: begin op_code = 4'b0011; dest_reg = 5'd8;  end // XOR -> x8
            3'd5: begin op_code = 4'b0100; dest_reg = 5'd9;  end // SLL -> x9
            3'd6: begin op_code = 4'b0101; dest_reg = 5'd10; end // SRL -> x10
            default: begin op_code = 4'b0111; dest_reg = 5'd11; end // BEQ -> x11 (flag)
        endcase
    end

    assign ALUControl = op_code;

    // state register
    always @(posedge clk) begin
        if (rst) begin
            state  <= IDLE;
            op_idx <= 3'd0;
        end else case (state)
            IDLE:            state <= INIT_X1;
            INIT_X1:         state <= INIT_X2;
            INIT_X2:         state <= READ_REGISTERS;
            READ_REGISTERS:  state <= ALU_OPERATION;
            ALU_OPERATION:   state <= WRITE_REGISTERS;
            WRITE_REGISTERS: begin
                if (op_idx == 3'd7) begin
                    op_idx <= 3'd0;
                    state  <= IDLE;               // all operations done
                end else begin
                    op_idx <= op_idx + 1'b1;
                    state  <= READ_REGISTERS;     // next operation
                end
            end
            default:         state <= IDLE;
        endcase
    end

    // outputs of each state
    always @(*) begin
        rs1 = 5'd1; rs2 = 5'd2;          // always read x1 and x2
        rd = 5'd0; WriteData = 32'd0; WriteEnable = 1'b0;
        case (state)
            INIT_X1: begin rd = 5'd1; WriteData = CONST_A; WriteEnable = 1'b1; end
            INIT_X2: begin rd = 5'd2; WriteData = CONST_B; WriteEnable = 1'b1; end
            WRITE_REGISTERS: begin
                rd = dest_reg;
                WriteData = (op_idx == 3'd7) ? {31'd0, Zero} : ALUResult;
                WriteEnable = 1'b1;
            end
            default: ;
        endcase
    end
endmodule