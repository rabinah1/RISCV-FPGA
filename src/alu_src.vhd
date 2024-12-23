library ieee;
use ieee.std_logic_1164.all;

entity alu_src is
    port (
        clk         : in    std_logic;
        reset       : in    std_logic;
        control     : in    std_logic_vector(1 downto 0);
        immediate   : in    std_logic_vector(31 downto 0);
        register_in : in    std_logic_vector(31 downto 0);
        pc_in       : in    std_logic_vector(31 downto 0);
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
            if (control = "00") then
                data_out <= immediate;
            elsif (control = "01") then
                data_out <= register_in;
            elsif (control = "10") then
                data_out <= pc_in;
            else
                data_out <= (others => '0');
            end if;
        end if;

    end process alu_src;

end architecture rtl;
