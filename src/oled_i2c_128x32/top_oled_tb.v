`include "src/oled_i2c_128x32/top_oled.v"

`timescale 1ns / 1ps // time scale - temporal precision

module ssd1306_display_tb;

	reg clk;

	// Bidirs
	wire sda;
	wire scl;

	top_oled UUT (
		.clk(clk),
		.sda(sda), 
		.scl(scl)
	);
	
	initial begin
		clk = 0;
		forever begin
			clk = #10 ~clk;
		end		
	end

	initial begin

		$dumpfile("top_tb.vcd");
		$dumpvars(-1, UUT);

		clk = 0;
				
		#100000000
		$finish;
		
	end

endmodule