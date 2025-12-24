library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_adder is
    port (
        reset         : in    std_logic;
        halt          : in    std_logic;
        input_1_bytes : in    std_logic_vector(31 downto 0);
        input_2_bytes : in    std_logic_vector(31 downto 0);
        sum_words     : out   std_logic_vector(31 downto 0)
    );
end entity pc_adder;

architecture rtl of pc_adder is

begin

    pc_adder : process (all) is

        variable sum_bytes : std_logic_vector(31 downto 0);

    begin

        if (reset = '1' or halt = '1') then
            sum_words <= (others => '0');
            sum_bytes := (others => '0');
        else
            sum_bytes := std_logic_vector(signed(input_1_bytes) + signed(input_2_bytes));
            sum_words <= "00" & sum_bytes(31 downto 2);
        end if;

    end process pc_adder;

end architecture rtl;
