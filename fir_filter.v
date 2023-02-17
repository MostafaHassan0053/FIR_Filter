`timescale 1us/1ns 
module fir_filter (
input wire clk ,
input wire reset ,
input wire buff_en ,
input wire fir_en ,
input wire signed [15:0] fir_data ,
output reg signed [31:0] fir_filtered_data 
);

//internal signals
wire count_done ;
wire signed [15:0] coeff0, coeff1,coeff2,coeff3,coeff4,coeff5,coeff6,coeff7,coeff8,coeff9,coeff10,coeff11,coeff12,coeff13,coeff14,coeff15 ;
reg [3:0] count ;
reg signed [15:0] in_sample ;
reg signed [15:0] buff0, buff1,buff2,buff3,buff4,buff5,buff6,buff7,buff8,buff9,buff10,buff11,buff12,buff13,buff14,buff15 ;
reg signed [31:0] mul0, mul1,mul2,mul3,mul4,mul5,mul6,mul7,mul8,mul9,mul10,mul11,mul12,mul13,mul14,mul15 ;

//FIR coefficient from matlab 
assign coeff0 = 16'h0000; //0
assign coeff1 = 16'hFFEB; //-0.00065399082724806868
assign coeff2 = 16'hFF03; //-0.0077440185392514379
assign coeff3 = 16'h0287; //0.0197663886569323
assign coeff4 = 16'h01FC; //0.015516939436430986 
assign coeff5 = 16'hF3C8; //-0.095469815606215772
assign coeff6 = 16'h0797; //0.059299165970796999
assign coeff7 = 16'h4130; //0.50928533090855499
assign coeff8 = 16'h4130; //0.50928533090855499
assign coeff9 = 16'h0797; //0.059299165970796999
assign coeff10 = 16'hF3C8; //-0.095469815606215772
assign coeff11 = 16'h01FC; //0.015516939436430986 
assign coeff12 = 16'h0287; //0.0197663886569323
assign coeff13 = 16'hFF03; //-0.0077440185392514379
assign coeff14 = 16'hFFEB; //-0.00065399082724806868
assign coeff15 = 16'h0000; //0
  



//buffering_stage   
always@(posedge clk or negedge reset)
begin
  if(!reset)
    begin
      in_sample <= 16'h0 ;
    end
  else if(buff_en)
    begin
      in_sample <= fir_data ;
    end
  else 
    begin
      in_sample <= in_sample ;
    end 
end      
      
      
  
//shifting_stage  
always@(posedge clk or negedge reset)
begin
  if(!reset)
    begin   
      buff0 <= 16'b0 ;
      buff1 <= 16'b0 ;
      buff2 <= 16'b0 ;
      buff3 <= 16'b0 ;
      buff4 <= 16'b0 ;
      buff5 <= 16'b0 ;
      buff6 <= 16'b0 ;
      buff7 <= 16'b0 ;
      buff8 <= 16'b0 ;
      buff9 <= 16'b0 ;
      buff10 <= 16'b0 ;
      buff11 <= 16'b0 ;
      buff12 <= 16'b0 ;
      buff13 <= 16'b0 ;
      buff14 <= 16'b0 ;
      buff15 <= 16'b0 ;
    end 
  else if(buff_en)
    begin 
      buff0 <= in_sample ;
      buff1 <= buff0 ;
      buff2 <= buff1 ;
      buff3 <= buff2 ;
      buff4 <= buff3 ;
      buff5 <= buff4 ;
      buff6 <= buff5 ;
      buff7 <= buff6 ;
      buff8 <= buff7 ;
      buff9 <= buff8 ;
      buff10 <= buff9 ;
      buff11 <= buff10 ;
      buff12 <= buff11 ;
      buff13 <= buff12 ;
      buff14 <= buff13 ;
      buff15 <= buff14 ;
    end
  else
    begin 
      buff0 <= buff0;
      buff1 <= buff1 ;
      buff2 <= buff2 ;
      buff3 <= buff3 ;
      buff4 <= buff4 ;
      buff5 <= buff5 ;
      buff6 <= buff6 ;
      buff7 <= buff7 ;
      buff8 <= buff8 ;
      buff9 <= buff9 ;
      buff10 <= buff10 ;
      buff11 <= buff11 ;
      buff12 <= buff12 ;
      buff13 <= buff13 ;
      buff14 <= buff14 ;
      buff15 <= buff15 ;
    end
end 


//multiplication_stage
always@(posedge clk or negedge reset)
begin
  if(!reset)
    begin   
      mul0 <= 32'b0 ;
      mul1 <= 32'b0 ;
      mul2 <= 32'b0 ;
      mul3 <= 32'b0 ;
      mul4 <= 32'b0 ;
      mul5 <= 32'b0 ;
      mul6 <= 32'b0 ;
      mul7 <= 32'b0 ;
      mul8 <= 32'b0 ;
      mul9 <= 32'b0 ;
      mul10 <= 32'b0 ;
      mul11 <= 32'b0 ;
      mul12 <= 32'b0 ;
      mul13 <= 32'b0 ;
      mul14 <= 32'b0 ;
      mul15 <= 32'b0 ;
    end 
  else if(fir_en)
    begin 
      mul0 <= coeff0 * buff0 ;
      mul1 <= coeff1 * buff1  ;
      mul2 <= coeff2 * buff2  ;
      mul3 <= coeff3 * buff3 ;
      mul4 <= coeff4 * buff4  ;
      mul5 <= coeff5 * buff5 ;
      mul6 <= coeff6 * buff6  ;
      mul7 <= coeff7 * buff7  ;
      mul8 <= coeff8 * buff8  ;
      mul9 <= coeff9 * buff9  ;
      mul10 <= coeff10 * buff10  ;
      mul11 <= coeff11 * buff11 ;
      mul12 <= coeff12 * buff12  ;
      mul13 <= coeff13 * buff13  ;
      mul14 <= coeff14 * buff14 ;
      mul15 <= coeff15 * buff15 ;
    end
  end 

//adding_stage 
always@(posedge clk or negedge reset)
begin
  if(!reset)
    begin
      fir_filtered_data <= 32'b0;
    end 
  else if(fir_en)
    begin
      fir_filtered_data <= mul0 + mul1 + mul2 + mul3 + mul4 + mul5 + mul6 + mul7 + mul8 + mul9 + mul10 + mul11 + mul12 + mul13 + mul14 + mul15 ;
    end 
end 
  

endmodule 
      