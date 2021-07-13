`timescale 1ns/1ps
`define OUTFILE "output.txt"

module outperiph (
    input clk,
    input reset,
    input [31:0] daddr,
    input [31:0] dwdata,
    input [3:0] dwe,
    output reg [31:0] drdata
);
    reg [31:0] counter;                //keeps track of number times the store instr. is used to write into outfile.txt
        initial begin
            counter=0;
        end

        integer fh;                     // integer to store the file handle
    
        initial begin                    // used to clear the file at the start of each run
            fh=$fopen(`OUTFILE,"w");     // openin gthe file in 'w'- write mode overwrites what was previously written
            $fclose(fh);
        end

        always@(*) begin
            if ((daddr==`WRITE_BASE_ADDRESS) && (dwe!=0))begin // only if write enable !=0 writing takes place
                fh=$fopen(`OUTFILE,"a");                    // writing in 'a' append mode as file needs to be modified in every store instr.
                $fwrite(fh,"%c",dwdata);                    // casting the 32 bit dwdata into a character %c
                $fclose(fh);
                counter=counter +1;
            end
            else if (daddr==`READ_BASE_ADDRESS)begin         // returns the number of write operations performed till now
                drdata=counter;
            end
        end 
    
//     always@(*) begin
//         $display("The value of counter is: %d", counter);
//     end
    
    
endmodule


// `timescale 1ns/1ps
// `define OUTFILE "output.txt"

// module outperiph (
//     input clk,
//     input reset,
//     input [31:0] daddr,
//     input [31:0] dwdata,
//     input [3:0] dwe,
//     output [31:0] drdata
// );

//     // Implement the peripheral logic here: use $fwrite to the file output.txt
//     // Use the `define above to open the file so that it can be 
//     // overridden later if needed

//     // Return value from here (if requested based on address) should
//     // be the number of values written so far
    
//     assign drdata = 0;  

// endmodule