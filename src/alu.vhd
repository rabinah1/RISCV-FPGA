library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_pkg.all;
use work.arithmetic_pkg.all;

entity alu is
    port (
        clk      : in    std_logic;
        reset    : in    std_logic;
        enable   : in    std_logic;
        input_1  : in    std_logic_vector(31 downto 0);
        input_2  : in    std_logic_vector(31 downto 0);
        pc_in    : in    std_logic_vector(31 downto 0);
        operator : in    std_logic_vector(10 downto 0);
        halt     : in    std_logic;
        result   : out   std_logic_vector(31 downto 0)
    );
end entity alu;

architecture rtl of alu is

begin

    alu : process (all) is
    begin

        if (reset = '1' or halt = '1') then
            result <= (others => '0');
        elsif (rising_edge(clk)) then
            if (enable = '1') then

                case operator is

                    when ADD =>

                        result <= add_signed(input_1, input_2);

                    when ADDI =>

                        result <= add_signed(input_1, input_2);

                    when MY_SUB =>

                        result <= sub_signed(input_1, input_2);

                    when MY_SLL =>

                        result <= shift_left_logical(input_1, input_2);

                    when SLLI =>

                        result <= shift_left_logical(input_1, input_2);

                    when SLT =>

                        result <= is_less_than_signed(input_1, input_2);

                    when SLTI =>

                        result <= is_less_than_signed(input_1, input_2);

                    when SLTU =>

                        result <= is_less_than_unsigned(input_1, input_2);

                    when SLTIU =>

                        result <= is_less_than_unsigned(input_1, input_2);

                    when MY_XOR =>

                        result <= input_1 xor input_2;

                    when XORI =>

                        result <= input_1 xor input_2;

                    when MY_SRL =>

                        result <= shift_right_logical(input_1, input_2);

                    when SRLI =>

                        result <= shift_right_logical(input_1, input_2);

                    when MY_OR =>

                        result <= input_1 or input_2;

                    when ORI =>

                        result <= input_1 or input_2;

                    when MY_AND =>

                        result <= input_1 and input_2;

                    when ANDI =>

                        result <= input_1 and input_2;

                    when LW =>

                        -- input_2 is sign extended immediate, is this okay?
                        result <= add_signed(input_1, input_2);

                    when SW =>

                        -- input_2 is sign extended immediate, is this okay?
                        result <= add_signed(input_1, input_2);

                    when BEQ =>

                        result <= is_equal(input_1, input_2);

                    when BNE =>

                        result <= is_not_equal(input_1, input_2);

                    when BLT =>

                        result <= is_less_than_signed(input_1, input_2);

                    when BGE =>

                        result <= is_greater_equal_signed(input_1, input_2);

                    when BLTU =>

                        result <= is_less_than_unsigned(input_1, input_2);

                    when BGEU =>

                        result <= is_greater_equal_unsigned(input_1, input_2);

                    when JAL =>

                        result <= std_logic_vector(signed(word_addr_to_byte_addr(pc_in)) + to_signed(4, 32));

                    when JALR =>

                        result <= std_logic_vector(signed(word_addr_to_byte_addr(pc_in)) + to_signed(4, 32));

                    when LUI =>

                        result <= input_2;

                    when AUIPC =>

                        result <= std_logic_vector(signed(word_addr_to_byte_addr(pc_in)) + signed(input_2));

                    when others =>

                        result <= (others => '0');

                end case;

            end if;
        end if;

    end process alu;

end architecture rtl;
