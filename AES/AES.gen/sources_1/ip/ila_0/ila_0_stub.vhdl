-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.1 (lin64) Build 3865809 Sun May  7 15:04:56 MDT 2023
-- Date        : Thu Nov  7 16:01:30 2024
-- Host        : dell-Inspiron-5415 running 64-bit Ubuntu 22.04.4 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/dell/Desktop/FPGA/VivadoProjects/FPGA_project/AES/AES.gen/sources_1/ip/ila_0/ila_0_stub.vhdl
-- Design      : ila_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ila_0 is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe7 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe10 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe11 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe12 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe13 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe14 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe15 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe16 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe17 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );

end ila_0;

architecture stub of ila_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[127:0],probe1[127:0],probe2[6:0],probe3[127:0],probe4[127:0],probe5[6:0],probe6[0:0],probe7[127:0],probe8[127:0],probe9[127:0],probe10[127:0],probe11[127:0],probe12[127:0],probe13[127:0],probe14[127:0],probe15[127:0],probe16[127:0],probe17[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ila,Vivado 2023.1";
begin
end;
