`default_nettype none

module REGISTER(
    input wire clk,
    input wire n_rst,
    input wire ld,
    input wire [3:0] d,

    output reg [3:0] q
);
    always @(posedge clk or negedge n_rst) begin
        if (~n_rst)       
            q <= 4'd0;
        else if (ld)
            q <= d;
    end
endmodule

`default_nettype none