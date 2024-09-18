module sonido_btn_test(clk, btn_reset, sonido_btn_reset);
    input wire clk;
    input wire btn_test;         // Señal del botón
	output reg sonido_btn_test;  // Señal de salida al buzzer
	
    // ------------------------------------ FRECUENCIA DE SONIDO ------------------------------------
    reg [19:0] MI = 20'd0;
    localparam MI_frequency = 20'd37_922;
	
    // ------------------------------------ PROCESO CLK - SONIDO ------------------------------------

    always @(posedge clk) begin
        if (MI == MI_frequency) begin
            MI <= 0;  
        end else begin
            MI <= MI + 1;
        end
    end

    // ------------------------------------ PROCESO BTN_TEST - SONIDO ------------------------------------

    always @* begin
        if (btn_test == 1'b1) begin
            sonido_btn_test = DO[19];
        end else begin
            sonido_btn_test = 1'b0;
        end
    end
endmodule