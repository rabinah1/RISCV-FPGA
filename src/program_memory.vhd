library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity program_memory is
    port (
        clk           : in    std_logic;
        reset         : in    std_logic;
        decode_enable : in    std_logic;
        address_in    : in    std_logic_vector(31 downto 0);
        address_out   : out   std_logic_vector(31 downto 0);
        instruction   : out   std_logic_vector(31 downto 0)
    );
end entity program_memory;

architecture rtl of program_memory is

    type memory is array(1023 downto 0) of std_logic_vector(31 downto 0);

    signal prog_mem : memory := (0 => "11111110000000010000000100010011",
                                 1 => "00000000000100010010111000100011",
                                 2 => "00000000100000010010110000100011",
                                 3 => "00000010000000010000010000010011",
                                 4 => "00000000000100000000011110010011",
                                 5 => "11111110111101000010011000100011",
                                 6 => "00000000001000000000011110010011",
                                 7 => "11111110111101000010010000100011",
                                 8 => "11111110110001000010011100000011",
                                 9 => "11111110100001000010011110000011",
                                 10 => "00000000111101110000011110110011",
                                 11 => "11111110111101000010001000100011",
                                 12 => "11111110010001000010011110000011",
                                 13 => "00000000000001111000010100010011",
                                 14 => "00000001110000010010000010000011",
                                 15 => "00000001100000010010010000000011",
                                 16 => "00000010000000010000000100010011",
                                 17 => "00000000000000001000000001100111",
                                 others => (others => '0'));

begin

    program_memory : process (all) is
    begin

        if (reset = '1') then
            instruction <= (others => '0');
            address_out <= (others => '0');
        elsif (rising_edge(clk)) then
            if (decode_enable = '0') then
                instruction <= prog_mem(to_integer(unsigned(address_in)));
                address_out <= address_in;
            end if;
        end if;

    end process program_memory;

end architecture rtl;
