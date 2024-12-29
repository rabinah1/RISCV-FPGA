library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pc_adder is
    port (
        clk     : in    std_logic;
        reset   : in    std_logic;
        enable  : in    std_logic;
        input_1 : in    std_logic_vector(31 downto 0);
        input_2 : in    std_logic_vector(31 downto 0);
        sum     : out   std_logic_vector(31 downto 0)
    );
end entity pc_adder;

architecture rtl of pc_adder is

begin

    pc_adder : process (all) is
    begin

        if (reset = '1') then
            sum <= (others => '0');
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                sum <= input_1 + input_2;
            end if;
        end if;

    end process pc_adder;

end architecture rtl;
