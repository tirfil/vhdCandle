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

entity candle16 is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		LEDN		: out	std_logic_vector(15 downto 0)
	);
end candle16;

architecture rtl of candle16 is

	component onecandle
		port(
				MCLK		: in	std_logic;
				nRST		: in	std_logic;
				PULSE		: in	std_logic;
				PWM			: in	std_logic_vector(4 downto 0);
				RAND		: in	std_logic_vector(4 downto 0);
				LEDN		: out	std_logic
			);
	end component;
	
	signal lfsr : std_logic_vector(16 downto 0) := (0=>'1',others=>'0');
	signal pre  : std_logic_vector(17 downto 0) := (others=>'0');
	signal pulse : std_logic; -- 2.62 ms
	signal pwmcnt : std_logic_vector(4 downto 0) := (others=>'0');
	signal rand13 , rand14, rand15 : std_logic_vector(4 downto 0);

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
	
GCANDLE : for I in 0 to 12 generate
	
	PX : onecandle port map(
		MCLK => MCLK,
		nRST => nRST,
		PULSE => pulse,
		PWM => pwmcnt,
		RAND => lfsr(I+4 downto I),
		LEDN => LEDN(I)
	);

end generate GCANDLE;	

	PX13 : onecandle port map(
		MCLK => MCLK,
		nRST => nRST,
		PULSE => pulse,
		PWM => pwmcnt,
		RAND => rand13,
		LEDN => LEDN(13)
	);
	
	PX14 : onecandle port map(
		MCLK => MCLK,
		nRST => nRST,
		PULSE => pulse,
		PWM => pwmcnt,
		RAND => rand14,
		LEDN => LEDN(14)
	);
	
	PX15 : onecandle port map(
		MCLK => MCLK,
		nRST => nRST,
		PULSE => pulse,
		PWM => pwmcnt,
		RAND => rand15,
		LEDN => LEDN(15)
	);
	
	rand13 <= lfsr(0) 			& lfsr(16 downto 13);
	rand14 <= lfsr(1 downto 0) 	& lfsr(16 downto 14);
	rand15 <= lfsr(2 downto 0) 	& lfsr(16 downto 15);

end rtl;

