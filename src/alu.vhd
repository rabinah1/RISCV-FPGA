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
        operator : in    std_logic_vector(10 downto 0);
        result   : out   std_logic_vector(31 downto 0)
    );
end entity alu;

architecture rtl of alu is

begin

    alu : process (all) is
    begin

        if (reset = '1') then
            result <= (others => '0');
        elsif (rising_edge(clk)) then
            if (enable = '1') then

                case operator is

                    when ADD =>

                        result <= std_logic_vector(signed(input_1) + signed(input_2));

                    when ADDI =>

                        result <= std_logic_vector(signed(input_1) + signed(input_2));

                    when MY_SUB =>

                        result <= std_logic_vector(signed(input_1) - signed(input_2));

                    when MY_SLL =>

                        result <= std_logic_vector(shift_left(unsigned(input_1), to_integer(unsigned(input_2))));

                    when SLLI =>

                        result <= std_logic_vector(shift_left(unsigned(input_1), to_integer(unsigned(input_2))));

                    when SLT =>

                        if (signed(input_1) < signed(input_2)) then
                            result <= (0 => '1', others => '0');
                        else
                            result <= (others => '0');
                        end if;

                    when SLTI =>

                        if (signed(input_1) < signed(input_2)) then
                            result <= (0 => '1', others => '0');
                        else
                            result <= (others => '0');
                        end if;

                    when SLTU =>

                        if (unsigned(input_1) < unsigned(input_2)) then
                            result <= (0 => '1', others => '0');
                        else
                            result <= (others => '0');
                        end if;

                    when SLTIU =>

                        if (unsigned(input_1) < unsigned(input_2)) then
                            result <= (0 => '1', others => '0');
                        else
                            result <= (others => '0');
                        end if;

                    when MY_XOR =>

                        result <= input_1 xor input_2;

                    when XORI =>

                        result <= input_1 xor input_2;

                    when MY_SRL =>

                        result <= std_logic_vector(shift_right(unsigned(input_1), to_integer(unsigned(input_2))));

                    when SRLI =>

                        result <= std_logic_vector(shift_right(unsigned(input_1), to_integer(unsigned(input_2))));

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
                        result <= std_logic_vector(signed(input_1) + signed(input_2));

                    when SW =>

                        -- input_2 is sign extended immediate, is this okay?
                        result <= std_logic_vector(signed(input_1) + signed(input_2));

                    when BEQ =>

                        if (unsigned(input_1) = unsigned(input_2)) then
                            result <= std_logic_vector(to_unsigned(1, 32));
                        else
                            result <= (others => '0');
                        end if;

                    when BNE =>

                        if (unsigned(input_1) /= unsigned(input_2)) then
                            result <= std_logic_vector(to_unsigned(1, 32));
                        else
                            result <= (others => '0');
                        end if;

                    when BLT =>

                        if (signed(input_1) < signed(input_2)) then
                            result <= std_logic_vector(to_unsigned(1, 32));
                        else
                            result <= (others => '0');
                        end if;

                    when BGE =>

                        if (signed(input_1) >= signed(input_2)) then
                            result <= std_logic_vector(to_unsigned(1, 32));
                        else
                            result <= (others => '0');
                        end if;

                    when BLTU =>

                        if (unsigned(input_1) < unsigned(input_2)) then
                            result <= std_logic_vector(to_unsigned(1, 32));
                        else
                            result <= (others => '0');
                        end if;

                    when BGEU =>

                        if (unsigned(input_1) >= unsigned(input_2)) then
                            result <= std_logic_vector(to_unsigned(1, 32));
                        else
                            result <= (others => '0');
                        end if;

                    when JAL =>

                        result <= std_logic_vector(unsigned(input_2) + to_unsigned(1, 32));

                    when JALR =>

                        result <= std_logic_vector(unsigned(input_2) + to_unsigned(1, 32));

                    when LUI =>

                        result <= input_2;

                    when others =>

                        result <= (others => '0');

                end case;

            end if;
        end if;

    end process alu;

end architecture rtl;
