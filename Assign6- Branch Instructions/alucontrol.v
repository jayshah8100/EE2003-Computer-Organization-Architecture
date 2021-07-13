module alucontrol(
    input [1:0] aluop, // control signal for differentiating load-store and ALU type instr.
    input [31:0] instr,
    input [2:0] funct3,
    output reg [3:0] op
    );

    always @(*)
    begin
        case (aluop)
            2'b10: //ALU I-R type instr.
                case(funct3)
                    3'b000: 
                            case({instr[30],instr[5]})
                                2'b01: op = 0;
                                2'b11: op = 1;	
                                default: op=0;
                            endcase
                    3'b010: op = 2;
                    3'b011: op = 3;
                    3'b100: op = 4;
                    3'b110: op = 5;
                    3'b111: op = 6;
                    3'b001: op = 7;
                    3'b101: 
                        case(instr[30])
                            1'b0: op = 8;
                            1'b1: op = 9;		
                        endcase
                endcase
            2'b00: op=0; // For load-store instr. & JALR just add offset(immgen) to the base address (rs1)
            2'b01: // branch
		        case(funct3)
		            3'b000: op=1;
		            3'b001: op=1;
		            3'b100: op=2;
		            3'b101: op=2;
		            3'b110: op=3;
		            3'b111: op=3;
		        endcase
        endcase
    end
endmodule

