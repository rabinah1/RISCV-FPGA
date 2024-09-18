library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity instruction_decoder is
    port (
        clk : in std_logic;
        reset : in std_logic;
        instruction_in : in std_logic_vector(31 downto 0);
        rs1 : out std_logic_vector(4 downto 0);
        rs2 : out std_logic_vector(4 downto 0);
        rd : out std_logic_vector(4 downto 0);
        write : out std_logic;
        alu_operation : out std_logic_vector(3 downto 0);
        alu_source : out std_logic;
        immediate : out std_logic_vector(31 downto 0);
        load : out std_logic;
        store : out std_logic
    );
end entity instruction_decoder;

architecture rtl of instruction_decoder is
begin

    instruction_decoder : process (all) is
    begin

        if (reset = '1') then
            rs1 <= (others => '0');
            rs2 <= (others => '0');
            rd <= (others => '0');
            write <= '0';
            alu_operation <= (others => '0');
            alu_source <= '0';
            immediate <= (others => '0');
            load <= '0';
            store <= '0';
        elsif (rising_edge(clk)) then
            immediate <= instruction_in; -- placeholder
        end if;

    end process instruction_decoder;

end architecture rtl;
