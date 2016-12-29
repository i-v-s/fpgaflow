module CamRam(
	input PCLK,
	input HREF,
	input VSYNC,
	input[7:0] PDATA,
	output reg[7:0] ODATA,
	output reg OREQ
	//input 
);

parameter pLineSize = 640;
parameter pLineCount = 8;

//reg[7:0] mem[pLineSize - 1:0][pLineCount - 1:0];
reg[9:0] x, y;
reg vsync;
reg[1:0] ctr;
reg[7:0] symbol;
reg[7:0] hi;
reg vs, hs, b;
reg[11:0] tmp;

always @(posedge PCLK) begin
	if (vsync) begin
		if (vs) begin
			symbol <= "+"; // Шлём начало кадра
			ctr <= 3;
			vs <= 0;
			y <= 0;
		end
	end else begin
		vs <= 1;
		if (HREF) begin
			if (x < pLineSize) begin
				if (b) begin
					if (x < 80 && y < 60) begin
					//if (x[2:0] == 0 && y[2:0] == 0) begin
						symbol <= (hi[7:3] + {hi[2:0], PDATA[7:5]} + PDATA[4:0]) << 1; // RGB
						//symbol <= tmp >> 2;//(tmp >> 2);
						tmp <= 0;
						ctr <= 1;
					end else tmp = tmp + (hi[7:3] + {hi[2:0], PDATA[7:5]} + PDATA[4:0]);
					x <= x + 1'b1;
				end else hi = PDATA;
			end;
			b <= ~b;
			hs <= 1;
		end else if(hs) begin
			/*if (y[2:0] == 0) begin
				symbol <= "-"; // Шлём начало строки
				ctr <= 1;
			end*/
			hs <= 0;
			x <= 0;
			y <= y + 1'b1;
			b <= 0;
		end
	end
	if (ctr > 0) begin
		OREQ <= 1'b1;
		ODATA <= symbol;
		ctr <= ctr - 1'b1;
	end else OREQ = 1'b0;
	vsync <= VSYNC;
end


endmodule
