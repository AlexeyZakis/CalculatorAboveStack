module test();
	reg clk, rst;
  
	reg [7:0] in;
	reg [3:0] op;
	reg apply;
  
	wire [7:0] head;
	wire empty;
	wire valid;
	
	initial clk = 0;
	always #1 clk = !clk;
	
	main _main(
		.clk(clk),
		.rst(rst),
		.in(in),
		.op(op),
		.apply(apply),
		.head(head),
		.empty(empty),
		.valid(valid)
	);
	
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(0, test);
		// Test: apply
		rst = 1;
		#1 rst = 0; apply = 0; // []
		#2 in = 0; op = 0; // in 0 | []
		
		#5
		
		// Test: valid
		#2 rst = 1; op = 1'bx; #2 rst = 0; apply = 1; in = 1; // valid = 1
		#2 op = 9; // valid = 0
		#2 rst = 1; op = 1'bx; #2 rst = 0; // valid = 1
		#2 op = 1; // valid = 0
		#2 rst = 1; op = 1'bx; #2 rst = 0; // valid = 1
		#2 op = 2; // valid = 0
		#2 rst = 1; op = 1'bx;  #2 rst = 0; // valid = 1
		#2 op = 3; // valid = 0
		#2 rst = 1; op = 1'bx; #2 rst = 0; // valid = 1
		#2 op = 4; // valid = 0
		#2 rst = 1; op = 1'bx; #2 rst = 0; #2 op = 0; // valid = 1
		#2 op = 4; // valid = 0
		#2 rst = 1; op = 1'bx; #2 rst = 0; #2 op = 0; // valid = 1
		#2 op = 5; // valid = 0
		#2 rst = 1; op = 1'bx; #2 rst = 0; #2 op = 0; // valid = 1
		#2 op = 6; // valid = 0
		#2 rst = 1; op = 1'bx;#2 rst = 0; #2 op = 0; // valid = 1
		#2 op = 7; // valid = 0
		#2 rst = 1; op = 1'bx; #2 rst = 0; #2 op = 0; // valid = 1
		#2 op = 8; // valid = 0
		#2 rst = 1; op = 1'bx; #2 rst = 0; #2 op = 0; // valid = 1
		#2 in = 0; op = 7; // valid = 0
		#2 rst = 1; op = 1'bx; #2 rst = 0; #2 op = 0; // valid = 1
		#2 in = 0; op = 8; // valid = 0
		
		#5
		
		// Test: in, op, head, empty
		// [] in[0] -[FF] +[0] pop[] in[5] in[5, 3] +[8] in[8, 3] -[5] in[5, 3] *[15] in[15, 2] /[7] in[7, 5] %[2]
		#1 rst = 1; op = 1'bx; #1 rst = 0; apply = 1; // []
		#2 in = 0; op = 0; // in 0 | [0]
		#2 op = 3; // 0 - 1 | [FF]
		#2 op = 2; // FF + 1 | [0]
		#2 op = 1; // pop | []
		#2 in = 5; op = 0; // in 5 | [5]
		#2 in = 3; op = 0; // in 3 | [5, 3]
		#2 op = 4; // 5 + 3 | [8]
		#2 in = 3; op = 0; // in 3 | [8, 3]
		#2 op = 6; // 8 - 3 | [5]
		#2 in = 3; op = 0; // in 3 | [5, 3]
		#2 op = 5; // 5 * 3 | [0F]
		#2 in = 2; op = 0; // in 2 | [0F, 2]
		#2 op = 7; // 15 // 2 | [7]
		#2 in = 5; op = 0; // in 5 | [7, 5]
		#2 op = 8; // 7 % 5 | [2]
		
		#2
		$finish;
	end
endmodule

