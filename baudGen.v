module baudGen(
	input RST,
	input CLOCK,
	output reg BAUD
);


parameter pClkFreq = 50000000;	// clock frequency in MHz
parameter pBaud = 19200;
parameter pTop = pClkFreq / pBaud;
reg [23:0] cnt = pTop;	// current count
//reg [23:0] ck_mul = pClkMul;	// baud rate clock multiplier
//assign BAUD = (cnt == 0);


always @(posedge CLOCK) begin
	if (RST || cnt == 0) begin
		//ck_mul <= pClkMul;
		cnt <= pTop;
		BAUD <= 1;
	end else begin
		BAUD <= 0;
		cnt <= cnt - 1;
	end
end



endmodule
