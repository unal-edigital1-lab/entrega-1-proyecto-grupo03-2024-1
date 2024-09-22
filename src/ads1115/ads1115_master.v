module ads1115_master (
    input clk,
    input [3:0] state,
    input [9:0] data_counter,
    output reg [6:0] addr_byte_in,
    output reg read_write,
    output reg [7:0] register_byte_in,
    output reg [7:0] data_byte_in,
    output reg continue_bit,
    output reg only_register
);

    // Co + D/C# + Control byte

    localparam IDLE = 4'd0;
    localparam START = 4'd1;
    localparam ADDRESS = 4'd2;
    localparam WRITE_REGISTER = 4'd3;
    localparam WRITE_DATA = 4'd4;
    localparam READ = 4'd5;
    localparam ACKNOWLEDGE = 4'd6;
    localparam RECOGNITION_ACK = 4'd7;
    localparam STOP = 4'd8;
    localparam DELAY = 4'd9;
    localparam SEND_READ_ACK = 4'd10;

    reg [7:0] pixels_oled [511:0];
    reg [4:0] block_sep = 0;

    initial begin
        addr_byte_in = 7'h48;
        read_write = 0;
        register_byte_in = 8'h01;
        data_byte_in = 8'hC1;
        continue_bit = 1;
        only_register = 0;
    end

    always @ (posedge clk) begin

        if (state == ACKNOWLEDGE || state == STOP) begin
            case (data_counter)

                // block 1

                8'd0: begin
                    addr_byte_in = 7'h48;
                    read_write = 0;
                    register_byte_in = 8'h01; //Config register
                    data_byte_in = 8'hC1;
                    continue_bit = 1;
                    only_register = 0;
                end

                8'd1: begin
                    addr_byte_in = 7'h48;
                    read_write = 0;
                    register_byte_in = 8'h01;
                    data_byte_in = 8'h80;
                    continue_bit = 0;
                    only_register = 0;
                end

                // block 2

                8'd2: begin
                    addr_byte_in = 7'h48;
                    read_write = 0;
                    register_byte_in = 8'h03; //Hi_thresh register
                    data_byte_in = 8'h80;
                    continue_bit = 1;
                    only_register = 0;
                end

                8'd3: begin
                    addr_byte_in = 7'h48;
                    read_write = 0;
                    register_byte_in = 8'h03;
                    data_byte_in = 8'h00;
                    continue_bit = 0;
                    only_register = 0;
                end

                // block 3

                8'd4: begin
                    addr_byte_in = 7'h48;
                    read_write = 0;
                    register_byte_in = 8'h02; //Lo_thresh register
                    data_byte_in = 8'h00;
                    continue_bit = 1;
                    only_register = 0;
                end

                8'd5: begin
                    addr_byte_in = 7'h48;
                    read_write = 0;
                    register_byte_in = 8'h02;
                    data_byte_in = 8'h00;
                    continue_bit = 0;
                    only_register = 0;
                end

                // block 4 - Config register (read)

                8'd6: begin
                    addr_byte_in = 7'h48;
                    read_write = 0;
                    register_byte_in = 8'h01;
                    data_byte_in = 8'h00;
                    continue_bit = 0;
                    only_register = 1;
                end

                // block 5

                8'd7: begin
                    addr_byte_in = 7'h48;
                    read_write = 1;
                    register_byte_in = 8'h01;
                    data_byte_in = 8'h00;
                    continue_bit = 0;
                    only_register = 0;
                end

                // block 6 - Conversion register (read)

                8'd8: begin
                    addr_byte_in = 7'h48;
                    read_write = 0;
                    register_byte_in = 8'h00;
                    data_byte_in = 8'h00;
                    continue_bit = 0;
                    only_register = 1;
                end

                // block 7

                8'd9: begin
                    addr_byte_in = 7'h48;
                    read_write = 1;
                    register_byte_in = 8'h00;
                    data_byte_in = 8'h00;
                    continue_bit = 0;
                    only_register = 0;
                end

            endcase
        end
    end

endmodule