module top (
    input wire clk,
    output wire tx,
);
reg [7:0] data = 8'h62;

uart u(
    .clk(clk),
    .data(data),
    .tx(tx)
);
    
endmodule