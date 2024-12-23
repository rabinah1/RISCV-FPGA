library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.opcode_pkg.all;

entity alu is
    port (
        clk        : in    std_logic;
        reset      : in    std_logic;
        input_1    : in    std_logic_vector(31 downto 0);
        input_2    : in    std_logic_vector(31 downto 0);
        operand    : in    std_logic_vector(10 downto 0);
        alu_output : out   std_logic_vector(31 downto 0)
    );
end entity alu;

architecture rtl of alu is

begin

    alu : process (all) is
    begin

        if (reset = '1') then
            alu_output <= (others => '0');
        elsif (rising_edge(clk)) then

            case operand is

                when ADD =>

                    alu_output <= input_1 + input_2;

                when ADDI =>

                    alu_output <= input_1 + input_2;

                when MY_SUB =>

                    alu_output <= input_1 - input_2;

                when MY_SLL =>

                    alu_output <= std_logic_vector(shift_left(unsigned(input_1), to_integer(unsigned(input_2))));

                when SLLI =>

                    alu_output <= std_logic_vector(shift_left(unsigned(input_1), to_integer(unsigned(input_2))));

                when SLT =>

                    if (signed(input_1) < signed(input_2)) then
                        alu_output <= (0 => '1', others => '0');
                    else
                        alu_output <= (others => '0');
                    end if;

                when SLTI =>

                    if (signed(input_1) < signed(input_2)) then
                        alu_output <= (0 => '1', others => '0');
                    else
                        alu_output <= (others => '0');
                    end if;

                when SLTU =>

                    if (unsigned(input_1) < unsigned(input_2)) then
                        alu_output <= (0 => '1', others => '0');
                    else
                        alu_output <= (others => '0');
                    end if;

                when SLTIU =>

                    if (unsigned(input_1) < unsigned(input_2)) then
                        alu_output <= (0 => '1', others => '0');
                    else
                        alu_output <= (others => '0');
                    end if;

                when MY_XOR =>

                    alu_output <= input_1 xor input_2;

                when XORI =>

                    alu_output <= input_1 xor input_2;

                when MY_SRL =>

                    alu_output <= std_logic_vector(shift_right(unsigned(input_1), to_integer(unsigned(input_2))));

                when SRLI =>

                    alu_output <= std_logic_vector(shift_right(unsigned(input_1), to_integer(unsigned(input_2))));

                when MY_OR =>

                    alu_output <= input_1 or input_2;

                when ORI =>

                    alu_output <= input_1 or input_2;

                when MY_AND =>

                    alu_output <= input_1 and input_2;

                when ANDI =>

                    alu_output <= input_1 and input_2;

                when LW =>

                    -- input_2 is sign extended immediate, is this okay?
                    alu_output <= input_1 + input_2;

                when SW =>

                    -- input_2 is sign extended immediate, is this okay?
                    alu_output <= input_1 + input_2;

                when BEQ =>

                    if (unsigned(input_1) = unsigned(input_2)) then
                        alu_output <= std_logic_vector(to_unsigned(1, 32));
                    else
                        alu_output <= (others => '0');
                    end if;

                when BNE =>

                    if (unsigned(input_1) /= unsigned(input_2)) then
                        alu_output <= std_logic_vector(to_unsigned(1, 32));
                    else
                        alu_output <= (others => '0');
                    end if;

                when BLT =>

                    if (signed(input_1) < signed(input_2)) then
                        alu_output <= std_logic_vector(to_unsigned(1, 32));
                    else
                        alu_output <= (others => '0');
                    end if;

                when BGE =>

                    if (signed(input_1) >= signed(input_2)) then
                        alu_output <= std_logic_vector(to_unsigned(1, 32));
                    else
                        alu_output <= (others => '0');
                    end if;

                when BLTU =>

                    if (unsigned(input_1) < unsigned(input_2)) then
                        alu_output <= std_logic_vector(to_unsigned(1, 32));
                    else
                        alu_output <= (others => '0');
                    end if;

                when BGEU =>

                    if (unsigned(input_1) >= unsigned(input_2)) then
                        alu_output <= std_logic_vector(to_unsigned(1, 32));
                    else
                        alu_output <= (others => '0');
                    end if;

                when JAL =>

                    alu_output <= input_2 + std_logic_vector(to_unsigned(1, 32));

                when JALR =>

                    alu_output <= input_2 + std_logic_vector(to_unsigned(1, 32));

                when others =>

                    alu_output <= (others => '0');

            end case;

        end if;

    end process alu;

end architecture rtl;
