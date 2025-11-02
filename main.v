module main(clk, rst, in, op, apply, head, empty, valid);
	input clk, rst;

	input [7:0] in;
	input [3:0] op;
	input apply;

	output reg [7:0] head;
	output empty;
	output reg valid;

  	parameter capacity = 5;

	reg [7:0] stack[0:capacity];

	reg [$clog2(capacity):0] size, next_size;
	wire is_full, size_less_then_1, size_less_then_2;
	reg next_valid, top_is_zero;

	// Операционный автомат
	always @*
		if (size > 0)
	    	head = stack[size - 1];
	    else head = 8'bx;

	always @(negedge clk, posedge rst)
	    if (rst) size <= 0;
	    else size <= next_size;

	always @* begin
		next_size = size;
	    if (apply && size < capacity && op == 0) next_size = size + 1;
	    else if (apply && size > 0 && (op == 1 || (op >= 4 && op <= 8))) next_size = size - 1;
	end

    always @(negedge clk) begin 
		if (apply) 
			case (op)
				4'd0: stack[size] <= in;
				4'd2: stack[size - 1] <= stack[size - 1] + 1;
				4'd3: stack[size - 1] <= stack[size - 1] - 1;
				4'd4: stack[size - 2] <= stack[size - 2] + stack[size - 1];
				4'd5: stack[size - 2] <= stack[size - 2] * stack[size - 1];
				4'd6: stack[size - 2] <= stack[size - 2] - stack[size - 1];
				4'd7: stack[size - 2] <= stack[size - 2] / stack[size - 1];
				4'd8: stack[size - 2] <= stack[size - 2] % stack[size - 1];
			endcase
    end

	// Свойства данных
	always @*
		if (size > 0)
	    	top_is_zero = stack[size - 1] == 0;
	    else top_is_zero = 0;

	assign is_full = size == capacity;

	assign size_less_then_1 = size < 1;

	assign size_less_then_2 = size < 2;

	// Управлящий автомат
	assign empty = size == 0;

	always @(posedge clk, posedge rst)
	    if (rst) valid <= 1;
	    else valid <= next_valid;

	always @* begin 
		if (valid && (
				(op < 0 || op > 8) || // Пункт 1
				(op >= 1 && op <= 3 && size_less_then_1) || // Пункт 2
				(op >= 4 && op <= 8 && size_less_then_2) || // Пункт 2
				(op == 0 && is_full) || // Пункт 3
				(op >= 7 && top_is_zero) // Пункт 4
			)) next_valid = 0;
		else next_valid = valid;
	end
endmodule

