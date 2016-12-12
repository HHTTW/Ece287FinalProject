module PS2(clk,ps_clk,ps_data,dataout,Done);
input clk,ps_clk,ps_data;
output [7:0] dataout;
output Done;

reg [3:0] num; //PS_CLK clock counter
	reg [10:0] data_buffer; //receive data buffer
reg [7:0] data_reg1,data_reg2,data_reg3,result;
reg isDone;
reg LastPs2_CLK;
reg CntEn;
reg LastCntEn;
reg En;
reg [15:0]Cnt;
reg [39:0]rstCnt;
reg [39:0]GoFlag;
/************************************/
always @(posedge ps_clk)
 begin 	
	CntEn <= ~CntEn;
 end
 
always @(posedge clk)
 begin 	
 
	LastCntEn <= CntEn;
	if(LastCntEn==CntEn) begin end
	else begin
		En <= 'd1;
	end
	
	if(En) begin
			rstCnt <= 'd0;
			if(ps_clk) Cnt <= Cnt + 'd1;
			else begin Cnt<='d0; En<='d0; end
			if(Cnt>1100) begin
				Cnt <= 'd0;
				En <= 'd0;
				if(ps_clk) begin	
					if(num>=4'd10) num<=4'd0; 
					else num<=num+4'd1;	
				end
			end 	
	end
	else begin
		rstCnt <= rstCnt + 'd1;
		if(rstCnt>100000) begin
			num<=4'd0;
			rstCnt <= 'd0;
		end
	end
	
 end 
 
/**************Reading data from the falling edge***********************/
always @(negedge ps_clk)
   begin
     data_buffer[num]<=ps_data;
  end
/**********Judge whether buttons released******************/
always @(posedge ps_clk)
  begin 

    case (num)
      4'd9:data_reg1<=data_buffer[8:1];
      4'd10:
			begin
			   if(data_reg1=='hf0) begin
					result<='hff;
					GoFlag <= 'd1;
			   end
			   else begin
					if(GoFlag==0) begin
							isDone <= 'd1;
							result <= data_reg1;
					end 
					else begin
						GoFlag <= 'd0;	
					end
			   end
			end
			
    endcase

	if(isDone) isDone<='d0;
    
  end
assign dataout=result;
assign Done=isDone;


endmodule
