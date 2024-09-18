module sonido_btn_cancel(clk, btn_reset, sonido_btn_reset);
    input wire clk;
    input wire btn_cancel;         // Señal del botón
	output reg sonido_btn_cancel;  // Señal de salida al buzzer
	
    // ------------------------------------ FRECUENCIA DE SONIDO ------------------------------------
    reg [19:0] FA = 20'd0;
    localparam FA_frequency = 20'd35_793;
	
    // ------------------------------------ PROCESO CLK - SONIDO ------------------------------------

    always @(posedge clk) begin
        if (FA == FA_frequency) begin
            FA <= 0;  
        end else begin
            FA <= FA + 1;
        end
    end

    // ------------------------------------ PROCESO BTN_CANCEL - SONIDO ------------------------------------

    always @* begin
        if (btn_cancel == 1'b1) begin
            sonido_btn_cancel = FA[19];
        end else begin
            sonido_btn_cancel = 1'b0;
        end
    end
endmodule