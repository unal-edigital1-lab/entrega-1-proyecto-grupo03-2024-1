module sonido_btn_reset(clk, btn_reset, sonido_btn_reset);
    input wire clk;
    input wire btn_reset;         // Señal del botón
	output reg sonido_btn_reset;  // Señal de salida al buzzer
	
    // ------------------------------------ FRECUENCIA DE SONIDO ------------------------------------
    reg [19:0] RE = 20'd0;
    localparam RE_frequency = 20'd42_566;
	
    // ------------------------------------ PROCESO CLK - SONIDO ------------------------------------

    always @(posedge clk) begin
        if (RE == RE_frequency) begin
            RE <= 0;  
        end else begin
            RE <= RE + 1;
        end
    end

    // ------------------------------------ PROCESO BTN_RESET - SONIDO ------------------------------------

    always @* begin
        if (btn_reset == 1'b1) begin
            sonido_btn_reset = DO[19];
        end else begin
            sonido_btn_reset = 1'b0;
        end
    end
endmodule