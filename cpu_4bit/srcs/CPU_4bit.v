`default_nettype none

module CPU_4bit(
    input wire clk,
    input wire n_rst,

    output wire state,
    output wire halt,
    
    output wire [3:0] a_reg_q,
    output wire [3:0] b_reg_q,
    output wire [3:0] out_reg_q,

    input wire [3:0] in_d
);

//========================================
// Global Clock
//========================================
wire g_clk;
wire ld_en;
reg halt_reg;
assign g_clk = clk & halt_reg;

always @(posedge clk, negedge n_rst) begin
    if (!n_rst)
        halt_reg <= 1'b1;
    else if (n_halt == 1'b0 & ld_en == 1'b1)
        halt_reg <= 1'b0;
    else
        halt_reg <= halt_reg;
end


//=====================================
//A Register
//=====================================
wire [3:0] a_reg_d;
wire a_reg_ld;
REGISTER a_reg(
	.clk(g_clk),
	.n_rst(n_rst),
	.ld(a_reg_ld),
	.d(a_reg_d),
	.q(a_reg_q)
);

//=====================================
//B Register
//=====================================
wire [3:0] b_reg_d;
wire b_reg_ld;
REGISTER b_reg(
	.clk(g_clk),
	.n_rst(n_rst),
	.ld(b_reg_ld),
	.d(b_reg_d),
	.q(b_reg_q)
);

//=====================================
//OUT Register
//=====================================
wire [3:0] out_reg_d;
wire out_reg_ld;
REGISTER out_reg(
	.clk(g_clk),
	.n_rst(n_rst),
	.ld(out_reg_ld),
	.d(out_reg_d),
	.q(out_reg_q)
);

//=====================================
//Program Counter
//=====================================
wire [3:0] pc_d;
wire [3:0] pc_q;
wire pc_ld;
wire pc_up;
PC pc(
	.clk(g_clk),
	.n_rst(n_rst),
	.ld(pc_ld),
	.up(pc_up),
	.d(pc_d),
	.q(pc_q)
);

//=====================================
//ROM
//=====================================
wire [3:0] rom_data_h;
wire [3:0] rom_data_l;
ROM rom(
	.address(pc_q),
	.data_h(rom_data_h),
	.data_l(rom_data_l)
);

//=====================================
//ALU
//=====================================
wire [3:0] alu_b;
wire alu_as;
wire alu_ld;
wire alu_mux_a;
wire alu_mux_b;
wire [3:0] alu_q;
wire c;
wire z;
ALU alu(
	.clk(g_clk),
	.n_rst(n_rst),
	
	.a(a_reg_q),
	.b(alu_b),
	.as(alu_as),
	.ld(alu_ld),
	.mux_a(alu_mux_a),
	.mux_b(alu_mux_b),
	
	.q(alu_q),
	.c(c),
	.z(z)	
);

//=====================================
//State Machine
//=====================================
STATE_MACHINE state_machine(
	.clk(g_clk),
	.n_rst(n_rst),
	.pc_ld(pc_ld),
	.ld_en(ld_en),
	.pc_up(pc_up)
);

//=====================================
//Instruction Decoder
//=====================================
wire b_reg_oe;
wire alu_oe;
wire out_oe;
wire n_halt;
ID id(
	.d(rom_data_h),
	.ld_en(ld_en),
	.c(c),
	.z(z),
	
	.a_reg_ld(a_reg_ld),

	.b_reg_ld(b_reg_ld),
	.b_reg_oe(b_reg_oe),
	
	.alu_as(alu_as),
	.alu_oe(alu_oe),
	.alu_ld(alu_ld),
	.alu_mux_a(alu_mux_a),
	.alu_mux_b(alu_mux_b),
	
	.out_ld(out_reg_ld),
	
	.pc_ld(pc_ld),

	.n_halt(n_halt)
);

//=====================================
//State signal
//=====================================
assign state = pc_up;

//=====================================
//Halt signal
//=====================================
assign halt = ~halt_reg;

//=====================================
//Bus 1: ALU input B
//=====================================
assign alu_b = (b_reg_oe) ? b_reg_q : rom_data_l;

//=====================================
//Bus 2: ALU output
//=====================================
assign a_reg_d = (alu_oe) ? alu_q : in_d;
assign b_reg_d = (alu_oe) ? alu_q : in_d;
assign pc_d = (alu_oe) ? alu_q : in_d;
assign out_reg_d = (alu_oe) ? alu_q : in_d;

endmodule

`default_nettype wire


