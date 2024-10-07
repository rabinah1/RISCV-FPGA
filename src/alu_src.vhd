library ieee;
use ieee.std_logic_1164.all;

entity alu_src is
    port (
        clk         : in    std_logic;
        reset       : in    std_logic;
        control     : in    std_logic;
        immediate   : in    std_logic_vector(31 downto 0);
        register_in : in    std_logic_vector(31 downto 0);
        data_out    : out   std_logic_vector(31 downto 0)
    );
end entity alu_src;

architecture rtl of alu_src is

begin

    alu_src : process (all) is
    begin

        if (reset = '1') then
            data_out <= (others => '0');
        elsif (rising_edge(clk)) then
            if (control = '0') then
                data_out <= immediate;
            else
                data_out <= register_in;
            end if;
        end if;

    end process alu_src;

end architecture rtl;
