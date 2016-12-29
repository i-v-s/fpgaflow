module presc(
	input IN,
	input EN,
	output reg OUT
);


parameter pIn = 50000000;	// clock frequency in MHz
parameter pOut = 19200;
parameter pTop = pIn / pOut - 1;
reg [23:0] cnt = pTop;	// current count

always @(posedge IN) begin
	if (EN) begin
		OUT <= (cnt > pTop / 2);
		if (cnt == 0) cnt = pTop;
		else cnt = cnt - 1;
	end else begin
		OUT <= 0;
		cnt <= pTop;
	end
end

endmodule
