module AES(clk);
input clk;

wire [127:0] in;
reg ena;
reg wea;
reg [8:0] addra;
wire reset;

initial begin
  ena=1'b1; 
  wea=1'b0; 
  addra=1'b0;
 end
wire[127:0] encrypted128;

blk_mem_gen_0 BRAM (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [0 : 0] addra
  .dina(dina),    // input wire [127 : 0] dina
  .douta(in)  // output wire [127 : 0] douta
);

ila_0 ila0 (
	.clk(clk), // input wire clk

	.probe0(in), // input wire [127:0]  probe0  
	.probe1(addra), // input wire [0:0]  probe1 
	.probe2(encrypted128), // input wire [127:0]  probe2
	.probe3(reset)
);

wire[127:0] key128 = 128'h000102030405060708090a0b0c0d0e0f;

AES_Encrypt a(clk,in,key128,encrypted128);

vio_0 vio0 (
  .clk(clk),                // input wire clk
  .probe_out0(reset)  // output wire [0 : 0] probe_out0
);

always@(posedge clk) begin
    if(reset) addra<=0;   
    else addra<=addra+1;
end

endmodule