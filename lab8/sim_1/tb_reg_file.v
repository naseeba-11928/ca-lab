module tb_reg_file;
    // inputs
    reg clk;
    reg rst;
    reg WriteEnable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] WriteData;

    // outputs
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    reg_file uut (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1;
        WriteEnable = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        WriteData = 32'h00000000;

        #12;
        rst = 0;
        #10;

        @(posedge clk);
        WriteEnable = 1;
        rd = 5'd5;
        WriteData = 32'hABCDEF12;
        
        @(posedge clk);
        WriteEnable = 0; // Disable write to hold value
        rs1 = 5'd5;      // Read back from x5 via ReadData1
        #1;

        // Test Case ii: Attempt to write to x0 and verify it remains zero
        @(posedge clk);
        WriteEnable = 1;
        rd = 5'd0;
        WriteData = 32'h12345678; // Attempt to overwrite x0
        
        @(posedge clk);
        WriteEnable = 0;
        rs1 = 5'd0;      // Read from x0
        #1;
        
        // Test Case iii: Simultaneous two read ports verification
        @(posedge clk);
        WriteEnable = 1;
        rd = 5'd6;
        WriteData = 32'hCAFEBABA;
        
        @(posedge clk);
        WriteEnable = 0;
        rs1 = 5'd5;      // Should read x5 (0xDEADBEEF)
        rs2 = 5'd6;      // Should read x6 (0xCAFEBABE) concurrently
        #1;

        // Test Case iv: Overwrite a register and verify old value is replaced
        @(posedge clk);
        WriteEnable = 1;
        rd = 5'd5;
        WriteData = 32'h11112222; // Overwrite x5 with new data
        
        @(posedge clk);
        WriteEnable = 0;
        rs1 = 5'd5;
        #1;

        // Test Case v: Reset behavior check
        @(posedge clk);
        rst = 1; // Assert reset
        @(posedge clk);
        rst = 0;
        rs1 = 5'd5; // Check if x5 cleared to 0
        #1;

        #20;
    end

endmodule