library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pc_offset_mux is
    port (
        clk        : in    std_logic;
        reset      : in    std_logic;
        control    : in    std_logic;
        input_1    : in    std_logic_vector(31 downto 0);
        input_2    : in    std_logic_vector(31 downto 0);
        offset_out : out   std_logic_vector(31 downto 0)
    );
end entity pc_offset_mux;

architecture rtl of pc_offset_mux is

begin

    pc_offset_mux : process (all) is
    begin

        if (reset = '1') then
            offset_out <= (others => '0');
        elsif (rising_edge(clk)) then
            if (control = '0') then
                offset_out <= input_1;
            else
                offset_out <= input_2;
            end if;
        end if;

    end process pc_offset_mux;

end architecture rtl;
