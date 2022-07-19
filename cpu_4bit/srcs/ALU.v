`default_nettype none

module ALU(
    input wire clk,
    input wire n_rst,

    input wire [3:0] a,
    input wire [3:0] b,
    input wire as,
    input wire ld,
    input wire mux_a,
    input wire mux_b,

    output wire [3:0] q,
    output reg c,
    output reg z
);

//wire, register declaration
wire [3:0] wire_a;
wire [3:0] wire_b;
assign wire_a = mux ? a : 4'd0;
assign wire_b = mux ? b : 4'd0;

wire [4:0] result;
assign result = calc(wire_a, wire_b, as);
assign q = result[3:0];

// calculation
function [4:0] calc;
    input [3:0] a;
    input [3:0] b;
    input as;
    begin
        if(as == 1'b0) 
            calc = {1'b0,a} + {1'b0, b};
        else
            calc = {1'b0, a} + {1'b0, ~b} + 5'd1;
    end
endfunction

// update C flag and Z flag
always @(posedge clk, negedge n_rst) begin
    if (~n_rst) begin
        c <= 1'b0;
        z <= 1'b0;
    end
    else if (ld) begin
        c <= result[4];
        z <= ~|result[3:0];
    end
end
endmodule
`default_nettype none