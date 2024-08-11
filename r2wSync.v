module r2wSync #(
    parameter ADDRSIZE = 4
) (
    output reg [ADDRSIZE:0]    wq2_rptr,
    input      [ADDRSIZE:0]    rptr,
    input wclk, wrst_n
);

    reg [ADDRSIZE:0] wq1_rptr;

    always @(posedge wclk) begin
        if(!wrst_n) begin
            {wq2_rptr,wq1_rptr} <= 0;
        end else begin
            {wq2_rptr,wq1_rptr} <= {wq1_rptr, rptr};
        end
        
    end
    
endmodule