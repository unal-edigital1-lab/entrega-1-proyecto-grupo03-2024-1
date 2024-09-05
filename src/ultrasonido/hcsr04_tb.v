`include "src/ultrasonido/hcsr04.v"

`timescale 1ns / 1ps // time scale - temporal precision

module hcsr04_tb;

	reg clk;
    reg echo;
    reg enable;
    wire trigger;
	wire level1 = 1;
	wire level2 = 1;
	wire level3 = 1;

    hcsr04 UUT (
        .clk(clk),
        .echo(echo),
        .enable(enable),
        .trigger(trigger),
        .level1(level1),
        .level2(level2),
        .level3(level3)
    );
	
	initial begin
		clk = 0;
		forever begin
			clk = #10 ~clk;
		end		
	end

	initial begin

		$dumpfile("hcsr04.vcd");
		$dumpvars(-1, UUT);

		clk = 0;
        echo = 0;

        #10000
        echo = 1;
        #70000
        echo = 0;
				
		#100000000
		$finish;
		
	end

endmodule