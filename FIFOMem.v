module FIFOMem #(
    parameter DATASIZE = 8,
    parameter ADDRSIZE = 4
) (
    input   [DATASIZE-1: 0] wdata,
    output  [DATASIZE-1: 0] rdata,
    input   [ADDRSIZE-1: 0] waddr, raddr,
    input win,
    input wclk,
    input wfull
);

    localparam DEPTH = 1<<ADDRSIZE;
    reg [DATASIZE-1:0] mem [0:DEPTH-1];

    assign rdata = mem[raddr];

    always @(posedge wclk) begin
        if (win && !wfull) begin
            mem[waddr] <= wdata;
        end
    end
    
endmodule