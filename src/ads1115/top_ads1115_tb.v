`include "src/ads1115/top_ads1115.v"

`timescale 1ns / 1ps // time scale - temporal precision

module ssd1306_display_tb;

	reg clk;

	// Bidirs
	wire sda;
	wire scl;

	wire [15:0] read_bytesA0;

	top_ads1115 UUT_top_ads1115 (
		.clk(clk),
		.sda(sda), 
		.scl(scl),
		.read_bytesA0(read_bytesA0)
	);
	
	initial begin
		clk = 0;
		forever begin
			clk = #10 ~clk;
		end		
	end

	initial begin

		$dumpfile("top_ads1115_tb.vcd");
		$dumpvars(-1, UUT_top_ads1115);

		clk = 0;
				
		#10000000
		$finish;
		
	end

endmodule