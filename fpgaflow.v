module fpgaflow(
	input wire CLOCK_50,
	output wire LED
);

parameter pClkFreq = 50000000;	// clock frequency in MHz
parameter pBaud = 19200;
parameter pClkMul = (4096 * pBaud) / (pClkFreq / 65536);


reg [0:31] ctr = 32'd0;

assign LED = ctr[8];

always @(posedge CLOCK_50)
begin
	ctr = ctr + 1;//32'd1;
	if (ctr == 50000000)
		ctr = 0;
end



endmodule
