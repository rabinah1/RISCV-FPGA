library ieee;
use ieee.std_logic_1164.all;

package instruction_types_package is

    constant TYPE_R           : std_logic_vector(6 downto 0) := "0110011";
    constant TYPE_I           : std_logic_vector(6 downto 0) := "0010011";
    constant TYPE_LOAD        : std_logic_vector(6 downto 0) := "0000011";
    constant TYPE_STORE       : std_logic_vector(6 downto 0) := "0100011";
    constant TYPE_CONDITIONAL : std_logic_vector(6 downto 0) := "1100011";
    constant TYPE_JAL         : std_logic_vector(6 downto 0) := "1101111";
    constant TYPE_JALR        : std_logic_vector(6 downto 0) := "1100111";
    constant TYPE_U           : std_logic_vector(6 downto 0) := "0110111";

end package instruction_types_package;
