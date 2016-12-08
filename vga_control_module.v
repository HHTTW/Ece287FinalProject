module vga_control_module
(
  input CLK,
  input RSTn,
  input [9:0]X1,
  input [9:0]X2,
  input [9:0]Y1,
  input [9:0]Y2,
  input [3:0]Num1,
  input [3:0]Num2,
  input  Contorl,
  input  [7:0]ZiKu,
  output [7:0]R,
  output [7:0]G,
  output [7:0]B,
  output HSYNC,
  output VSYNC,
  output VGA_CLK,
  output VGA_BLANK_N,
  output VGA_SYNC_N,
  output [9:0]Addr

 );
 

 /*************VGA-REG*******************/
 reg [9:0]a;
 reg [9:0]b;
 reg [9:0]c;
 reg [9:0]d;
 reg [9:0]o;
 reg [9:0]p;
 reg [9:0]q;
 reg [9:0]r;
 /**************************************/

 reg [7:0]rR;
 reg [7:0]rG;
 reg [7:0]rB;
 reg [11:0]C1;
 reg [11:0]C2;
 reg rH,rV;
 reg [11:0]xpos;
 reg [11:0]ypos;
 reg [9:0]rAddr;
 
 reg [9:0]BallWeiZhi;
 
 reg [7:0]FootBall;
 
 reg [15:0]dispNumA0;
 reg [15:0]dispNumA1;
 reg [15:0]dispNumA2;
 reg [15:0]dispNumA3;
 reg [15:0]dispNumA4;
 reg [15:0]dispNumA5;
 reg [15:0]dispNumA6;
 reg [15:0]dispNumA7;
 
 reg [15:0]dispNumB0;
 reg [15:0]dispNumB1;
 reg [15:0]dispNumB2;
 reg [15:0]dispNumB3;
 reg [15:0]dispNumB4;
 reg [15:0]dispNumB5;
 reg [15:0]dispNumB6;
 reg [15:0]dispNumB7;
 
 
  reg rVGA_BLANK_N;
   reg rVGA_SYNC_N;
	
   reg CLK_25M;
	
 always @ ( posedge CLK )
 begin
	CLK_25M <= ~CLK_25M;
end 
 
 /******************************************************/ 
 always @ ( posedge CLK_25M or negedge RSTn )
 if( !RSTn ) begin
			rR <= 'd0;
			rG <= 'd0;
			rB <= 'd0;
	C1 <= 'd0;
	C2 <= 'd0;
	rH <= 1'b1;
	rV <= 1'b1;
	
/*****800X600*******/
/*	a <= 'd128; 
	b <= 'd88; 
	c <= 'd800; 
	d <= 'd40; 
	o <= 'd4; 
	p <= 'd23; 
	q <= 'd600; 
	r <= 'd1; */
/*******************/	

/*****640X480*******/
	a <= 'd96; 
	b <= 'd48; 
	c <= 'd640; 
	d <= 'd16; 
	o <= 'd2; 
	p <= 'd33; 
	q <= 'd480; 
	r <= 'd10; 
/*******************/
	
 end
 else begin	
 
		if(Contorl==0) BallWeiZhi<=Y1;
		else           BallWeiZhi<=Y2;
 
	 	case (ypos-(BallWeiZhi+18))
				'd0 : FootBall <= 8'h18; 
				'd1 : FootBall <= 8'h24; 
				'd2 : FootBall <= 8'h5A;
				'd3 : FootBall <= 8'hA5; 
				'd4 : FootBall <= 8'hA5; 
				'd5 : FootBall <= 8'h5A; 
				'd6 : FootBall <= 8'h24; 
				'd7 : FootBall <= 8'h18;
		endcase 

	/******************************************************/ 
	if( ((C1 > (a + b)) && (C1 <= (a + b + c)) ) && ( (C2 > (o + p)) && (C2 <= (o + p + q) )) ) begin
			if((xpos>=110)&&(xpos<=110+8)&&(ypos>=20)&&(ypos<=20+16)) begin
					rAddr =(ypos-20)+ (Num1*16);
					if(ZiKu[(xpos-110)]) begin
							rR<='d255; rG<='d0; rB<='d0;
					end 
					else begin
							rR<='d0; rG<='d0; rB<='d0;
					end		
			end
			else if((xpos>=204)&&(xpos<=204+8)&&(ypos>=20)&&(ypos<=20+16)) begin
					rAddr =(ypos-20)+ (Num2*16);
					if(ZiKu[(xpos-204)]) begin
							rR<='d255; rG<='d0; rB<='d255;
					end 
					else begin
							rR<='d0; rG<='d0; rB<='d0;
					end		
			end
			else if((xpos>=X1)&&(xpos<=X1+16)&&(ypos>=Y1)&&(ypos<=Y1+16)) begin
						rR<='d255; rG<='d0; rB<='d0;
			end
			else if((xpos>=X2)&&(xpos<=X2+16)&&(ypos>=Y2)&&(ypos<=Y2+16)) begin
						rR<='d255; rG<='d0; rB<='d255;
			end
			else if((xpos>=X1+4)&&(xpos<X1+12)&&(ypos>=Y1+18)&&(ypos<Y1+26)&&(Contorl==0)) begin
						if(FootBall[xpos-(X1+4)]) begin rR<='d0; rG<='d0; rB<='d0; end
						else begin rR<='d0; rG<='d255; rB<='d0; end
			end
			else if((xpos>=X2+4)&&(xpos<X2+12)&&(ypos>=Y2+18)&&(ypos<Y2+26)&&(Contorl==1)) begin
						if(FootBall[xpos-(X2+4)]) begin rR<='d0; rG<='d0; rB<='d0; end
						else begin rR<='d0; rG<='d255; rB<='d0; end			
			end
			else if((xpos>=60)&&(xpos<=260)&&(ypos>=50)&&(ypos<=190)) begin		
						if((  ((xpos>=65)&&(xpos<=158))||((xpos>=162)&&(xpos<=255))  )&&(ypos>=55)&&(ypos<=185)) begin
								rR<='d0; rG<='d255; rB<='d0;
						end
						else begin
								rR<='d255; rG<='d255; rB<='d255;
						end
			end
			else begin
					rR<='d0; rG<='d0; rB<='d0;
			end
	end
	else begin 
		rR<='d0; rG<='d0; rB<='d0;
	end
	
	xpos <= (C1 - 'd144)/2;
	ypos <= (C2 - 'd35)/2;
	
	/******************************************************/ 	
	if( C1 == (a+b+c+d) ) rH <= 1'b0;
	else if( C1 == a ) rH <= 1'b1;

	if( C2 == (o+p+q+r) ) rV <= 1'b0;
	else if( C2 == o ) rV <= 1'b1;

	if( C2 == (o+p+q+r) ) C2 <= 10'd1;
	else if( C1 == (a+b+c+d) ) C2 <= C2 + 1'b1;

	if( C1 == (a+b+c+d) ) C1 <= 11'd1;
	else 
	C1 <= C1 + 1'b1;
	/******************************************************/
	
		
 end

 
 /****************************/

 assign R = rR;
 assign G = rG;
 assign B = rB;
 assign HSYNC = rH;
 assign VSYNC = rV;
 assign VGA_CLK = CLK_25M;
 assign VGA_BLANK_N = rH && rV;
 assign VGA_SYNC_N = 'd0;
 assign Addr = rAddr;

 /*****************************/
 endmodule