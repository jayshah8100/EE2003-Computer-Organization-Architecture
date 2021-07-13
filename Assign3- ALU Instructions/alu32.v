module alu32(
    input [5:0] op,      // some input encoding of your choice
    input [31:0] rv1,    // First operand
    input [31:0] rv2,    // Second operand
    output reg [31:0] rvout  // Output value
);
    
    always @(rv1 or rv2 or op) begin

        case(op)
            // 18-26 are opcodes corresponding to immediate instr.
			18 : rvout <= rv1 + rv2;
            19 : rvout <= $signed(rv1) < $signed(rv2) ; //in all cases (slt, slti, etc) the result(1'b0/1'b1)
            20 : rvout <= rv1 < rv2;                    //will automatically be bit extended to 32 bits
			21 : rvout <= rv1 ^ rv2;
			22 : rvout <= rv1 | rv2;
			23 : rvout <= rv1 & rv2;
			24 : rvout <= rv1 << rv2[4:0];
			25 : rvout <= rv1 >> rv2[4:0];
			26 : rvout <= $signed(rv1) >>> rv2[4:0];
            // 27-36 are opcodes corresponding to reg-reg instr.
			27 : rvout <= rv1 + rv2;
			28 : rvout <= rv1 - rv2;
			29 : rvout <= rv1 << rv2[4:0];
			30 : rvout <= $signed(rv1) < $signed(rv2);
			31 : rvout <= rv1 < rv2;
			32 : rvout <= rv1 ^ rv2;
			33 : rvout <= rv1 >> rv2[4:0];
			34 : rvout <= $signed(rv1) >>> rv2[4:0];
			35 : rvout <= rv1 | rv2;
			36 : rvout <= rv1 & rv2;
			endcase
    end

endmodule



