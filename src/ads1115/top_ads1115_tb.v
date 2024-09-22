`include "src/ads1115/top_ads1115.v"

`timescale 1ns / 1ps // time scale - temporal precision

module top_ads1115_tb;

	reg clk;
	reg sw;

	// Bidirs
	wire sda;
	wire scl;

	wire led1;
	wire led2;
	wire led3;
	wire led4;

	top_ads1115 UUT_top_ads1115 (
		.clk(clk),
		.sw(sw),
		.sda(sda), 
		.scl(scl),
		.led1(led1),
		.led2(led2),
		.led3(led3),
		.led4(led4)
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