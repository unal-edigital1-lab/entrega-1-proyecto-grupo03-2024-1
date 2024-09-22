`timescale 1ns / 1ps

module i2c_ads1115 (
    input clk,
    input [6:0] addr_byte_in,
    input read_write,
    input [7:0] register_byte_in,
    input [7:0] data_byte_in,
    input continue_bit,
    inout scl,
    inout sda,
    input only_register,
    output reg [3:0] state = 0,
    output reg [9:0] data_counter = 0,
    output reg [15:0] read_bytesA0 = 16'h0000
);

    wire clk_pulse;
    reg [6:0] timer = 0;

    always @ (posedge clk) begin
        if (timer > 7'd100)
            timer <= 7'd0;
        else
            timer <= timer + 1'b1;
    end

    assign clk_pulse = (timer == 100) ? 1'b1 : 1'b0;

    reg wdata_context = 0;
    reg read_register = 0;
    reg [3:0] next_state = 0;

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

    localparam n_instructions = 10;

    wire scl_out_en;
    wire sda_out_en; 

    assign scl_out_en = (state != IDLE);
    //assign sda_out_en = (state != READ);
    assign sda_out_en = (state != READ && state != ACKNOWLEDGE && state != RECOGNITION_ACK);

    reg scl_value = 1;
    reg sda_value = 1;

    assign scl = scl_out_en ? scl_value : 1'bz;    
    assign sda = sda_out_en ? sda_value : 1'bz;

    reg [7:0] addr_byte_out = 0;
    reg [7:0] register_byte_out = 0;
    reg [7:0] data_byte_out = 0;

    reg ack = 0;
    reg [1:0] bus_timing = 0;
    reg [4:0] bit_counter;

    reg [15:0] read_bytes = 16'h0000;
    reg band = 0;

    always @ (posedge clk) begin
        if(clk_pulse) begin
            case(state)
                IDLE: begin
                    scl_value <= 1;
                    sda_value <= 1;

                    bit_counter <= 8;
                    bus_timing <= 0;
                    state <= START;
                end

                START: begin
                    case (bus_timing)
                        0: begin
                            sda_value <= 0;
                            bit_counter <= 8;
                            bus_timing <= 1;
                        end
                        1: begin
                            bus_timing <= 2;
                        end
                        2: begin
                            scl_value <= 0;
                            bus_timing <= 3;
                        end
                        3: begin
                            addr_byte_out <= {addr_byte_in, read_write};
                            register_byte_out <= register_byte_in;
                            data_byte_out <= data_byte_in;
                            bus_timing <= 0;
                            state <= ADDRESS;
                        end
                    endcase
                end

                ADDRESS: begin
                    case (bus_timing)
                        0: begin
                            sda_value <= addr_byte_out[bit_counter - 1'b1];
                            bus_timing <= 1;
                        end
                        1: begin
                            scl_value <= 1;
                            bus_timing <= 2;
                        end
                        2: begin
                            scl_value <= 0;
                            bit_counter <= bit_counter - 1'b1;
                            bus_timing <= 3;
                        end
                        3: begin
                            if (bit_counter == 0) begin
                                case (sda_value)
                                    0: begin
                                        bit_counter <= 8;
                                        bus_timing <= 0;

                                        state <= RECOGNITION_ACK;
                                        next_state <= WRITE_REGISTER;
                                    end
                                    1: begin
                                        bit_counter <= 16;
                                        bus_timing <= 0;

                                        state <= RECOGNITION_ACK;
                                        next_state <= READ;
                                    end
                                endcase
                            end
                            else begin
                                bus_timing <= 0;
                            end
                        end
                    endcase
                end

                RECOGNITION_ACK: begin
                    case (bus_timing)
                        0: begin  
                            bus_timing <= 1;
                        end
                        1: begin
                            scl_value <= 1;
                            if (sda == 1) begin
                                ack <= 0; // nack if high
                                bus_timing <= 2;
                            end
                            else if (sda == 0) begin
                                ack <= 1; // ack if low
                                bus_timing <= 2;
                            end
                        end
                        2: begin
                            scl_value <= 0;
                            bus_timing <= 3;
                        end
                        3: begin
                            if (ack) begin
                                ack <= 0;
                                bus_timing <= 0;
                                state <= DELAY;
                            end
                            else begin
                                bus_timing <= 0;
                                state <= STOP; // <= IDLE
                            end
									 
									 if(data_counter==0)begin
											bus_timing <= 0;
											data_counter <= 1;
                                state <= STOP; // <= IDLE
									 end
									 
                        end
                    endcase
                end

                WRITE_REGISTER: begin
                    case (bus_timing)
                        0: begin
                            sda_value <= register_byte_out[bit_counter - 1'b1];
                            bus_timing <= 1;
                        end
                        1: begin
                            scl_value <= 1;
                            bus_timing <= 2;
                        end
                        2: begin
                            scl_value <= 0;
                            bit_counter <= bit_counter - 1'b1;
                            bus_timing <= 3;
                        end
                        3: begin
                            if (bit_counter == 0) begin
                                bit_counter <= 8;
                                bus_timing <= 0;

                                if (only_register) begin
                                    wdata_context <= 1;
                                    next_state <= STOP;
                                    state <= ACKNOWLEDGE;
                                end
                                else begin
                                    next_state <= WRITE_DATA;
                                    state <= ACKNOWLEDGE;
                                end
                            end
                            else begin
                                bus_timing <= 0;
                            end
                        end
                    endcase
                end

                WRITE_DATA: begin
                    case (bus_timing)
                        0: begin
                            sda_value <= data_byte_out[bit_counter - 1'b1];
                            bus_timing <= 1;
                        end
                        1: begin
                            scl_value <= 1;
                            bus_timing <= 2;
                        end
                        2: begin
                            scl_value <= 0;
                            bit_counter <= bit_counter - 1'b1;
                            bus_timing <= 3;
                        end
                        3: begin
                            if (bit_counter == 0) begin

                                wdata_context <= 1;
                                bit_counter <= 8;
                                bus_timing <= 0;

                                case (continue_bit)
                                    0: begin
                                        next_state <= STOP;
                                        state <= ACKNOWLEDGE;
                                    end
                                    1: begin
                                        next_state <= WRITE_DATA;
                                        state <= ACKNOWLEDGE;
                                    end
                                endcase
                            end
                            else begin
                                bus_timing <= 0;
                            end
                        end
                    endcase
                end

                READ: begin
                    case (bus_timing)
                        0: begin  
                            bus_timing <= 1;
                        end
                        1: begin
                            scl_value <= 1;
                            read_bytes[bit_counter - 1'b1] <= sda;
                            bus_timing <= 2;
                        end
                        2: begin
                            scl_value <= 0;
                            bus_timing <= 3;
                            bit_counter <= bit_counter - 1'b1;
                        end
                        3: begin
                            if (bit_counter == 8) begin
                                bus_timing <= 0;
                                //state <= DELAY;
                                //next_state <= READ;
                                state <= SEND_READ_ACK;
                                next_state <= DELAY;
                            end
                            else if (bit_counter == 0) begin
                                bus_timing <= 0;

                                if (data_counter != 10) begin
                                    if (read_bytes == 16'hC180) begin
                                        read_register = 1;
                                    end
                                    else begin
                                        read_register = 0;
                                    end
                                end
                                else begin
                                    read_bytesA0 = read_bytes;
                                    read_register = 1;
                                end

                                next_state <= STOP;
                                state <= SEND_READ_ACK;
                            end
                            else begin
                                bus_timing <= 0;
                            end
                        end
                    endcase
                end

                SEND_READ_ACK: begin
                    case (bus_timing)
                        0: begin
								
									//if (read_register == 0 && bit_counter == 0) begin
                            //    sda_value = 1;
                            //end
                            //else begin
                            //    sda_value = 0;
                            //end
										
                            sda_value = 0;
                            bus_timing <= 1;
                        end
                        1: begin
                            scl_value <= 1;
                            bus_timing <= 2;
                        end
                        2: begin
                            scl_value <= 0;
                            bus_timing <= 3;
                        end
                        3: begin
                            if (bit_counter == 8) begin
                                state <= next_state;
                                next_state <= READ;
                            end
                            else begin
                                state <= next_state;
                                bit_counter <= 8;
                                case (read_register)
                                    0: begin
                                        data_counter <= data_counter - 1'b1;
                                    end
                                    1: begin
                                        read_register <= 0;
                                        if (data_counter == n_instructions) begin
                                            data_counter <= 0;
                                        end else begin
                                            data_counter <= data_counter + 1'b1;
                                        end
                                    end
                                endcase

                            end
                            bus_timing <= 0;
                        end
                    endcase
                end

                ACKNOWLEDGE: begin
                    case (bus_timing)
                    0: begin
                        bus_timing <= 1;
                    end
                    1: begin
                        scl_value <= 1;
                        if (sda == 1) begin
                            ack <= 0; // nack if high
                            bus_timing <= 2;
                        end
                        else if (sda == 0) begin
                            ack <= 1; // ack if low
                            bus_timing <= 2;

                            if (wdata_context) begin
                                if (data_counter == n_instructions) begin
                                    wdata_context <= 0;
                                    data_counter <= 0;
                                end else begin
                                    wdata_context <= 0;
                                    data_counter <= data_counter + 1'b1;
                                end
                            end
                        end

                    end
                    2: begin
                        scl_value <= 0;
                        bus_timing <= 3;
                    end
                    3: begin
                        if (ack) begin
                            ack <= 0;
                            bus_timing <= 0;
                            state <= DELAY;

                            addr_byte_out <= {addr_byte_in, read_write};
                            register_byte_out <= register_byte_in;
                            data_byte_out <= data_byte_in;
                        end
                        else begin
                            bus_timing <= 0;
                            next_state <= STOP; // <= IDLE
                            state <= DELAY;
                        end
                    end
                    endcase
                end

                DELAY: begin
                    case (bus_timing)
                        0: begin
                            scl_value <= 0;
                            sda_value <= 0;
                            bus_timing <= 1;
                        end
                        1: begin
                            bus_timing <= 2;
                        end
                        2: begin
                            bus_timing <= 3;
                        end
                        3: begin
                            bus_timing <= 0;
                            state <= next_state;
                        end
                    endcase
                end

                STOP: begin
                    case (bus_timing)
                        0: begin
                            scl_value <= 1;
                            bus_timing <= 1;
                        end
                        1: begin
                            if (scl == 1)
                                bus_timing <= 2;
                            else
                                bus_timing <= 1;
                        end
                        2: begin
                            sda_value <= 1;
                            bus_timing <= 3;
                        end
                        3: begin
                            bus_timing <= 0;
                            state <= IDLE;
                        end
                    endcase
                end

            endcase
        end
    end

endmodule