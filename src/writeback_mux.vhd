library ieee;
use ieee.std_logic_1164.all;

entity writeback_mux is
    port (
        clk : in std_logic;
        reset : in std_logic;
        control : in std_logic;
        alu_res : in std_logic_vector(31 downto 0);
        dmem_data : in std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(31 downto 0)
    );
end entity writeback_mux;

architecture rtl of writeback_mux is
begin

    writeback_mux : process (all) is
    begin

        if (reset = '1') then
            data_out <= (others => '0');
        elsif (rising_edge(clk)) then
            if (control = '0') then
                data_out <= alu_res;
            else
                data_out <= dmem_data;
            end if;
        end if;

    end process writeback_mux;

end architecture rtl;
