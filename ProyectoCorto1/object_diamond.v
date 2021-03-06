`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:49:19 03/28/2016 
// Design Name: 
// Module Name:    object_diamond 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module object_diamond(
    input [9:0] HCount,
    input [9:0] VCount,
	 input diamond_select,
	 input full_screen,
    output reg diamond_on
    );

///-------------Parametros del rombo------------//
localparam diamond_width = 200;
localparam diamond_height = 145;

reg [9:0] diamond_x_l, diamond_x_r;
reg [9:0] diamond_y_t, diamond_y_b;

assign diamond_sq = ((diamond_x_l <= HCount) && (HCount <= diamond_x_r) &&
							(diamond_y_t <= VCount) && (VCount <= diamond_y_b));

wire [7:0] diamond_addr;
wire [7:0] diamond_col;
wire [199:0] diamond_data;

//Memoria ROM que contiene mapa de bit del rombo
ROM_Diamond diamond (
	.addr(diamond_addr),
	.data(diamond_data)
	);
	
assign diamond_addr = VCount[9:0] - diamond_y_t[9:0];
assign diamond_col = HCount[9:0] - diamond_x_l[9:0];

assign diamond_bit = diamond_data[diamond_col];

//Sincronizacion de los registros y verificadores de variable
always @* begin
	if(diamond_select && full_screen) begin
		diamond_x_l <= 9'd214;
		diamond_y_t <= 9'd172;
		diamond_on <= diamond_sq & diamond_bit;
	end
	else if ( ~diamond_select && full_screen)
		diamond_on <= 1'b0;
	else begin
		diamond_x_l <= 9'd434;
		diamond_y_t <= 9'd172;
		diamond_on <= diamond_sq & diamond_bit;
	end
	diamond_x_r <= (diamond_x_l + diamond_width - 1);
	diamond_y_b <= (diamond_y_t + diamond_height - 1);
end

endmodule
