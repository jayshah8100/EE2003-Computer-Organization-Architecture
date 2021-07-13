module cpu (
    input clk, 
    input reset,
    input [31:0] idata,     // data from instruction memory
    output reg [31:0] PC,    // address to instruction memory
    output [31:0] iaddr,
    input [31:0] drdata,    // data read from data memory
    output reg [31:0] daddr,    // address to data memory
    
    output reg [31:0] dwdata,   // data to be written to data memory
    output reg [3:0] dwe        // write enable signal for each byte of 32-b word
);

    always @(posedge clk) begin
        if (reset) begin
            iaddr <= 0;
            daddr <= 0;
            dwdata <= 0;
            dwe <= 0;
        end else begin 
            iaddr <= iaddr + 4;   //iaddr is like PC
        end
    end

    // assign iaddr=PC;
    // wire [31:0] PC_next;
    // wire [31:0] PC_plus4;


    wire [1:0] alusrc;
    wire memtoreg;
    wire  regwrite;
    wire [3:0] memwrite;
    //wire [2:0] branch;
    wire [1:0] aluop;
    wire [1:0] regin;
    wire [2:0] imm;

        //Control Unit

    control CONTROL(
            .idata(idata), 
            .alusrc(alusrc),
            .memtoreg(memtoreg),
            .regwrite(regwrite),
            .memwrite(memwrite),
            //.branch(branch),
            .aluop(aluop),
            .regin(regin),
            .imm(imm)
            );
            
    wire [31:0]memtoregdata;
    wire [31:0] indataforreg;
    wire [31:0] regindata;
    wire [31:0]datawire1;
    wire [31:0]datawire2;

    // Register File

    regfile REGFILE(
            .rs1(idata[19:15]),
            .rs2(idata[24:20]),
            .rd(idata[11:7]),
            .indata(regindata),
            .we(regwrite),
            .clk(clk),
            .rv1(datawire1),
            .rv2(datawire2)
        );
    wire [5:0] op; // wire [3:0] alucon;

    alucontrol ALUCONTROL(
            .aluop(aluop),
            .instr(idata),
            // .imm(imm)
            // .funct7(idata[31:25]),
            // .funct3(idata[14:12]),
            .op(op)   //.alucon(alucon)
    );

    //wire zero;
    wire [31:0] aluoutdata;
    wire [31:0] immgen;

    // Offset calculation

    immgen IMMGEN(
            .imm(imm),
            .idata(idata),
            .immgen(immgen)
            );

    // Arithmetic Logic Unit
    wire [31:0] in2;
    assign in2 = alusrc[0] ? immgen : datawire2;

    alu ALU(
            .in1(datawire1),//.in1(alusrc[1] ? PC : datawire1),
            .in2(in2),
            .op(op),
            .out(aluoutdata)
            // .zero(zero)
            );

    // Handling SW, SH, SB

    always @(*) begin
        if (memwrite == 4'b1111 && daddr[1:0]== 2'b00) dwe = 4'b1111;
        else if (memwrite == 4'b0011 && daddr[1:0]== 2'b00) dwe=4'b0011;
        else if (memwrite == 4'b0011 && daddr[1:0]== 2'b10) dwe=4'b1100;
        else if (memwrite == 4'b0001 && daddr[1:0]== 2'b00) dwe=4'b0001;
        else if (memwrite == 4'b0001 && daddr[1:0]== 2'b01) dwe=4'b0010;
        else if (memwrite == 4'b0001 && daddr[1:0]== 2'b10) dwe=4'b0100;
        else if (memwrite == 4'b0001 && daddr[1:0]== 2'b11) dwe=4'b1000;
        else dwe=4'b0000; //exception
    end

    // assign we = (memwrite == 4'b1111 && daddr[1:0]== 2'b00) ? 4'b1111:
    //                 (memwrite == 4'b0011 && daddr[1:0]== 2'b00) ? 4'b0011:
    //                 (memwrite == 4'b0011 && daddr[1:0]== 2'b10) ? 4'b1100:
    //                 (memwrite == 4'b0001 && daddr[1:0]== 2'b00) ? 4'b0001:
    //                 (memwrite == 4'b0001 && daddr[1:0]== 2'b01) ? 4'b0010:
    //                 (memwrite == 4'b0001 && daddr[1:0]== 2'b10) ? 4'b0100:
    //                 (memwrite == 4'b0001 && daddr[1:0]== 2'b11) ? 4'b1000: 4'b0000;

    always @(*) begin
        if (memwrite == 4'b0000) dwdata= datawire2;
        else dwdata= (datawire2 << (daddr[1:0] * 8));
    end

    always @(aluoutdata) begin
        daddr= aluoutdata;
    end
    // assign dwdata = (memwrite == 4'b0000) ? datawire2 : (datawire2 << daddr[1:0] * 8) ;
    // assign daddr = aluoutdata;



    // Handling LW, LH, LB

    assign memtoregdata = memtoreg ? drdata : aluoutdata;
    assign indataforreg = (memtoreg && (idata[14:12] == 3'b001 || idata[14:12] == 3'b101)) ? ((memtoregdata >> (daddr[1:0] * 8)) & 32'h0000FFFF) :
                                (memtoreg && (idata[14:12] == 3'b000 || idata[14:12] == 3'b100)) ? ((memtoregdata >> (daddr[1:0] * 8)) & 32'h000000FF) : memtoregdata;
                                
    assign regindata = indataforreg ;

    // CAlculation of next iaddr

    // PC Count(
    //         .PC(PC),
    //         .immgen(immgen),
    //         .branch(branch),
    //         .zero(zero),
    //         .aluoutdata(aluoutdata),
    //         .PC_plus4(PC_plus4),
    //         .PC_next(PC_next)
    //         );
















endmodule