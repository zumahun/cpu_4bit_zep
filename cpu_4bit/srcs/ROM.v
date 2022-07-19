`default_nettype none

module ROM(
    input wire [3:0] address,

    output wire [3:0] data_h,
    output wire [3:0] data_l
);

wire [7:0] data;
assign data = rom_data(address);
assign data_h = data[7:4];
assign data_l = data[3:0];

function [7:0] rom_data;
    input [3:0] address;
    begin
        case(address)
            4'b0000: rom_data = 8'b0000_0001;   //LD A, 0001
            4'b0001: rom_data = 8'b1000_0000;   // OUT A
            4'b0010: rom_data = 8'b0110_0010;   // ADD A, 0010
            4'b0011: rom_data = 8'b1000_0000;   // OUT A

            4'b0100: rom_data = 8'b0110_0011; // ADD A, 0011
            4'b0101: rom_data = 8'b1000_0000; // OUT A
            4'b0110: rom_data = 8'b0110_0100: // ADD A, 0100
            4'b0111: rom_data = 8'b1000_0000; // OUT A

            4'b1000: rom_data = 8'b0110_0101; // ADD A, 0101
            4'b1001: rom_data = 8'b1000_0000; // OUT A
            4'b1010: rom_data = 8'b0000_0000; // LD A, 0000 (NOP)
            4'b1011: rom_data = 8'b0000_0000; // LD A, 0000 (NOP)

            4'b1100: rom_data = 8'b0000_0000; // LD A, 0000 (NOP)
            4'b1101: rom_data = 8'b0000_0000; // LD A, 0000 (NOP)
            4'b1110: rom_data = 8'b0000_0000; // LD A, 0000 (NOP)
            4'b1111: rom_data = 8'b1010_0000; // OUT 0000
            default: rom_data = 8'b0000_0000;
        endcase
    end
endfunction

endmodule
`default_nettype none