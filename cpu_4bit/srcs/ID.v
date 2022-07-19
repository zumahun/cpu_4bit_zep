`default_nettype none
module ID(
    input wire [3:0] d,
    input wire ld_en,
    input wire c,
    input wire z,

    output wire a_reg_ld,

    output wire b_reg_ld,
    output wire b_reg_oe, //"ROM_OE" is "~B_REG_OE"

    output wire alu_as,
    output wire alu_oe, //"IN_OE" is "ALU_OE"
    output wire alu_ld,
    output wire alu_mux_a,
    output wire alu_mux_b,

    output wire out_ld,

    output wire pc_lc,

    output wire n_halt
);

//===================================================
//  A REG Load Enable
//==================================================
assign a_reg_ld = func_a_reg_ld(d, ld_en);
function func_a_reg_ld;
    input [3:0] d;
    input ld_en;
    begin
        casex(d)
            4'b00x0: func_a_reg_ld = ld_en;
            4'b01xx: func_a_reg_ld = ld_en;
            4'b1011: func_a_reg_ld = ld_en;
            default: func_a_reg_ld = 1'b0;
        endcase
    end
endfunction

//===================================================
//  B REG Load Enable
//==================================================
assign b_reg_ld = func_b_reg_ld(d, ld_en);
function func_b_reg_ld;
    input [3:0] d;
    input ld_en;
    begin
        casex(d)
            4'b0001: func_b_reg_ld = ld_en;
            4'b0011: func_b_reg_ld = ld_en;
            default: func_b_reg_ld = 1'b0;
        endcase
    end
endfunction

//===================================================
//  B REG Output Enable
//==================================================
assign b_reg_oe = func_b_reg_oe(d);
function func_b_reg_oe;
    input [3:0] d;
    begin
        casex(d)
            4'b001x: func_b_reg_oe = 1'b1;
            4'b010x: func_b_reg_oe = 1'b1;
            4'b100x: func_b_reg_oe = 1'b1;
            4'b1011: func_b_reg_oe = 1'b1;
            default: func_b_reg_oe = 1'b0;
        endcase
    end
endfunction

//===================================================
//  ALU ADD/SUB
//==================================================
assign alu_as = func_alu_as(d);
function func_alu_as;
    input [3:0] d;
    begin
        casex(d)
            4'b01x1: func_alu_as = 1'b1;
            default: func_alu_as = 1'b0;
        endcase
    end
endfunction

//===================================================
//  ALU Output Enable
//==================================================
assign alu_oe = (d == 4'b1011) ? 1'b0 : 1'b1;

//===================================================
//  ALU Load Enable
//==================================================
assign alu_ld = func_alu_ld(d, ld_en);
function func_alu_ld;
    input [3:0] d;
    input ld_en;
    begin
        casex(d)
            4'b01xx: func_alu_ld = ld_en;
            default: func_alu_ld = 1'b0;
        endcase
    end
endfunction

//===================================================
//  ALU Load Enable
//==================================================
assign alu_ld = func_alu_ld(d, ld_en);
function func_alu_ld;
    input [3:0] d;
    input ld_en;
    begin
        casex(d)
            4'b01xx: func_alu_ld =ld_en;
            default: func_alu_ld = 1'b0;
        endcase
    end
endfunction

//===================================================
//  ALU MUX A
//==================================================
assign alu_mux_a = func_alu_mux_a(d);
function func_alu_mux_a;
    input [3:0] d;
    begin
        casex(d)
            4'b0011: func_alu_mux_a = 1'b1;
            4'b01xx: func_alu_mux_a = 1'b1;
            4'b1000: func_alu_mux_a = 1'b1;
            default: func_alu_mux_a = 1'b0;
        endcase
    end
endfunction

//===================================================
//  ALU MUX B
//==================================================
assign alu_mux_b = func_alu_mux_b(d);
function func_alu_mux_b;
    input [3:0] d;
    begin
        casex(d)
            4'b0011: func_alu_mux_b = 1'b0;
            4'b1000: func_alu_mux_b = 1'b0;
            default: func_alu_mux_b = 1'b1;
        endcase
    end
endfunction

//===================================================
//  OUT REG Load Enable
//==================================================
assign out_ld = func_out_ld(d, ld_en);
function func_out_ld;
    input [3:0] d;
    input ld_en;
    begin
        casex(d)
            4'b100x: func_out_ld = ld_en;
            4'b1010: func_out_ld = ld_en;
            default: func_out_ld = 1'b0;
        endcase
    end
endfunction

//===================================================
//  Program Counter Load Enable
//==================================================
assign pc_ld = func_pc_ld(d, c, z);
function func_pc_ld;
    input [3:0] d;
    input c;
    input z;
    begin
        casex(d)
            4'b1100: func_pc_ld = 1'b1;
            4'b1101: func_pc_ld = ~c;
            4'b1110: func_pc_ld = ~z;
            default: func_pc_ld = 1'b0;
        endcase
    end
endfunction

//===================================================
//  HALT
//==================================================
assign n_halt = (d == 4'b1111) ? 1'b0 : 1'b1;

endmodule
`default_nettype none
