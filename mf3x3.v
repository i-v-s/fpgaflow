module MF3X3(
	input CLK,  // Передача пикселя по клоку
	input ILINE, // Передача идёт
	input VSYNC, // Импульс между кадрами
	input[7:0] IDATA,
	output reg OLINE,
	output reg[7:0] ODATA
);

parameter pLineSize = 640;

reg[9:0] x, y;
reg[1:0] line;

reg[7:0] mem[pLineSize - 1:0][2:0];
reg[7:0] pts[8:0];
reg[7:0] col[2:0];

always @(posedge CLK) begin
	if (VSYNC) begin
		x <= 0;
		y <= 0;
		line <= 0;
		OLINE <= 0;
	end else if (ILINE) begin
		// Такт 0: запись
		mem[x][line] <= IDATA;
		x <= x + 1;
		
		/*// Чтение
		col[0] <= mem[x][0];
		col[1] <= mem[x][1];
		col[2] <= mem[x][2];
		// Сортировка столбца и сдвиг
		if (col[0] < col[1]) begin
			pts[2] = (col[0] < col[2]) ? col[0] : col[2];
			pts[5] = (col[1] ;
			pts[7] = (col[1] > col[2]) ? col[1] : col[2];
			
		end*/
			
		if (x > 0) begin
			pts[0] <= pts[1];
			pts[1] <= pts[2];
			pts[2] <= mem[x - 1][0];
			pts[3] <= pts[4];
			pts[4] <= pts[5];
			pts[5] <= mem[x - 1][1];
			pts[6] <= pts[7];
			pts[7] <= pts[8];
			pts[8] <= mem[x - 1][2];
		end
		if (x > 4) begin
			// Обработка
			OLINE <= 1;
			ODATA <= ((pts[0] + pts[1]) + ((pts[2] + pts[3]) + (pts[4] + pts[5])) + ((pts[6] + pts[7]) + pts[8])) >> 3;
		end else OLINE <= 0;
	end else begin
		if (x) begin
			y <= y + 1;
			line <= (line == 2) ? 0 : (line + 1);
		end
		x <= 0;
		OLINE <= 0;
	end;
end

endmodule
