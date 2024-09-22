module buzzer (
    input wire clk,
    input wire LA, DO, MI, SOL, RE, FA, SI,
    output reg SONIDO
);  

    // Frequency counters
    reg [19:0] CONT = 20'd0;
    localparam [19:0] CONT_MAX = 17'd113636; // LA frequency

    reg [19:0] CONT1 = 20'd0;
    localparam [19:0] CONT_MAX1 = 20'd47_778; // DO frequency 10 octaves lower

    reg [19:0] CONT2 = 20'd0;
    localparam [19:0] CONT_MAX2 = 20'd37_922; // MI frequency

    reg [19:0] CONT3 = 20'd0;
    localparam [19:0] CONT_MAX3 = 17'd127551; // SOL frequency

    reg [19:0] CONT4 = 20'd0;
    localparam [19:0] CONT_MAX4 = 20'd42_566; // RE frequency

    reg [19:0] CONT5 = 20'd0;
    localparam [19:0] CONT_MAX5 = 20'd35_793; // FA frequency

    reg [19:0] CONT6 = 20'd0;
    localparam [19:0] CONT_MAX6 = 20'd50_619; // SI frequency
    

    // LA process
    always @(posedge clk) begin
        if (CONT == CONT_MAX) 
            CONT <= 0;
        else 
            CONT <= CONT + 1;
    end

    // DO process
    always @(posedge clk) begin
        if (CONT1 == CONT_MAX1) 
            CONT1 <= 0;
        else 
            CONT1 <= CONT1 + 1;
    end

    // MI process
    always @(posedge clk) begin
        if (CONT2 == CONT_MAX2) 
            CONT2 <= 0;
        else 
            CONT2 <= CONT2 + 1;
    end

    // SOL process
    always @(posedge clk) begin
        if (CONT3 == CONT_MAX3) 
            CONT3 <= 0;
        else 
            CONT3 <= CONT3 + 1;
    end

    // RE process
    always @(posedge clk) begin
        if (CONT4 == CONT_MAX4) 
            CONT4 <= 0;
        else 
            CONT4 <= CONT4 + 1;
    end

    // FA process
    always @(posedge clk) begin
        if (CONT5 == CONT_MAX5) 
            CONT5 <= 0;
        else 
            CONT5 <= CONT5 + 1;
    end

    // SI process
    always @(posedge clk) begin
        if (CONT6 == CONT_MAX6) 
            CONT6 <= 0;
        else 
            CONT6 <= CONT6 + 1;
    end
    
    // SONIDO process
    always @* begin
        if (LA == 1'b1) 
            SONIDO = CONT[19];
        else if (DO == 1'b1)
            SONIDO = CONT1[19];
        else if (MI == 1'b1)
            SONIDO = CONT2[19];
        else if (SOL == 1'b1)
            SONIDO = CONT3[19];
        else if (RE == 1'b1)
            SONIDO = CONT4[19];
        else if (FA == 1'b1)
            SONIDO = CONT5[19];
        else if (SI == 1'b1)
            SONIDO = CONT6[19];
        else 
            SONIDO = 1'b1;
    end

endmodule