`timescale 1ns/1ps
`define WRITE_BASE_ADDRESS 32'h40000
`define READ_BASE_ADDRESS 32'h40004

module biu (
    input clk,
    input reset,
    input [31:0] daddr,
    input [31:0] dwdata,
    input [3:0] dwe,
    output [31:0] drdata,

    // Signals going to/from dmem
    output [31:0] daddr1,
    output [31:0] dwdata1,
    output [3:0]  dwe1,
    input  [31:0] drdata1,

    // Signals going to/from peripheral
    output [31:0] daddr2,
    output [31:0] dwdata2,
    output [3:0]  dwe2,
    input  [31:0] drdata2
);

   
    assign drdata= (daddr == `READ_BASE_ADDRESS) ? drdata2 : drdata1; // For a load instr. only if this specific address is provided
                                                                      // the counter data comes from the peripheral 

    // We can assign the same address to both DMEM as well as the peripheral as the discretion (muxing logic) to write (for a store instr.)
    // and read ( for a load instr.) is taken based on the address already in perpheral.v so no need to repeat it twice in this case
    
    
    assign daddr1 = daddr;
    assign dwdata1 = dwdata;
    assign dwe1 = dwe;

    assign daddr2 = daddr;
    assign dwdata2 = dwdata;
    assign dwe2 = dwe;
    
    
endmodule

// `timescale 1ns/1ps
// // Bus interface unit: assumes two branches of the bus -
// // 1. connect to dmem
// // 2. connect to a single peripheral
// // The BIU needs to know the addresses at which DMEM and peripheral are
// // connected, so it can do the required multiplexing. 
// // These need to be added as part of your code. 
// module biu (
//     input clk,
//     input reset,
//     input [31:0] daddr,
//     input [31:0] dwdata,
//     input [3:0] dwe,
//     output [31:0] drdata,

//     // Signals going to/from dmem
//     output [31:0] daddr1,
//     output [31:0] dwdata1,
//     output [3:0]  dwe1,
//     input  [31:0] drdata1,

//     // Signals going to/from peripheral
//     output [31:0] daddr2,
//     output [31:0] dwdata2,
//     output [3:0]  dwe2,
//     input  [31:0] drdata2
// );

//     // Modify below so that depending on the actual daddr range the BIU decides whether 
//     // the response was from DMEM or peripheral - maybe a MUX?
//     assign drdata = drdata1;

//     // Send values to DMEM or peripheral (or both if it does not matter)
//     // as required
//     assign daddr1 = daddr;
//     assign dwdata1 = dwdata;
//     assign dwe1 = dwe;

//     assign daddr2 = daddr;
//     assign dwdata2 = dwdata;
//     assign dwe2 = dwe;

// endmodule