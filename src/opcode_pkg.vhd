library ieee;
use ieee.std_logic_1164.all;

package opcode_pkg is

    constant ADD    : std_logic_vector(10 downto 0) := "01100110000";
    constant ADDI   : std_logic_vector(10 downto 0) := "00100110000";
    constant MY_SUB : std_logic_vector(10 downto 0) := "01100111000";
    constant MY_SLL : std_logic_vector(10 downto 0) := "01100110001";
    constant SLLI   : std_logic_vector(10 downto 0) := "00100110001";
    constant SLT    : std_logic_vector(10 downto 0) := "01100110010";
    constant SLTI   : std_logic_vector(10 downto 0) := "00100110010";
    constant SLTU   : std_logic_vector(10 downto 0) := "01100110011";
    constant SLTIU  : std_logic_vector(10 downto 0) := "00100110011";
    constant MY_XOR : std_logic_vector(10 downto 0) := "01100110100";
    constant XORI   : std_logic_vector(10 downto 0) := "00100110100";
    constant MY_SRL : std_logic_vector(10 downto 0) := "01100110101";
    constant SRLI   : std_logic_vector(10 downto 0) := "00100110101";
    constant MY_OR  : std_logic_vector(10 downto 0) := "01100110110";
    constant ORI    : std_logic_vector(10 downto 0) := "00100110110";
    constant MY_AND : std_logic_vector(10 downto 0) := "01100110111";
    constant ANDI   : std_logic_vector(10 downto 0) := "00100110111";
    constant LW     : std_logic_vector(10 downto 0) := "00000110010";
    constant SW     : std_logic_vector(10 downto 0) := "01000110010";
    constant BEQ    : std_logic_vector(10 downto 0) := "11000110000";
    constant BNE    : std_logic_vector(10 downto 0) := "11000110001";
    constant BLT    : std_logic_vector(10 downto 0) := "11000110100";
    constant BGE    : std_logic_vector(10 downto 0) := "11000110101";
    constant BLTU   : std_logic_vector(10 downto 0) := "11000110110";
    constant BGEU   : std_logic_vector(10 downto 0) := "11000110111";

end package opcode_pkg;
