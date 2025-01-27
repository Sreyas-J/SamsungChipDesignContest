module AES_Encrypt(
    input clk,
    input rst,
    input [127:0] in,
    input [(128*11)-1:0] fullkeys,
    output reg [127:0] out,
    output reg [5:0] cntr
//    output wire [(128*11)-1:0] states_out
);

    reg [127:0] addrkIn;
    wire [127:0] addrkOut;
    reg [127:0] sIn;
    wire [127:0] sOut;
    reg [127:0] rIn;
    wire [127:0] rOut;
    reg [127:0] mIn;
    wire [127:0] mOut;
    reg adrk;
    
    reg done;
    reg [127:0] key;
    reg [127:0] addrkOut_reg, sOut_reg, rOut_reg, mOut_reg;
//    reg [127:0] states [11:0];
//    wire [127:0] buff;
//    wire [127:0] afterSubBytes;
//    wire [127:0] afterShiftRows;
//    wire [127:0] encryptOut [10:0]; // Wires for storing intermediate encryptRound outputs

    addRoundKey addrk1 (addrkIn, addrkOut, key);
    subBytes s(sIn,sOut);
    shiftRows r(rIn,rOut);
    mixColumns m(mIn,mOut);
    
    always@(posedge clk or posedge rst) begin
        if(rst)begin
            cntr<=4'd0;
            addrkOut_reg <= 0;
            sOut_reg <= 0;
            rOut_reg <= 0;
            mOut_reg<=0;
            adrk<=0;
        end
        else if(cntr==6'd40) begin
            cntr<=4'd0;
            done<=1'b1;
            out<=addrkOut;
            adrk<=1'b0;
        end
        else begin
            done<=1'b0;
            key<=fullkeys[(((128*11)-1)-128*((cntr+1)/3'd4))-:128];
         
            if(cntr==6'd0)begin
              addrkIn<=in;
              adrk<=1'b1;
            end
            else if(cntr==6'd39)begin
                addrkIn<=rOut;
                adrk<=1'b1;
            end

            else if(cntr%3'd4==2'd1) sIn<=addrkOut;
            else if(cntr%3'd4==2'd2) rIn<=sOut;
            else if(cntr%3'd4==2'd3) mIn<=rOut;
            else if(cntr%3'd4==2'd0)begin
                addrkIn<=mOut;
                adrk<=1'b1;
            end
            
         if(rst==1'b0) begin
            adrk<=1'b0;
            addrkOut_reg <= addrkOut;
            sOut_reg <= sOut;
            rOut_reg <= rOut;
            mOut_reg<=mOut;
         end
            
            cntr<=cntr+1;
        end
//        $display("counter:%d sOut:%h rOut:%h mixColOut:%h addrkOut:%h",cntr,sOut,rOut,mOut,addrkOut);
    end

//    // Generate encryption rounds
//    genvar i;
//    generate
//        for (i = 1; i < 10; i = i + 1) begin : loop
//            encryptRound er (
//                .in(states[i-1]),
//                .key(fullkeys[(((128*11)-1)-128*i)-:128]),
//                .out(encryptOut[i])
//            );
//        end
//    endgenerate

//    integer j;
//    always @(posedge clk) begin
//        // Update states for each round
//        for (j = 9; j >= 0; j = j - 1) begin
//            states[j] <= encryptOut[j];
//        end
        
//    end
    
////    generate
////        for (i = 0; i < 11; i = i + 1) begin : flatten_states
////            assign states_out[(i*128)+:128] = states[i];
////        end
////    endgenerate

//    // Final Round Logic - instantiated outside of always block
//    subBytes sb (states[9], afterSubBytes);
//    shiftRows sr (afterSubBytes, afterShiftRows);
//    addRoundKey addrk2 (afterShiftRows, out, fullkeys[127:0]);

endmodule