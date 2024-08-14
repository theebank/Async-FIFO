`include "AsyncFIFO.v"

module AsyncFIFO_tb;
    parameter DSIZE = 8;
    parameter ASIZE = 4;

    reg [DSIZE-1:0]     wdata;
    wire [DSIZE-1:0]    rdata;
    wire wfull, rempty;
    reg win, wclk,wrst_n;
    reg rout, rclk, rrst_n;

    reg [DSIZE-1:0] data_out[$];
    reg [DSIZE-1:0] data_in;

    AsyncFIFO uut (
        .wdata(wdata),
        .rdata(rdata),
        .wfull(wfull),
        .wempty(wempty),
        .win(win),
        .wclk(wclk),
        .wrst_n(wrst_n),
        .rout(rout),
        .rclk(rclk),
        .rrst_n(rrst_n)
    );

    initial begin
        wclk = 1'b0;
        rclk = 1'b0;
        forever #5 wclk = ~wclk;
        forever #25 rclk = ~rclk;
    end

    initial begin
        winc = 1'b0;
        wdata = '0;
        wrst_n = 1'b0;
        repeat(5)@(posedge wclk);
        wrst_n = 1'b1;
        for(int iter = 0;iter<2;iter++)begin
            for(int i = 0;i<32;i++) begin
                @(posedge wclk iff !wfull);
                winc = (i%2==0)? 1'b1 : 1'b0;
                if (winc) begin
                    wdata = $urandom;
                    data_out.push_front(wdata);
                end
            end
            #1us;
        end
    end

    initial begin
    rinc = 1'b0;

    rrst_n = 1'b0;
    repeat(8) @(posedge rclk);
    rrst_n = 1'b1;

    for (int iter=0; iter<2; iter++) begin
      for (int i=0; i<32; i++) begin
        @(posedge rclk iff !rempty)
        rinc = (i%2 == 0)? 1'b1 : 1'b0;
        if (rinc) begin
          data_in = data_out.pop_back();
          // Check the rdata against modeled wdata
          $display("Checking rdata: expected wdata = %h, rdata = %h", data_in, rdata);
          assert(rdata === data_in) else $error("Checking failed: expected wdata = %h, rdata = %h", data_in, rdata);
        end
      end
      #1us;
    end

    $finish;
  end



endmodule