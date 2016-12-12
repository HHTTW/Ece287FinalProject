module contorl_model             
 (
 		input       CLK,                   				
 		input       RSTn,
		input       [7:0]Ps2DataIn,
		input       Done,
 		output      [9:0]X1, 	
		output      [9:0]X2,	
 		output      [9:0]Y1, 	
		output      [9:0]Y2,		
		output      [3:0]Num1,
		output      [3:0]Num2,
		output      Contorl
 );
 
 
reg [9:0]rX1;
reg [9:0]rX2;
reg [9:0]rY1;
reg [9:0]rY2;

reg [3:0]rNum1;
reg [3:0]rNum2;
 
 reg Flag;
 reg GoFlag;

 reg rContorl;
 
 
 reg LastDone;
 
  
	always @ ( posedge CLK ) //detect pulse on rising or falling edge
 begin
	if(RSTn==0) begin
		rX1 <= 'd74; 
		rX2 <= 'd230;
		rY1 <= 'd110;
		rY2 <= 'd110;
		rNum1 <= 'd0;
		rNum2 <= 'd0;
		rContorl <= 'd0;
		Flag <= 'd0;
		GoFlag <= 'd1;
	end
	else begin
	
		if((rX1+16>=260)&&(rContorl==0)) begin
			rX1 <= 'd74;
			rY1 <= 'd110;
			rX2 <= 'd230;
			rY2 <= 'd110;
			rNum1 <= rNum1 + 'd1;
			rContorl <= ~rContorl;
		end
		
		if((rX2<=60)&&(rContorl==1)) begin
			rX1 <= 'd74;
			rY1 <= 'd110;
			rX2 <= 'd230;
			rY2 <= 'd110;
			rNum2 <= rNum2 + 'd1;
			rContorl <= ~rContorl;
		end
		
		if( (rX1==rX2)&&(rY1==rY2)&&(Flag==0) ) begin				
						rContorl <= ~rContorl;
						Flag <= 'd1;
						rX1 <= 'd74;
						rY1 <= 'd110;
						rX2 <= 'd230;
						rY2 <= 'd110;
		end
		
		if((rX1!=rX2)||(rY1!=rY2)) begin
				Flag <= 'd0;
		end
		
		if(  ( ((rY1<50-16)||(rY1>190-16-5-8))&&(rContorl==0) ) || ( ((rY2<50-16)||(rY2>190-16-5-8))&&(rContorl==1) )  ) begin
						rX1 <= 'd74;
						rY1 <= 'd110;
						rX2 <= 'd230;
						rY2 <= 'd110;					
						rContorl <= ~rContorl;				
		end
		
		LastDone <= Done;
		if((Done==1)&&(LastDone==0)) begin
				case(Ps2DataIn)
					'h23: begin if((rX1<300)&&(GoFlag)) rX1<=rX1+2; end     		//A
					'h1c:	begin if((rX1>0)&&(GoFlag)) 	rX1<=rX1-2; end			//D
					'h1d: begin if((rY1>0)&&(GoFlag)) 	rY1<=rY1-2; end     		//W
					'h1b:	begin if((rY1<300)&&(GoFlag)) rY1<=rY1+2; end			//S					
					'h4b:	begin if((rX2<300)&&(GoFlag)) rX2<=rX2+2; end			//J
					'h3b:	begin if((rX2>0)&&(GoFlag)) 	rX2<=rX2-2; end			//L
					'h43: begin if((rY2>0)&&(GoFlag)) 	rY2<=rY2-2; end     		//I
					'h42:	begin if((rY2<300)&&(GoFlag)) rY2<=rY2+2; end			//K
					'h32:	begin GoFlag<=~GoFlag; end                            //B  
					'h3a:	begin                                                 //M
									rX1 <= 'd74; 
									rX2 <= 'd230;
									rY1 <= 'd110;
									rY2 <= 'd110;
									rNum1 <= 'd0;
									rNum2 <= 'd0;
									rContorl <= 'd0;
									Flag <= 'd0;
									GoFlag <= 'd1;
							end
				endcase
		end
		

/****************************/
	
		
	end
	
 end
          

assign X1 = rX1; 
assign X2 = rX2; 
assign Y1 = rY1; 
assign Y2 = rY2;  
assign Num1 = rNum1;
assign Num2 = rNum2;
assign Contorl = rContorl;

/****************************/  


endmodule 
