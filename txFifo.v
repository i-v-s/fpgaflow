module txFifo(
	input CLK,
	input [7:0] IN,
	input WE,  // Write enable
	input OR,  // Output ready
	output reg OE, // Output enable
	output wire FULL,
	output wire EMPTY,
	output reg[7:0] OUT
);

parameter pSize = 10;

reg [7:0] memory [1 << pSize:0];
reg [pSize - 1:0] src = 0;
reg [pSize - 1:0] dst = 0;
//assign OE = 0;

assign FULL = (dst + 1 == src);
assign EMPTY = (src == dst);
//wire full 

always @ (posedge CLK) begin
	if (WE && !FULL) begin
		memory[dst] <= IN;
		dst <= dst + 10'b1;
	end
	
	if (OR && !EMPTY) begin
		OUT <= memory[src];
		if (OE) OE = 0;
		else begin
			src <= src + 10'b1;
			OE = 1;
		end
	end

end

endmodule
