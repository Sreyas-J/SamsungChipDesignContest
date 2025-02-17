module AES#(
    parameter C = 128'h00000000000000000000000000000087 // Full 128-bit constant
)(  input clk,
    input reset,
    input  [15:0] len,
    
    input [127:0] messIn,
    input [127:0] cIn,
    
    output  [127:0] encrypted,
    output [127:0] tag,
    
    output reg[8:0] messAddra,
    output reg [8:0] cmacAddra
);


//wire [127:0] in[1:0];
reg ena;
reg wea,done;
//reg [6:0] addra[1:0];
//wire[127:0] encrypted128[5:0];
wire [(128*11)-1:0] fullkeys;
reg [127:0] K1,K2,L;
reg [127:0] cmacIn;
wire [127:0] cmacReg;

wire[127:0] key128 = 128'h000102030405060708090a0b0c0d0e0f;
keyExpansion ke (key128, fullkeys);


AES_Encrypt a(clk,messIn,fullkeys,encrypted);
AES_Encrypt b(clk,cmacIn,fullkeys,cmacReg);
//AES_Encrypt c(clk,in[2],fullkeys,encrypted128[2]);
//AES_Encrypt d(clk,in[3],fullkeys,encrypted128[3]);
//AES_Encrypt e(clk,in[4],fullkeys,encrypted128[4]);
//AES_Encrypt f(clk,in[5],fullkeys,encrypted128[5]);

always @(posedge clk) begin
    K1 = (L << 1) ^ (L[127] ? C : 0); 
    K2 = (K1 << 1) ^ (K1[127] ? C : 0); 
end

always@(posedge clk) begin
    if(reset) begin
        done<=1'b0;
        ena<=1'b1; 
      wea<=1'b0; 
      done<=1'b0;
      messAddra <= 9'b0; // Initialize each element individually
      cmacAddra <= 9'b0;
//      cmacReg<=128'd0;
      cmacIn<=cIn;
    end  
    else begin
        if(done==1'b0) begin
            messAddra<=messAddra+1;
            cmacAddra<=cmacAddra+1;
            if(cmacAddra!=265)   cmacIn<=cIn^cmacReg;
            else begin
                if(len%16'd128) cmacIn<=cmacReg^cIn^K2;
                else cmacIn<=cmacReg^cIn^K1;
            end
//            cmacReg<=cmacIn;
        end
         
        
     if(messAddra>=267)
        done=1'b1;
        
     $display("reset:%d addra:%d cmacReg:%h cIn:%h cmacIn:%h",reset,messAddra,cmacReg,cIn,cmacIn);
    end
end

endmodule