// Clock divider: clk_out toggles every DIV input cycles
// f_out = f_in / (2 * DIV)  ->  100 MHz / (2 * 25,000,000) = 2 Hz
module clock_divider #(
    parameter DIV = 25000000
)(
    input  clk,
    output reg clk_out = 1'b0
);
    reg [24:0] count = 25'd0;

    always @(posedge clk) begin
        if (count == DIV - 1) begin
            count   <= 25'd0;
            clk_out <= ~clk_out;
        end else begin
            count <= count + 1'b1;
        end
    end
endmodule