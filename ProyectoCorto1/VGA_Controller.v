`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:28:07 03/15/2016 
// Design Name: 
// Module Name:    VGA_Controller 
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
module VGA_Controller(
    input clk,
    input rst,
	 input [1:0] inRGB,
    output reg HSync,
    output reg VSync,
    output [2:0] RGB,
	 output reg [9:0] HCount, VCount
    );

//Dimensiones de la pantalla
localparam H_size = 640;
localparam V_size = 480;

//Bordes de la pantalla
localparam H_Front = 48;
localparam H_Back = 16;
localparam V_Front = 10;
localparam V_Back = 33;

//Retrazos
localparam H_Retrace = 96;
localparam V_Retrace = 2;

//Parametros para la comparacion en los contadores
localparam HSR = (H_size + H_Back);
localparam HSBR = (H_size + H_Back + H_Retrace - 1);
localparam VSR = (V_size + V_Back);
localparam VSBR = (V_size + V_Back + V_Retrace - 1);

//Variables del contador
//reg [9:0] HCount, VCount;
reg [9:0] HCountNext, VCountNext;

//Parametros locales para la se�al de salida
reg [1:0] State, StateNext;

//Estados de la se�al
assign HEnd = (HCount == (H_size + H_Front + H_Back + H_Retrace - 1)); //Verifica contador Horizontal
assign VEnd = (VCount == (V_size + V_Front + V_Back + V_Retrace - 1));//Verifica contador Vertical

//Sincronizacion de se�ales
always @(posedge clk)
begin
	if(rst == 1)
	begin
		HCount <= 0;
		VCount <= 0;
	end
	else begin
		HCount <= HCountNext;
		VCount <= VCountNext;
	end
end

//Contadores vertical y horizontal
always @(*)
begin
	if(HEnd) HCountNext = 0;
	else HCountNext <= HCount + 1;
end
	
always @(*)
begin
	if(HEnd) begin
		if(VEnd) VCountNext = 0;
		else VCountNext <= VCount + 1;
	end
	else VCountNext <= VCount;
end

//Cambios de estado en la maquina
always @(State, HCount, VCount)
begin
	case(State)
		2'b00: 	if((HCount >= HSR && HCount <= HSBR) && (VCount < VSR || VCount > VSBR))
						StateNext = 2'b01;
					else if((HCount < HSR || HCount > HSBR) && (VCount >= VSR && VCount <= VSBR))
						StateNext = 2'b10;
					else if((HCount >= HSR && HCount <= HSBR) && (VCount >= VSR && VCount <= VSBR))
						StateNext = 2'b11;
					else StateNext = 2'b00;			
			
		2'b01: 	if((HCount >= HSR && HCount <= HSBR) && (VCount < VSR || VCount > VSBR))
						StateNext = 2'b01;
					else if((HCount < HSR || HCount > HSBR) && (VCount >= VSR && VCount <= VSBR))
						StateNext = 2'b10;
					else if((HCount >= HSR && HCount <= HSBR) && (VCount >= VSR && VCount <= VSBR))
						StateNext = 2'b11;
					else StateNext = 2'b00;	
			
		2'b10: 	if((HCount >= HSR && HCount <= HSBR) && (VCount < VSR || VCount > VSBR))
						StateNext = 2'b01;
					else if((HCount < HSR || HCount > HSBR) && (VCount >= VSR && VCount <= VSBR))
						StateNext = 2'b10;
					else if((HCount >= HSR && HCount <= HSBR) && (VCount >= VSR && VCount <= VSBR))
						StateNext = 2'b11;
					else StateNext = 2'b00;	
			
		2'b11:	if((HCount >= HSR && HCount <= HSBR) && (VCount < VSR || VCount > VSBR))
						StateNext = 2'b01;
					else if((HCount < HSR || HCount > HSBR) && (VCount >= VSR && VCount <= VSBR))
						StateNext = 2'b10;
					else if((HCount >= HSR && HCount <= HSBR) && (VCount >= VSR && VCount <= VSBR))
						StateNext = 2'b11;
					else StateNext = 2'b00;	
			
		default: StateNext = 2'b00;
	endcase
end

//
always @(negedge clk or posedge rst) begin
	if (rst == 1) State = 0;
	else begin State = StateNext; end
end

//Se�ales de salida
always @(State) begin
	if(State == 0) begin HSync = 0; VSync = 0; end
	else if(State == 1) begin HSync = 1; VSync = 0; end
	else if(State == 2) begin HSync = 0; VSync = 1; end
	else if(State == 3) begin HSync = 1; VSync = 1; end
end
	
//Asignacion de colores
assign RGB[0] = 1;
assign RGB[1] = inRGB[0];
assign RGB[2] = inRGB[1];

endmodule 