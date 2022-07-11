// Code your testbench here
// or browse Examples
module t_uart_tx ;
  
  reg  tstart,tclk, trst, tclok;
  reg [7:0] tidata;
  reg [7:0] todata;
  reg t_received;
  wire ttx, ttx_done;
  initial #5000 $finish;
  reg [1:0] tsel= 2'd1;
  
  baud M3 ( tclok, tclk, trst, tsel);
  uart_tx M1 ( ttx, ttx_done, tclok, trst , tidata, tstart);
  receiver M2 ( tclok,trst,tstart, ttx, t_received,  todata);
  
  
  initial begin
    $dumpfile("dump.vcd");		  
    $dumpvars(0,M1);
    $dumpfile("reci.vcd");		  
    $dumpvars(0,M2);
    $dumpfile("baud.vcd");		  
    $dumpvars(0,M3);
    
    
    #0 trst=0;
    #15 trst=1;
  end
  initial begin
    tclk= 1'b0;
    
    repeat( 500) begin #5 tclk=~tclk ; end
  end
  
  initial begin
      #0 tstart=1'b1; 
     #0 tidata= 8'b 10000001;
    
  end
  
  initial 
    begin
      $monitor( $time,, " tx: %b", ttx);
    end
endmodule
    
    
    
    
    
