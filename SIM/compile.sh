
ghdl_mcode -a ../VHDL/candle4.vhd
ghdl_mcode -a ../TEST/tb_candle4.vhd
ghdl_mcode -e tb_candle4
ghdl_mcode -r tb_candle4 --vcd=wave.vcd
