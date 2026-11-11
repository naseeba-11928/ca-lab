module reg_file (
    input wire clk,
    input wire rst,
    input wire WriteEnable,
    input wire [4:0] rs1,          // Source register 1 address
    input wire [4:0] rs2,          // Source register 2 address
    input wire [4:0] rd,           // Destination register address
    input wire [31:0] WriteData,   // Data to write
    output wire [31:0] ReadData1,  // Read data output 1
    output wire [31:0] ReadData2   // Read data output 2
);

    // 32 x 32 register array
    reg [31:0] regs [31:0];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // clear all registers on reset
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end else if (WriteEnable && (rd != 5'b00000)) begin
            // write data if enabled and destination is not x0
            regs[rd] <= WriteData;
        end
    end

    //x0 hardwired to 0
    assign ReadData1 = (rs1 == 5'b00000) ? 32'b0 : regs[rs1];
    assign ReadData2 = (rs2 == 5'b00000) ? 32'b0 : regs[rs2];

endmodule