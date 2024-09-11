module hcsr04 (
	input clk,
	input echo,
	input enable,
	output reg trigger,
	output reg level1,
	output reg level2,
	output reg level3
);
	
	reg [19:0] contTrigger;
	reg [19:0] contEcho;	
	parameter pulseTrigger = 20'd500000;

	always @(posedge clk) begin
		 if (contTrigger < pulseTrigger) begin
			  contTrigger <= contTrigger + 1;
			  trigger <= 1;
		 end else begin
			  contTrigger = 0;
			  trigger = 0;
		 end
	end
	
	always @(posedge clk) 
		begin
			if(echo == 1)
				begin
					contEcho = contEcho + 1;
				end
			else
				begin 
					contEcho = 0;
		end
	end

	parameter d1m = 20'd3000; // 1cm
	parameter d1 = 20'd30000; // 6cm
	
	parameter d2m = 20'd30000; // 6cm
	parameter d2 = 20'd60000;  // 12cm

	parameter d3 = 20'd60000; // 12cm 
 

	always @(posedge clk) 
		begin
		
			if (enable)
				begin
					level1 = 1;
					level2 = 1;
					level3 = 1;
				end
			else if (contEcho > d1m && contEcho < d1)
				begin
					level1 <= 0;
					level2 <= 1;
					level3 <= 1;  
				end
			else if (contEcho > d2m && contEcho < d2)
				begin
					level1 <= 1;
					level2 <= 0;
					level3 <= 1;  
				end
			else if (contEcho > d3)
				begin
					level1 <= 1;
					level2 <= 1;
					level3 <= 0;  
				end
	end
  
endmodule