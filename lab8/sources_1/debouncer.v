module debouncer(
    input  clk,
    input  pbin,
    output reg pbout = 1'b0
);
    reg [19:0] cnt = 20'd0;
    always @(posedge clk) begin
        if (pbin == pbout) cnt <= 20'd0;
        else begin
            cnt <= cnt + 1'b1;
            if (cnt == 20'hFFFFF) pbout <= pbin;
        end
    end
endmodule