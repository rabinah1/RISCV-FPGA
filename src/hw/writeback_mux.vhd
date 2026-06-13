library ieee;
use ieee.std_logic_1164.all;

entity writeback_mux is
    port (
        reset     : in    std_logic;
        control   : in    std_logic;
        input_1   : in    std_logic_vector(31 downto 0);
        input_2   : in    std_logic_vector(31 downto 0);
        halt      : in    std_logic;
        load_type : in    std_logic_vector(2 downto 0);
        output    : out   std_logic_vector(31 downto 0)
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
                if (load_type = "010") then
                    output <= input_2;
                elsif (load_type = "000") then
                    output(7 downto 0)  <= input_2(7 downto 0);
                    output(31 downto 8) <= (others => input_2(7));
                elsif (load_type = "001") then
                    output(15 downto 0)  <= input_2(15 downto 0);
                    output(31 downto 16) <= (others => input_2(15));
                elsif (load_type = "100") then
                    output(7 downto 0)  <= input_2(7 downto 0);
                    output(31 downto 8) <= (others => '0');
                elsif (load_type = "101") then
                    output(15 downto 0)  <= input_2(15 downto 0);
                    output(31 downto 16) <= (others => '0');
                else
                    output <= (others => '0');
                end if;
            end if;
        end if;

    end process writeback_mux;

end architecture rtl;
