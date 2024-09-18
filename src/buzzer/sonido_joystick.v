module sonido_bjoystick(clk, joystick, sonido_joystick);
    input wire clk;
    input wire joystick;         // Señal del botón
	output reg sonido_joystick;  // Señal de salida al buzzer
	
    // ------------------------------------ FRECUENCIA DE SONIDO ------------------------------------
    reg [19:0] SI = 20'd0;
    localparam SI_frequency = 20'd50_619;
	
    // ------------------------------------ PROCESO CLK - SONIDO ------------------------------------

    always @(posedge clk) begin
        if (SI == SI_frequency) begin
            SI <= 0;  
        end else begin
            SI <= SI + 1;
        end
    end

    // ------------------------------------ PROCESO JOYSTICK - SONIDO ------------------------------------

    always @* begin
        if (joystick == 1'b1) begin
            sonido_joystick = DO[19];
        end else begin
            sonido_joystick = 1'b0;
        end
    end
endmodule