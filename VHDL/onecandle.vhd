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

entity onecandle is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		PULSE		: in	std_logic;
		PWM			: in	std_logic_vector(4 downto 0);
		RAND		: in	std_logic_vector(4 downto 0);
		LEDN		: out	std_logic
	);
end onecandle;


architecture rtl of onecandle is

	signal reg : std_logic_vector(4 downto 0):= (others=>'0');
	
begin


	P0 : process(MCLK, nRST)
	begin
		if (nRST = '0') then
			LEDN <= '1';
			reg <= "00000";
		elsif (MCLK'event and MCLK = '1') then
			if (pulse = '1') then
				if (pwm = "11111") then
					LEDN <= '0';
					if (RAND(4) = '0') then
						reg <= (others=>'1');  -- full
					else
						reg <= RAND;
					end if;
				elsif (PWM = reg) then
					LEDN <= '1';
				end if;
			end if;
		end if;
	end process P0;
	
end rtl;
