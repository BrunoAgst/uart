module uart (
    input wire clk,
    input [7:0] data,
    output wire tx
);

parameter max_clk = 10000000;
parameter baud_rate = 9600;
parameter baud_max = (max_clk / baud_rate);
reg [15:0] baud_divider = 0;

wire baud_clock = baud_divider == baud_max;

always @(posedge clk) begin
    if(baud_clock) begin
        baud_divider <= 0;
    end else begin
        baud_divider <= baud_divider + 1;
    end
end

reg [3:0] state = 0;
reg [7:0] txData = data;
reg bitOut;
reg start = 1;
reg busy = 1;

always @(posedge clk) begin
    if(baud_clock) begin
        case(state)
            0: begin
                if(start && busy) begin
                    busy <= 0;
                    bitOut <= 0;
                    state <= 1;
                end
            end
            1: begin
                bitOut <= txData[0];
                state <= 2;
            end
            2: begin
                bitOut <= txData[1];
                state <= 3;
            end
            3: begin
                bitOut <= txData[2];
                state <= 4;
            end
            4: begin
                bitOut <= txData[3];
                state <= 5;
            end
            5: begin
                bitOut <= txData[4];
                state <= 6;
            end
            6: begin 
                bitOut <= txData[5];
                state <= 7;
            end
            7: begin 
                bitOut <= txData[6];
                state <= 8;
            end
            8: begin
                bitOut <= txData[7];
                state <= 9;
            end
            9: begin
                bitOut <= 1;
                state <= 10;
            end
            10: begin
                bitOut <= 1;
                state <= 0;
                busy <= 1;             
            end
            default: begin
                state <= 0; 
                busy <= 1;             
            end
        endcase
    end
end

assign tx = bitOut;

endmodule