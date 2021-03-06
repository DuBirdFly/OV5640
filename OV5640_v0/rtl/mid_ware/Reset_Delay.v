module	Reset_Delay(iCLK,iRST,oRST_0,oRST_1,oRST_2,oRST_3);
input		iCLK;
input		iRST;
output reg	oRST_0;
output reg	oRST_1;
output reg	oRST_2;
output reg	oRST_3;

reg	[21:0]	Cont;

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST) begin
		Cont	<=	0;
		oRST_0	<=	0;
		oRST_1	<=	0;
		oRST_2	<=	0;
		oRST_3	<=	0;		
	end
	else begin
		if(Cont!=22'h3FFFFF)
		Cont	<=	Cont+1;
		if(Cont>=22'h1FFFFF)
		oRST_0	<=	1;
		if(Cont>=22'h2FFFFF) begin
			oRST_1	<=	1;
			oRST_2	<=	1;
		end
		if(Cont>=22'h3FFFFF) 
		oRST_3	<=	1;		
	end
end

endmodule