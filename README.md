# Top level module

- ## AsyncFifo
    - Top level module for the asynchronous FIFO 
        - wdata[Size:0] 
            - Input stream of data
        - rdata[Size:0] 
            - Output stream of data
        - wfull 
            - Flag which indicates whether the FIFO is currently full. If this is high, the FIFO will not allow any further write operations until space is made.
        - rempty 
            - Flag which indicates whether the FIFO is currently empty. If this is high, the FIFO will not allow any further read operations until elements are added.
        - win 
            - Signal which instructs the FIFO to insert an element from the input stream into the FIFO memory. 
        - rout
            - Signal which instructs the FIFO to remove an element from the FIFO memory and insert it into the output stream.
        - wclk
            - Clock in the write domain (Generally, the clock with a lower period)
        - rclk
            - Clock in the read domain (Generally, the clock with a higher period)
        - wrst_n/rrst_n
            - Signal used to reset the FIFO, both of these are able to clear the FIFO and are intended to be asynchronously set. However, they are synchronously removed.

# 5 main sub-components:
- ## FIFOMem
    - As data is fed into the FIFO from the write clock domain, data needs to be stored somewhere so it can be read from the read clock domain. This module is responsible for that.
- ## rptrEmpty
    - This module is responsible for incrementing the read pointer using gray code and then determining whether or not the FIFO buffer is empty.
- ## wptrFull
    - This module is responsible for incrementing the write pointer using gray code and then determing whether or not the FIFO buffer is full.
- ## r2wSync
    - This module is responsible for synchronizing the position of the read pointer to the write clock domain.
- ## w2rSync
    - This module is responsible for synchronizing the position of the write pointer to the read clock domain.
