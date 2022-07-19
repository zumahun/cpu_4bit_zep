`default_nettype none

module PC(
    input wire clk,
    input wire n_rst,
    input wire ld,
    input wire up,
    input wire [3:0] d,

    output [3:0] q
);

always @(posedge clk, negedge n_rst) begin
    if (~n_rst)
        q <= 4'd0;
    else if (ld)
        q <= d;
    else if (~ld & up)
        q <= q + 4'd1;
end
endmodule

`default_nettype none