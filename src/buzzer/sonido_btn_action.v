module sonido_btn_action(clk, btn_action, sonido_btn_action);
    input wire clk;
    input wire btn_action;         // Señal del botón
	output reg sonido_btn_action;  // Señal de salida al buzzer
	
    // ------------------------------------ FRECUENCIA DE SONIDO ------------------------------------
    reg [19:0] DO = 20'd0;
    localparam DO_frequency = 20'd47_778;
	
    // ------------------------------------ PROCESO CLK - SONIDO ------------------------------------

    always @(posedge clk) begin
        if (DO == DO_frequency) begin
            DO <= 0;  
        end else begin
            DO <= DO + 1;
        end
    end

    // ------------------------------------ PROCESO BTN_ACTION - SONIDO ------------------------------------

    always @* begin
        if (btn_action == 1'b1) begin
            sonido_btn_action = DO[19];
        end else begin
            sonido_btn_action = 1'b0;
        end
    end
endmodule
