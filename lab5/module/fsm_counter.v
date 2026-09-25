module fsm_counter #(
    parameter WIDTH = 16
)(
    input  wire             clk,
    input  wire             rst,         
    input  wire             tick,        // one-cycle pulse, paces countdown
    input  wire [WIDTH-1:0] sw_val,
    output wire [WIDTH-1:0] counter_out,
    output wire             state_out    // 0 = idle, 1 = counting
);

    localparam S_IDLE  = 1'b0;
    localparam S_COUNT = 1'b1;

    reg             state;
    reg [WIDTH-1:0] counter;

    always @(posedge clk) begin
        if (rst) begin
            state   <= S_IDLE;
            counter <= {WIDTH{1'b0}};
        end else begin
            case (state)
                S_IDLE: begin
                    if (sw_val != {WIDTH{1'b0}}) begin
                        counter <= sw_val;   // Capture initial switch value
                        state   <= S_COUNT;
                    end else begin
                        counter <= {WIDTH{1'b0}};
                    end
                end

                S_COUNT: begin
                    if (tick) begin
                        if (counter > 1'b1) begin
                            counter <= counter - 1'b1;
                        end else begin
                            // Reached 0, return to IDLE
                            counter <= {WIDTH{1'b0}};
                            state   <= S_IDLE;
                        end
                    end
                end

                default: begin
                    state   <= S_IDLE;
                    counter <= {WIDTH{1'b0}};
                end
            endcase
        end
    end

    assign counter_out = counter;
    assign state_out   = state;

endmodule

