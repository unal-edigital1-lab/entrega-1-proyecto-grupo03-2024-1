module hcsr04 (
	input clk,
	input echo,
	input enable,
	output reg trigger,
	output reg level1,
	output reg level2
);
	
	reg [19:0] contTrigger;
	reg [19:0] contEcho;	
	parameter PULSE_TRIGGER = 20'd500000;
	
	parameter DM = 20'd3000;	
	parameter D = 20'd30000;

	always @(posedge clk) begin
		 if (contTrigger < PULSE_TRIGGER) begin
			  contTrigger <= contTrigger + 1;
			  trigger <= 1;
		 end else begin
			  contTrigger = 0;
			  trigger = 0;
		 end
	end
	
	always @(posedge clk) 
		begin
			if(echo == 1) begin
				contEcho <= contEcho + 1;
				if (contEcho > D) begin
					level1 <= 1;
					level2 <= 0;
				end
			end
			else begin
				if (!enable) begin
					level1 = 1;
					level2 = 1;
					end
				else if (contEcho > DM && contEcho < D) begin
					level1 <= 0;
					level2 <= 1;
					end
				else if (contEcho > D) begin
					level1 <= 1;
					level2 <= 0;
				end
				contEcho <= 0;
		end
	end

  
endmodule