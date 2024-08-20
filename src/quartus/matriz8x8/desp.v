module desp(
	input clk,
	input dir,
	input reset_n,
	input enable,
	input [7:0] col,
	output reg [7:0] repl_col,
	output [63:0] out
);

	reg [63:0] pixels;
	reg [63:0] next_out1;
	
	initial begin
		pixels = 0;
		next_out1 = 0;
	end

	always @(posedge clk)
		if (!reset_n)
			pixels <= 0;
		else if (enable)
			pixels <= next_out1;

	always @* begin
		case (dir)
			0: begin//Desplazamiento hacia la derecha
				next_out1 = {{pixels[62:56], col[7]},
								{pixels[54:48], col[6]},
								{pixels[46:40], col[5]},
								{pixels[38:32], col[4]},
								{pixels[30:24], col[3]},
								{pixels[22:16], col[2]},
								{pixels[14:8],  col[1]},
								{pixels[6:0],   col[0]}};
				repl_col = {pixels[63], pixels[55], pixels[47], pixels[39], 
							   pixels[31], pixels[23], pixels[15], pixels[7]};
			end
         1: begin//Desplazamiento hacia la izquierda
				next_out1 = {{col[7], pixels[63:57]},
                        {col[6], pixels[55:49]},
                        {col[5], pixels[47:41]},
                        {col[4], pixels[39:33]},
                        {col[3], pixels[31:25]},
                        {col[2], pixels[23:17]},
                        {col[1], pixels[15:9]},
                        {col[0], pixels[7:1]}};
				repl_col = {pixels[56], pixels[48], pixels[40], pixels[32], 
							   pixels[24], pixels[16], pixels[8], pixels[0]};
			end
		endcase
	end
	
	assign out = pixels;

endmodule