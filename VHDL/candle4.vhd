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

entity candle4 is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		LEDN0		: out	std_logic;
		LEDN1		: out	std_logic;
		LEDN2		: out	std_logic;
		LEDN3		: out	std_logic
	);
end candle4;

architecture rtl of candle4 is
	signal lfsr : std_logic_vector(16 downto 0) := (0=>'1',others=>'0');
	signal pre  : std_logic_vector(17 downto 0) := (others=>'0');
	signal pulse : std_logic; -- 2.62 ms
	signal pwmcnt : std_logic_vector(4 downto 0);
	signal reg0 : std_logic_vector(4 downto 0);
	signal reg1 : std_logic_vector(4 downto 0);
	signal reg2 : std_logic_vector(4 downto 0);
	signal reg3 : std_logic_vector(4 downto 0);
begin

	pulse <= pre(17);
	--pulse <= pre(4);
	
	PPRE: process(MCLK, nRST)
	begin
		if (nRST = '0') then
			pre<= (others=>'0');
		elsif (MCLK'event and MCLK = '1') then
			if (pulse = '1') then
				pre<= (others=>'0');
			else
				pre <= std_logic_vector(unsigned(pre)+1);
			end if;
		end if;
	end process PPRE;
	

	PLFSR: process(MCLK, nRST)
	begin
		if (nRST = '0') then
			lfsr <= (0=>'1',others=>'0');
		elsif (MCLK'event and MCLK = '1') then
			if (pulse = '1') then
				lfsr(0) <= lfsr(16) xor lfsr(13);
				lfsr(16 downto 1) <= lfsr(15 downto 0);
			end if;
		end if;
	end process PLFSR;

	PPWMC: process(MCLK, nRST)
	begin
		if (nRST = '0') then
			pwmcnt <= (others=>'0');
		elsif (MCLK'event and MCLK = '1') then
			if (pulse = '1') then
				if (pwmcnt = "11111") then
					pwmcnt <= (others=>'0');
				else
					pwmcnt <= std_logic_vector(unsigned(pwmcnt)+1);
				end if;
			end if;
		end if;
	end process PPWMC;
	
	P0 : process(MCLK, nRST)
	begin
		if (nRST = '0') then
			LEDN0 <= '1';
			reg0 <= "00000";
		elsif (MCLK'event and MCLK = '1') then
			if (pulse = '1') then
				if (pwmcnt = "11111") then
					LEDN0 <= '0';
					if (lfsr(4) = '0') then
						reg0 <= (others=>'1');
					else
						reg0 <= lfsr(4 downto 0);
					end if;
				elsif (pwmcnt = reg0) then
					LEDN0 <= '1';
				end if;
			end if;
		end if;
	end process P0;
				
	P1 : process(MCLK, nRST)
	begin
		if (nRST = '0') then
			LEDN1 <= '1';
			reg1 <= "00000";
		elsif (MCLK'event and MCLK = '1') then
			if (pulse = '1') then
				if (pwmcnt = "11111") then
					LEDN1 <= '0';
					if (lfsr(9) = '0') then
						reg1 <= (others=>'1');
					else
						reg1 <= lfsr(9 downto 5);
					end if;
				elsif (pwmcnt = reg1) then
					LEDN1 <= '1';
				end if;
			end if;
		end if;
	end process P1;
	
	P2 : process(MCLK, nRST)
	begin
		if (nRST = '0') then
			LEDN2 <= '1';
			reg2 <= "00000";
		elsif (MCLK'event and MCLK = '1') then
			if (pulse = '1') then
				if (pwmcnt = "11111") then
					LEDN2 <= '0';
					if (lfsr(14) = '0') then
						reg2 <= (others=>'1');
					else
						reg2 <= lfsr(14 downto 10);
					end if;
				elsif (pwmcnt = reg2) then
					LEDN2 <= '1';
				end if;
			end if;
		end if;
	end process P2;
	
	P3 : process(MCLK, nRST)
	begin
		if (nRST = '0') then
			LEDN3 <= '1';
			reg3 <= "00000";
		elsif (MCLK'event and MCLK = '1') then
			if (pulse = '1') then
				if (pwmcnt = "11111") then
					LEDN3 <= '0';
					if (lfsr(16) = '0') then
						reg3 <= (others=>'1');
					else
						reg3 <= lfsr(16 downto 12);
					end if;
				elsif (pwmcnt = reg3) then
					LEDN3 <= '1';
				end if;
			end if;
		end if;
	end process P3;
end rtl;

