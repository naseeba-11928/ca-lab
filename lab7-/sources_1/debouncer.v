// Push button debouncer: output only changes after the input has been
// stable for COUNT_MAX clock cycles (1,000,000 cycles = 10 ms at 100 MHz)
module debouncer #(
    parameter COUNT_MAX = 1000000
)(
    input  clk,
    input  pbin,
    output reg pbout = 1'b0
);
    // two-flop synchronizer for the asynchronous button input
    reg sync0 = 1'b0, sync1 = 1'b0;
    always @(posedge clk) begin
        sync0 <= pbin;
        sync1 <= sync0;
    end

    reg [19:0] count = 20'd0;

    always @(posedge clk) begin
        if (sync1 == pbout) begin
            count <= 20'd0;                  // input agrees with output, restart count
        end else begin
            count <= count + 1'b1;           // input differs, wait until stable
            if (count == COUNT_MAX - 1) begin
                pbout <= sync1;
                count <= 20'd0;
            end
        end
    end
endmodule


//module debouncer(
//    input clk,
//    input pbin,
//    output pbout
//    );
  
//    assign pbout = pbin;
//endmodule