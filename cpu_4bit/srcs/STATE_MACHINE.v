`default_nettype none
module STATE_MACHINE(
    input wire clk,
    input wire n_rst,
    input wire pc_ld,

    output wire ld_en,
    output wire pc_up
);

reg state;
always @(posedge clk, negedge n_rst) begin
    if (~n_rst)
        state <= 1'b0;
    else if (pc_ld)
        state <= 1'b0;
    else
        state <= ~state;
end

assign ld_en = ~state;
assign pc_up = state;
endmodule

`default_nettype none
