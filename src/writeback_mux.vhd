library ieee;
use ieee.std_logic_1164.all;

entity writeback_mux is
    port (
        reset   : in    std_logic;
        control : in    std_logic;
        input_1 : in    std_logic_vector(31 downto 0);
        input_2 : in    std_logic_vector(31 downto 0);
        halt    : in    std_logic;
        output  : out   std_logic_vector(31 downto 0)
    );
end entity writeback_mux;

architecture rtl of writeback_mux is

begin

    writeback_mux : process (all) is
    begin

        if (reset = '1' or halt = '1') then
            output <= (others => '0');
        else
            if (control = '0') then
                output <= input_1;
            else
                output <= input_2;
            end if;
        end if;

    end process writeback_mux;

end architecture rtl;
