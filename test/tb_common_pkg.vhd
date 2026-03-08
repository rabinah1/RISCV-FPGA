library ieee;
use ieee.std_logic_1164.all;

package tb_common_pkg is

    procedure clk_gen (
        signal clk       : out std_logic;
        signal check_sig : in natural;
        clk_period       : in time
    );

end package tb_common_pkg;

package body tb_common_pkg is

    procedure clk_gen (
        signal clk       : out std_logic;
        signal check_sig : in natural;
        clk_period       : in time
    ) is
    begin

        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;

        if (check_sig = 1) then
            wait;
        end if;

    end procedure clk_gen;

end package body tb_common_pkg;
