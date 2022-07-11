// Code your design here
module  uart_tx ( tx, tx_done, clok, rst, idata, start);
  
  output reg tx;
  output reg tx_done= 1'b0;
  input clok, rst;
  input  start;
  input [7:0] idata;
  
  parameter  idle= 3'b000 , s_start=3'd1, s_busy= 3'd2, s_stop=3'd3;
  
  reg[2:0] state, nstate;
  reg [7:0] data= 8'd0 ;
  reg [3:0] bitpos= 4'd0;
  initial begin
    tx= 1'b1;
  end
  
  
   reg clk;
  reg [1:0] sel= 2'd1;
  
  always@( posedge clok, negedge rst) 
   begin
     if( ~rst) begin state<= idle; end
     else begin state<=nstate; end
   end
     
     
  always@ (state, posedge clok)
       begin 
         case (state) 
            idle: begin  tx=1'b1;
                         data =idata;
              if (start ) begin nstate<=s_start; end 
              else begin nstate<= idle; end
                      end
             
            s_start:
               
               begin 
                 nstate<= s_busy;
                 tx=1'b0;
                 
               end
               
            s_busy:
                     begin 
                       if( bitpos== 8'd7)
                         begin nstate<= s_stop;
                            tx<=  data[ bitpos] ;
                           tx_done= 1'b1;
                           
                         end
                       else 
                         begin
                           tx<=  data[ bitpos] ;
                           bitpos <= bitpos + 8'h1;
                            nstate<= s_busy;
                         end
                     end
                 
           s_stop:
                   
                       begin 
                           tx<= 1'd0;
                         
                       end
                   
             default : begin tx=1'b1; nstate<= idle; end
                    
                   
           endcase
          end
             
             
             
             endmodule

/////
module receiver 
  ( 
     input clk,
    input rrst,
    input start,
     input i_serial,
    output reg received,
    output reg [7:0] out_data
  );
  parameter  idle= 3'b000 , s_start=3'd1, s_busy= 3'd2, s_stop=3'd3;
  reg[2:0] state, nstate;
  reg [7:0] pdata= 8'd0 ;
  reg [3:0] bitpos= 4'd0;
 
  
  always@( posedge clk , negedge rrst) 
   begin
     if( ~rrst) begin state<= idle; end
     else begin state<=nstate; end
   end
     
  
  always@ (state,posedge clk)
     begin 
         case (state) 
            idle: begin  
              if (start) begin nstate<=s_start; end 
              else begin nstate<= idle; end
                      end
             
            s_start:
               begin 
                 nstate<= s_busy;
               end
               
            s_busy:
                     begin 
                       if( bitpos== 8'd7)
                         begin 
                            #1 pdata[ bitpos]<= i_serial;
                            out_data <= pdata;
                           nstate<= s_stop;
                          
                         end
                       else 
                         begin
                           #1 pdata[ bitpos]<= i_serial;
                           bitpos <= bitpos + 8'h1;
                            nstate<= s_busy;
                         end
                     end
                 
           s_stop: begin received<=1'b1; end
                   
                       
                   
             default : begin  nstate<= idle; end
                    
                   
           endcase
     end
endmodule

module baud ( clkout, clk, reset, sel);
  
  output reg clkout;
  input clk;
  input reset;
  input [1:0] sel;
  reg [12:0] rate= 12'b0;
  reg [12:0] count;
 always@(sel)begin
    case( sel)
      2'd0:  rate=12'd1;
      2'd1:  rate=12'd 5;
      2'd2:  rate=12'd3;
      2'd3:  rate=12'd4;
      default: rate=12'd1;
      
    endcase
  end
  
  always@ ( posedge clk, negedge reset)
    begin 
      if( ~reset) begin
                           clkout<= 12'b0;
                            count<= 12'b0 ;
      end
      else if( count==rate) begin
        						count<=12'd1;
        						clkout<= ~clkout;
      end
      else begin
          
        count= count+1'b1;
        clkout<=clkout;
      end
    end
  
endmodule
  

     
  
                     
                     
                     
                   
                           
               
                 
                      
  
  
  
