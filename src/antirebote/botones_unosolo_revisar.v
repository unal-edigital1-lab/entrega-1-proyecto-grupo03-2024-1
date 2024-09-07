module Botones_antirebote(
	input clk,
    input btn_reset,
	input btn_test,
	input btn_action,
	input btn_cancel,
    input joys_left,
    input joys_right,
	// output reset_salida;
    // output test_salida;
    // output action_salida;
    // output cancel_salida;
    // output left_salida;
    // output rigth_salida; 
);


wire reset_salida;
wire test_salida;
wire action_salida;
wire cancel_salida;
wire left_salida;
wire rigth_salida; 

// 100000 ciclos de reloj, 0.002 creo, TODO mirar como sacar la salida, si con la funcion o llamando cada una de estas para usarlas abajo

antirebote_negado #(100000) Btnreset ( .clk(clk), .boton_in(btn_reset), .boton_out(reset_salida));  //btn_reset
antirebote_negado #(100000) Btntest ( .clk(clk), .boton_in(btn_test), .boton_out(test_salida));  //btn_reset
antirebote_negado #(100000) Btnaction ( .clk(clk), .boton_in(btn_action), .boton_out(action_salida));  //btn_reset
antirebote_negado #(100000) Btncancel ( .clk(clk), .boton_in(btn_cancel), .boton_out(cancel_salida));  //btn_reset
antirebote #(100000) Btnleft ( .clk(clk), .boton_in(btn_reset), .boton_out(left_salida));  //btn_reset
antirebote #(100000) Btnright ( .clk(clk), .boton_in(btn_reset), .boton_out(right_salida));  //btn_reset



endmodule