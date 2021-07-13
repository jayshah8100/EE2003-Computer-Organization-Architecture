module alu(
    input [31:0] in1,
    input [31:0] in2,
    input [5:0] op,
    output reg [31:0] out
    // output zero
    );

	 always @(*) begin

        case(op)
            // 18-26 are opcodes corresponding to immediate instr.
			18 : out <= in1 + in2;
            19 : out <= $signed(in1) < $signed(in2) ; //in all cases (slt, slti, etc) the result(1'b0/1'b1)
            20 : out <= in1 < in2;                    //will automatically be bit extended to 32 bits
			21 : out <= in1 ^ in2;
			22 : out <= in1 | in2;
			23 : out <= in1 & in2;
			24 : out <= in1 << in2[4:0];
			25 : out <= in1 >> in2[4:0];
			26 : out <= $signed(in1) >>> in2[4:0];
            // 27-36 are opcodes corresponding to reg-reg instr.
			27 : out <= in1 + in2;
			28 : out <= in1 - in2;
			29 : out <= in1 << in2[4:0];
			30 : out <= $signed(in1) < $signed(in2);
			31 : out <= in1 < in2;
			32 : out <= in1 ^ in2;
			33 : out <= in1 >> in2[4:0];
			34 : out <= $signed(in1) >>> in2[4:0];
			35 : out <= in1 | in2;
			36 : out <= in1 & in2;
			endcase
    end
	// assign zero = (out == 0);
	// always @(*) begin
	// 	case (alucon)
	// 		0 : out <= in1 + in2; //ADD
	// 		8 : out <= in1 - in2; //SUB
	// 		1 : out <= in1 << in2[4:0]; //SLL
	// 		2 : out <= {{31{1'b0}}, ($signed(in1) < $signed(in2))}; //SLT
	// 		3 : out <= {{31{1'b0}}, (in1 < in2)}; //SLTU
	// 		4 : out <= in1 ^ in2; //XOR
	// 		5 : out <= in1 >> in2[4:0]; //SRL
	// 		13 : out <= $signed(in1) >>> in2[4:0]; //SRA
	// 		6 : out <= in1 | in2; //OR
	// 		7 : out <= in1 & in2; //AND
	// 		default: out <= 32'h00000000;
	// 	endcase
	// 	end
endmodule