module antirebote_boton_negado #(parameter COUNT_BOT=50000)(
	input clk,
	input boton_in,
	output reg boton_out
);

reg [$clog2(COUNT_BOT)-1:0] counter;

//
// Milesima de segundo count_bot
always @(posedge clk) begin
		if (boton_in==boton_out) begin
			counter <= counter+1;			
		end else begin
			counter<=0;			
		end
		if (boton_in==0 && counter==COUNT_BOT)begin
 // 			boton_out<=~boton_out;
	 			boton_out<=1;
				counter<=0;
				
		end
		if (boton_in==1 && counter==COUNT_BOT/100+1)begin
 // 			boton_out<=~boton_out;
	 			boton_out<=0;
				counter<=0;
				
		end
		
end	


endmodule
