module uartTx(
	input CLK,
	input REQ,
	input [7:0] DATA,
	output TX,
	output READY
);

parameter pClk = 50000000;
parameter pBaud = 9600;
parameter pTop = pClk / pBaud - 1;
reg [23:0] prec = pTop;	// current count

reg [9:0] out = 10'b1;
reg [3:0] count;

assign READY = (count == 0);
assign TX = out[0] || READY;

always @(posedge CLK) begin
	if (REQ && READY) begin
		out <= {1'b1, DATA, 1'b0};
		count <= 4'd10;
		prec <= pTop;
	end else if (count) begin
		if (prec > 0) prec <= prec - 1;
		else begin
			prec <= pTop;
			count <= count - 1'b1;
			out <= {1'b1, out[9:1]};
		end
	end
end

endmodule

/*module uartTxTest(
	input CLK,
	input READY,
	output reg EN,
	output reg [7:0] DATA
);

//reg [7:0] msg [0:7] = "Hello";
reg [7:0] msgndx = 0;
//assign DATA = msg[msgndx];

always @(posedge CLK) begin
	if (READY) begin
		if (EN) begin
			EN <= 0;
			DATA = msgndx + 8'h30;
			//DATA = msg[msgndx];
			if (msgndx == 5) msgndx = 0;
			else msgndx = msgndx + 1;
		end else begin
			EN <= 1;
		end
	end
end
	
endmodule*/
