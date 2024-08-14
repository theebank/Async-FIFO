module rptrEmpty #(
    parameter ADDRSIZE = 4
) (
    output reg rempty,
    output reg  [ADDRSIZE:0]    rptr,
    output      [ADDRSIZE-1:0]  raddr,
    input       [ADDRSIZE:0]    rq2_wptr,
    input                       rout, rclk, rrst_n
);
    reg [ADDRSIZE:0]    rbin;
    wire [ADDRSIZE:0]    rgnext, rbnext;

    always @(posedge rclk or negedge rrst_n) begin
        if(!rrst_n) begin
            {rbin,rptr} <= '0;
        end else begin
            {rbin,rptr} <= {rbnext, rgnext};
        end
    end
    assign rbnext = rbin +(rout&~rempty);
    assign rgnext = (rbnext>>1) ^ rbnext;
    assign raddr = rbin[ADDRSIZE-1:0];

    assign rempty_flag = (rgnext==rq2_wptr);
    always @(posedge rclk or negedge rrst_n) begin
        if(!rrst_n) begin
            rempty <= 1'b1;
        end else begin
            rempty <= rempty_flag;
        end
    end

    
endmodule