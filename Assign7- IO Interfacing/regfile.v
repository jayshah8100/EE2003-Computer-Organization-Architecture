module regfile(
    input reset,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] indata,
    input  we,
    input clk,
    output reg [31:0] rv1,
    output reg [31:0] rv2
    );

    reg [31:0] RF[31:0];

  

    integer i;
    initial begin
    for(i = 0; i < 32; i = i+1) 
        RF[i] = 0;
    end

    
//     assign rv1 = (rs1 !=0) ? RF[rs1] : 0;
//     assign rv2 = (rs2 !=0) ? RF[rs2] : 0;
    
//     always @ (posedge clk) begin
//         if(we && !reset)
//             begin
//                 RF[rd] <= indata;
//             end 
//     end
    always @(*)begin
        rv2=RF[rs2];      
        rv1=RF[rs1];
    end
    always @ (posedge clk) begin
        if(we && rd!=0 && !reset) // rd!=0 as reg[0] has to be hardwired to 0, rd cannot change it
           RF[rd] <= indata;
       end

endmodule