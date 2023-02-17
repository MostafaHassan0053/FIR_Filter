`timescale 1us/1ns 

module fir_filter_tb();
//tb signal 
reg clk_tb ;
reg reset_tb ;
reg buff_en_tb ;
reg fir_en_tb ;
reg [15:0] fir_data_tb ;
wire [31:0] fir_filtered_data_tb ;



fir_filter DUT (
.clk(clk_tb),
.reset(reset_tb),
.buff_en(buff_en_tb),
.fir_en(fir_en_tb),
.fir_data(fir_data_tb),
.fir_filtered_data(fir_filtered_data_tb)
);

//100kHZ(10us) 
always begin
        clk_tb = 1; #5;
        clk_tb = 0; #5;
    end


initial 
 begin
        reset_tb = 1; 
        buff_en_tb = 0 ;
        fir_en_tb = 0 ;
        #20;
        reset_tb = 0; 
        buff_en_tb = 0 ;
        fir_en_tb = 0 ;
        #50;
        reset_tb = 1; 
        buff_en_tb = 1;
        fir_en_tb = 1;
        #1000000;
        $stop ;
 end



reg [4:0] state_reg;
reg [3:0] counter;
    
parameter wvfm_period = 4'd10; //to generate 3.125kHZ signal
    
parameter IDLE          = 5'd0;
parameter state0        = 5'd1;
parameter state1        = 5'd2;
parameter state2        = 5'd3;
parameter state3        = 5'd4;
parameter state4        = 5'd5;
parameter state5        = 5'd6;
parameter state6        = 5'd7;
parameter state7        = 5'd8;
    
    /* This state machine generates a 3.125kHz sinusoid. */
   always @ (posedge clk_tb or posedge reset_tb)
        begin
            if (reset_tb == 1'b0)
                begin
                    counter <= 4'd0;
                    fir_data_tb <= 16'd0;
                    state_reg <= IDLE;
                end
            else
                begin
                    case (state_reg)
                        IDLE : //0
                            begin
                                counter <= 4'd0;
                                fir_data_tb <= 16'h0000;
                                state_reg <= state0;
                            end
                            
                        state0 : //1
                            begin
                                fir_data_tb <= 16'h0000;
                                
                                if (counter == wvfm_period)
                                    begin
                                        counter <= 4'd0;
                                        state_reg <= state1;
                                    end
                                else
                                    begin 
                                        counter <= counter + 1;
                                        state_reg <= state0;
                                    end
                            end 
                        
                        state1 : //2
                            begin
                                fir_data_tb <= 16'h5A7E; 
                                
                                if (counter == wvfm_period)
                                    begin
                                        counter <= 4'd0;
                                        state_reg <= state2;
                                    end
                                else
                                    begin 
                                        counter <= counter + 1;
                                        state_reg <= state1;
                                    end
                            end 
                        
                        state2 : //3
                            begin
                                fir_data_tb <= 16'h7FFF;
                                
                                if (counter == wvfm_period)
                                    begin
                                        counter <= 4'd0;
                                        state_reg <= state3;
                                    end
                                else
                                    begin 
                                        counter <= counter + 1;
                                        state_reg <= state2;
                                    end
                            end 
                        
                        state3 : //4
                            begin
                                fir_data_tb <= 16'h5A7E;
                                
                                if (counter == wvfm_period)
                                    begin
                                        counter <= 4'd0;
                                        state_reg <= state4;
                                    end
                                else
                                    begin 
                                        counter <= counter + 1;
                                        state_reg <= state3;
                                    end
                            end 
                        
                        state4 : //5
                            begin
                                fir_data_tb <= 16'h0000;
                                
                                if (counter == wvfm_period)
                                    begin
                                        counter <= 4'd0;
                                        state_reg <= state5;
                                    end
                                else
                                    begin 
                                        counter <= counter + 1;
                                        state_reg <= state4;
                                    end
                            end 
                        
                        state5 : //6
                            begin
                                fir_data_tb <= 16'hA582; 
                                
                                if (counter == wvfm_period)
                                    begin
                                        counter <= 4'd0;
                                        state_reg <= state6;
                                    end
                                else
                                    begin 
                                        counter <= counter + 1;
                                        state_reg <= state5;
                                    end
                            end 
                        
                        state6 : //6
                            begin
                                fir_data_tb <= 16'h8000; 
                                
                                if (counter == wvfm_period)
                                    begin
                                        counter <= 4'd0;
                                        state_reg <= state7;
                                    end
                                else
                                    begin 
                                        counter <= counter + 1;
                                        state_reg <= state6;
                                    end
                            end 
                        
                        state7 : //6
                            begin
                                fir_data_tb <= 16'hA582; 
                                
                                if (counter == wvfm_period)
                                    begin
                                        counter <= 4'd0;
                                        state_reg <= state0;
                                    end
                                else
                                    begin 
                                        counter <= counter + 1;
                                        state_reg <= state7;
                                    end
                            end                     
                    
                    endcase
                end
        end
       



endmodule
