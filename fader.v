module fader(
	input CLK,
	input SIG,
	output reg LED
);

reg[13:0] pre1;
reg[13:0] pre2;

always @(posedge CLK) begin
	if (SIG) begin
		pre1 <= 13'd7000;
		pre2 <= 13'd7000;
	end else begin
		if (pre1 == 0) begin
			if (pre2 != 0) begin
				pre1 <= 13'd7000;
				pre2 <= pre2 - 1'b1;
			end
		end else pre1 <= pre1 - 1'b1;
	end;
	LED <= (pre1 < pre2);
end

endmodule

module pulse(
	input CLK,
	output reg PULSE
);

reg[9:0] ctr;

always @(posedge CLK) begin
	if(ctr < 1000) begin
		ctr <= ctr + 1;
		PULSE <= ctr > 800;
	end else PULSE <= 0;
end

endmodule
