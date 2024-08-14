module wptrFull #(
    parameter ADDRSIZE = 4
) (
    output reg                  wfull,
    output reg  [ADDRSIZE:0]    wptr,
    output      [ADDRSIZE-1:0]  waddr,
    input       [ADDRSIZE:0]      wq2_rptr,
    input                       win,wclk,wrst_n
);
    reg [ADDRSIZE:0]    wbin;
    wire[ADDRSIZE:0]    wgnext,wbnext;

    always @(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) begin
            {wbin,wptr} <= '0;
        end else begin
            {wbin,wptr} <= {wbnext,wgnext};
        end
    end
    assign wbnext = wbin + (win & ~wfull);
    assign wgnext = (wbnext<<1) ^ wbnext;
    assign waddr = wbin[ADDRSIZE-1:0];

    assign wfull_flag = ((wgnext[ADDRSIZE]!=wq2_rptr[ADDRSIZE])&&
                         (wgnext[ADDRSIZE-1]!= wq2_rptr[ADDRSIZE-1])&&
                         (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
    always @(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) begin
            wfull <= 1'b0;
        end else begin
            wfull <= wfull_flag;
        end   
    end
    
endmodule