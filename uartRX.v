module uartRx (
	input CLK,
	input RX,
	input EN,
	output reg [7:0] DATA,
	output reg DR,
	output reg ERR
);

parameter pClk = 50000000;
parameter pBaud = 9600;
parameter pTop = pClk / pBaud - 1;
reg [23:0] prec = pTop;	// current count
reg [3:0] count;
reg rx;

always @(posedge CLK) begin
	if (EN) begin
		ERR = ERR && !rx;
		if(!ERR) begin
			if (count == 0) begin // Пусто
				if (rx)
					prec <= pTop / 2;
				else begin // Ждём старт
					if (prec == 0) begin // Засекаем первый бит
						prec <= pTop;
						count = count + 1;
						DR <= 0;
						ERR <= 0;
					end else prec <= prec - 1;
				end
			end else begin 
				if (prec == 0) begin
					if (count == 9) begin // стоп бит
						ERR <= !rx;
						DR <= 1;
						count <= 0;
					end else begin				
						DATA <= {rx, DATA[7:1]};
						count = count + 4'b1;
					end
					prec <= pTop;
				end else prec <= prec - 1;
			end
		end
		rx <= RX;
	end else begin
		DR <= 0;
		ERR <= 0;
		DATA <= 0;
		count <= 0;
		rx <= 1;
	end
end

endmodule

//`timescale 1ns / 100ps
module uartRxTest;

reg rx, clk, en;
wire [7:0]data;
wire dr, err;

uartRx #(.pClk(200), .pBaud(40)) uartRx_inst(clk, rx, en, dr, err);

always
  #5 clk = ~clk;

initial
begin
  clk = 1;
  en = 0;
  rx = 1;
  #20 en = 1;
  #30 rx = 0; // Стартовый бит
  #50 rx = 1; // 0      01100001
  #50 rx = 0; // 1
  #200 rx = 1; // 5
  #100 rx = 0;
  #50 rx = 1; // Стоп бит
  
  #50 rx = 0; // Стартовый бит
  #50 rx = 0; // 0      10011110
  #50 rx = 1; // 1
  #200 rx = 0; // 5
  #100 rx = 1;
  #50 rx = 0; // Стоп бит  
  
  #150 rx = 1; // Отпустим линию
end

endmodule

