library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_pkg.all;

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

  subtype word_t is std_logic_vector(31 downto 0);

    constant ZERO_WORD : word_t := (others => '0');
    constant ONE_WORD  : word_t := std_logic_vector(to_unsigned(1, word_t'length));

    function signed_add (
        in_1 : word_t;
        in_2 : word_t
    ) return word_t is
    begin

        return std_logic_vector(signed(in_1) + signed(in_2));

    end function signed_add;

    function boolean_to_word (
        condition : boolean
    ) return word_t is
    begin

        if (condition) then
            return ONE_WORD;
        else
            return ZERO_WORD;
        end if;

    end function boolean_to_word;

begin

    alu : process (all) is
    begin

        if (reset = '1' or halt = '1') then
            result <= ZERO_WORD;
        elsif (rising_edge(clk)) then
            if (enable = '1') then

                case operator is

                    when ADD | ADDI | LW | SW =>

                        -- input_2 is sign extended immediate for LW/SW
                        result <= signed_add(input_1, input_2);

                    when MY_SUB =>

                        result <= std_logic_vector(signed(input_1) - signed(input_2));

                    when MY_SLL | SLLI =>

                        result <= std_logic_vector(shift_left(unsigned(input_1), to_integer(unsigned(input_2))));

                    when SLT | SLTI =>

                        result <= boolean_to_word(signed(input_1) < signed(input_2));

                    when SLTU | SLTIU =>

                        result <= boolean_to_word(unsigned(input_1) < unsigned(input_2));

                    when MY_XOR | XORI =>

                        result <= input_1 xor input_2;

                    when MY_SRL | SRLI =>

                        result <= std_logic_vector(shift_right(unsigned(input_1), to_integer(unsigned(input_2))));

                    when MY_OR | ORI =>

                        result <= input_1 or input_2;

                    when MY_AND | ANDI =>

                        result <= input_1 and input_2;

                    when BEQ =>

                        result <= boolean_to_word(unsigned(input_1) = unsigned(input_2));

                    when BNE =>

                        result <= boolean_to_word(unsigned(input_1) /= unsigned(input_2));

                    when BLT =>

                        result <= boolean_to_word(signed(input_1) < signed(input_2));

                    when BGE =>

                        result <= boolean_to_word(signed(input_1) >= signed(input_2));

                    when BLTU =>

                        result <= boolean_to_word(unsigned(input_1) < unsigned(input_2));

                    when BGEU =>

                        result <= boolean_to_word(unsigned(input_1) >= unsigned(input_2));

                    when JAL =>

                        result <= std_logic_vector(unsigned(pc_in(29 downto 0) & "00") + to_unsigned(4, word_t'length));

                    when JALR =>

                        result <= std_logic_vector(unsigned(pc_in(29 downto 0) & "00") + to_unsigned(4, word_t'length));

                    when LUI =>

                        result <= input_2;

                    when AUIPC =>

                        result <= std_logic_vector(unsigned(pc_in(29 downto 0) & "00") + unsigned(input_2));

                    when others =>

                        result <= ZERO_WORD;

                end case;

            end if;
        end if;

    end process alu;

end architecture rtl;
