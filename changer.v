module changer(
	input CLOCK,
	output reg RESULT = 0
);

always @(posedge CLOCK) begin
	RESULT <= ~RESULT;
end

endmodule
