library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu is
    port (
        clk : in std_logic;
        reset : in std_logic;
        input_1 : in std_logic_vector(31 downto 0);
        input_2 : in std_logic_vector(31 downto 0);
        operand : in std_logic_vector(3 downto 0);
        alu_output : out std_logic_vector(31 downto 0)
    );
end entity alu;

architecture rt of alu is
begin

    alu : process (all) is
    begin

        if (reset = '1') then
            alu_output <= (others => '0');
        elsif (rising_edge(clk)) then
            -- placeholder
        end if;

    end process alu;

end architecture rtl;
