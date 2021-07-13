module alu(
    input [31:0] in1,		// First operand
    input [31:0] in2,		// Second operand
    input [3:0] op,			// opcode encoding 
    output reg [31:0] out,	// Output value
	output zero
    );
	
    assign zero = (out == 0);   // plays a role to indicate whether to branch or not in pc.v module

	always @(*) begin

        case(op)
			0 : out <= in1 + in2;
			1 : out <= in1 - in2;
            2 : out <= $signed(in1) < $signed(in2); // signed comparison 
            3 : out <= in1 < in2;                   //unsigned comparison
			4 : out <= in1 ^ in2;
			5 : out <= in1 | in2;
			6 : out <= in1 & in2;
			7 : out <= in1 << in2[4:0];
			8 : out <= in1 >> in2[4:0];
			9 : out <= $signed(in1) >>> in2[4:0];
            default: out<= 0;
			endcase
    end
	
endmodule