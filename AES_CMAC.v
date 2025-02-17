
//`timescale 1ns / 1ps

//module AES_CMAC#(
//    parameter C = 128'h87
//)
//(   
//    input clk,
//    input reset,
//    input is_padded,
//    output reg [127:0] tag,
//    output wire [127:0] X,
//    output reg [8:0] addra,
//    output reg done,
//    output reg [127:0] xin2,
//    output wire [127:0] in
//    );
    
//    wire [(128*11)-1:0] fullkeys;
//    wire [127:0] key128 = 128'h000102030405060708090a0b0c0d0e0f;
//    keyExpansion ke (key128, fullkeys);

////    wire [127:0] in;
//    reg [127:0] K1, K2;
//    wire [127:0] L;

//    // Instantiate RAM and Encryption Modules
//    ram BRAM1 (clk, 1'b0, addra, 0, in);
//    AES_Encrypt inst1 (clk, in, fullkeys, L);
//    AES_Encrypt inst2 (clk, xin2, fullkeys, X);

//    // Generate Subkeys K1 and K2 on reset or after L is ready
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            K1 <= 128'b0;
//            K2 <= 128'b0;
//        end else begin
//            K1 <= (L << 1) ^ (L[127] ? C : 0); // K1 = L shifted left, XOR if MSB is 1
//            K2 <= (K1 << 1) ^ (K1[127] ? C : 0); // K2 = K1 shifted left, XOR if MSB is 1
//        end
//    end

//    // Calculate xin2
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            xin2 <= 128'b0;
//        end else if (addra == 267) begin
//            if (is_padded) begin
//                xin2 <= X ^ in ^ K1; // XOR with K1 for padded input
//            end else begin
//                xin2 <= X ^ in ^ K2; // XOR with K2 for unpadded input
//            end
//        end else begin
//            xin2 <= X ^ in; // Intermediate XOR
//        end
//    end

//    // Manage Address and Done Signals
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            addra <= 9'b0;
//            done <= 1'b0;
//        end else if (!done) begin
//            addra <= addra + 1;
//            if (addra >= 266) done <= 1'b1;
//        end
//    end

//    // Output Final Tag
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            tag <= 128'b0;
//        end else if (done) begin
//            tag <= X; // Final result
//        end
//    end
//endmodule
////05925167934b25872d97272afcd2b4fb 000102030405060708090a0b0c0d0e0f

`timescale 1ns / 1ps

module AES_CMAC#(
    parameter C = 128'h00000000000000000000000000000087 // Full 128-bit constant
)
(   
    input clk,
    input reset,
    input is_padded,
    output reg [127:0] tag,
    output reg [127:0] X,
    output reg [8:0] addra,
    output reg done,
    output reg [127:0] xin2,
    output wire [127:0] in,
    output wire [127:0] L,
    output reg flag,
    output reg [3:0] cntr,
    output reg [127:0] K1
//    output wire done1,done2
    );

    wire [(128*11)-1:0] fullkeys;
    wire [127:0] key128 = 128'h000102030405060708090a0b0c0d0e0f;
    reg [127:0] K2, in_zero;
//    output reg flag;
    
    reg L_ready, tag_updated;
    reg compute = 1'b0;
    wire [127:0] out_X;
    reg done_out, final_tag;
//    output reg [3:0]cntr;
    // Key Expansion
    keyExpansion ke (key128, fullkeys);

    // Instantiate RAM and AES Encryption Modules
    ram BRAM1 (clk, 1'b0, addra, 0, in);
    AES_Encrypt inst1 (clk, in_zero ,fullkeys, L);
    AES_Encrypt inst2 (clk, xin2, fullkeys, out_X);

    // Generate Subkeys K1 and K2 after L is ready
    always @(posedge clk or posedge reset) begin
        if (reset) begin
//            K1 <= 128'b0;
//            K2 <= 128'b0;
//            L_ready <= 1'b0;
            in_zero <= 128'b0;
//            compute <= 1'b0;
            done_out<=1'b1;
            end
        if (done_out) begin
            K1 = (L << 1) ^ (L[127] ? C : 0); // Compute K1
            K2 = (K1 << 1) ^ (K1[127] ? C : 0); // Compute K2
//            L_ready = 1'b1;
//            compute = 1'b1;
        end
    end
        
    // Calculate xin2
    // Calculate xin2
    always @(posedge clk or posedge reset) begin
    
        if(reset) begin 
            X<=128'b0;
            flag<=1'b1;
        end
        else X<=out_X;
    
        if (reset) begin
            xin2 <= 128'b0;
            
//              xin2<=128'hc6a13b37878f5b826f4f8162a1c8d879;
        end else if (addra == 266) begin
           if(flag) begin  // Corrected stopping condition
            if (is_padded) begin
                xin2 <= X ^ in ^ K1;  // Corrected XOR order
            end else begin
                xin2 <= X ^ in ^ K2;  // Corrected XOR order
            end
            flag <= 1'b0;
           end
        end else begin
          if(flag)
          begin
            xin2 <= X ^ in;
            flag<=1'b0;
           end // Intermediate XOR
        end
    end

    // Manage Address and Done Signals
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            addra <= 9'b0;
            done <= 1'b0;
        end else if (!done & flag) begin
            addra <= addra + 1;
            if (addra >= 266) done <= 1'b1;  // Ensure correct stopping point
        end
    end
    
    always@(posedge clk or posedge reset)
    begin
        if(reset || cntr==4'd15)
        begin
            cntr<=4'd0;
        end
        else if(cntr==4'd13)
        begin
            flag<=1'b1;
        end
         if(cntr!=4'd15) cntr<=cntr+1;
    end

    // Output Final Tag with Synchronization
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tag <= 128'b0;
            tag_updated <= 1'b0;
            final_tag<=1'b0;
        end else if (done && !tag_updated) begin
            tag = X ^ in ^ K1; // Store final computed value
            tag_updated = 1'b1;
            xin2=tag;
             // Prevent re-updating tag
        end
        else if(!final_tag) begin
            tag=X;
        end
    end
endmodule

//7CE783094B8A7710957814628A2C6BDF



