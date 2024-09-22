`include "src/ultrasonido/top_hcsr04.v"

`timescale 1ns / 1ps // time scale - temporal precision

module hcsr04_tb;

	reg clk;
    reg echo;
    reg enable;
    wire trigger;
	wire level1 = 1;
	wire level2 = 1;

    top_hcsr04 UUT (
        .clk(clk),
        .echo(echo),
        .enable(enable),
        .trigger(trigger),
        .level1(level1),
        .level2(level2)
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
        echo = 1;

        #9999990
        echo = 1;

        #10
        echo = 0;

        #100000
        echo = 1;
				
		#70000000
		$finish;
		
	end

endmodule