module alucontrol(
    input [1:0] aluop,
    input [31:0] instr,
    // input [6:0] funct7,
    // input [2:0] funct3,
    output reg [5:0] op
    );

    always @(*)
    begin
        case (aluop)
            2'b10: //ALU I-R type instr.
                case(instr[6:0])  // checks whether its a Reg-Immediate Instr(I type)
                    7'b0010011:
                    case(instr[14:12])
                        3'b000: op <= 18;
                        3'b010: op <= 19;
                        3'b011: op <= 20;
                        3'b100: op <= 21;
                        3'b110: op <= 22;
                        3'b111: op <= 23;
                        3'b001: op <= 24;
                        3'b101: 
                            case(instr[30])
                                1'b0: op = 25;
                                1'b1: op = 26;		
                            endcase
                    endcase
                    7'b0110011:
				        case(instr[14:12])
					        3'b000: 
						        case(instr[30])
							        1'b0: op <= 27;
							        1'b1: op <= 28;	
						        endcase
					        3'b001: op <= 29;
					        3'b010: op <= 30;
					        3'b011: op <= 31;
					        3'b100: op <= 32;
					        3'b101: 
						        case(instr[30])
							        1'b0: op <= 33;
							        1'b1: op <= 34;	
						        endcase
					        3'b110: op <= 35;
					        3'b111: op <= 36;
				        endcase
                endcase
        
            2'b00: op<=18; //LW, SW, JALR
            
             
            // 2'b01: begin // branch
            // case(funct3)
            // 3'b000: alucon<=4'b1000;
            // 3'b001: alucon<=4'b1000;
            // 3'b100: alucon<=4'b0010;
            // 3'b101: alucon<=4'b0010;
            // 3'b110: alucon<=4'b0011;
            // 3'b111: alucon<=4'b0011;
            // endcase
            // end
            // default: alucon <= 10;
        endcase
    end
endmodule