--###############################
--# Project Name : 
--# File         : 
--# Author       : 
--# Description  : 
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_candle4 is
end tb_candle4;

architecture stimulus of tb_candle4 is

-- COMPONENTS --
	component candle4
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			LEDN0		: out	std_logic;
			LEDN1		: out	std_logic;
			LEDN2		: out	std_logic;
			LEDN3		: out	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal LEDN0		: std_logic;
	signal LEDN1		: std_logic;
	signal LEDN2		: std_logic;
	signal LEDN3		: std_logic;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_candle4_0 : candle4
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			LEDN0		=> LEDN0,
			LEDN1		=> LEDN1,
			LEDN2		=> LEDN2,
			LEDN3		=> LEDN3
		);

--
	CLOCK: process
	begin
		while (RUNNING = '1') loop
			MCLK <= '1';
			wait for 10 ns;
			MCLK <= '0';
			wait for 10 ns;
		end loop;
		wait;
	end process CLOCK;

	GO: process
	begin
		nRST <= '0';
		wait for 1001 ns;
		nRST <= '1';
		wait for 1000 ms;
		--RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
