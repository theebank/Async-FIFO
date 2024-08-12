`include "r2wSync.v"
`include "w2rSync.v"
`include "FIFOMem.v"
`include "rptrEmpty.v"
`include "wptrFull.v"


module AsyncFIFO #(
    parameter DSIZE =8,
    parameter ASIZE = 4
) (
    input   [DSIZE-1:0]       wdata,
    output  [DSIZE-1:0]       rdata,
    output  wfull, rempty,
    input   winc, wclk, wrst_n,
    input   rinc, rclk, rrst_n
);
    wire [ASIZE-1:0]  waddr, raddr;
    wire [ASIZE:0] wptr,rptr,wq2_rptr,rq2_wptr;

    r2wSync     r2wSync (.wq2_rptr(wq2_rptr),
                        .rptr(rptr),
                        .wclk(wclk),
                        .wrst_n(wrst_n));
    
    w2rSync     w2rSync (.rq2_wptr(rq2_wptr),
                        .wptr(wptr),
                        .rclk(rclk),
                        .rrst_n(rrst_n));

    FIFOMem #(DSIZE,ASIZE)  FIFOMem(.wdata(wdata),
                                    .rdata(rdata),
                                    .waddr(waddr),
                                    .raddr(raddr),
                                    .wclken(winc),
                                    .wfull(wfull),
                                    .wclk(wclk));
    
    rptrEmpty #(ASIZE)      rptrEmpty(.rempty(rempty),
                                    .rptr(rptr),
                                    .raddr(raddr),
                                    .rq2_wptr(rq2_wptr),
                                    .rinc(rinc),
                                    .rclk(rclk),
                                    .rrst_n(rrst_n));
    
    wptrFull    #(ASIZE)    wptrFull(.wfull(wfull),
                                    .wptr(wptr),
                                    .waddr(waddr),
                                    .wq2_rptr(wq2_rptr),
                                    .winc(winc),
                                    .wclk(wclk),
                                    .wrst_n(wrst_n));
endmodule