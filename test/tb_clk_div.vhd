library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_clk_div is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_clk_div;

architecture tb of tb_clk_div is

    signal   clk_in     : std_logic := '0';
    signal   reset      : std_logic := '0';
    signal   clk_500khz : std_logic := '0';
    signal   check_sig  : natural := 0;
    constant CLK_PERIOD : time := 20 ns;

    component clk_div is
        port (
            clk_in     : in    std_logic;
            reset      : in    std_logic;
            clk_500khz : out   std_logic
        );
    end component;

begin

    clk_div_instance : component clk_div
        port map (
            clk_in     => clk_in,
            reset      => reset,
            clk_500khz => clk_500khz
        );

    clk_process : process is
    begin

        clk_in <= '0';
        wait for CLK_PERIOD / 2;
        clk_in <= '1';
        wait for CLK_PERIOD / 2;

        if (check_sig = 1) then
            wait;
        end if;

    end process clk_process;

    test_runner : process is

        alias counter is <<signal .tb_clk_div.clk_div_instance.counter : integer range 0 to 49>>;

    begin

        test_runner_setup(runner, runner_cfg);
        show(get_logger(default_checker), display_handler, pass);

        test_cases_loop : while test_suite loop

            if run("test_signals_are_correct_when_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_signals_are_correct_when_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                check_equal(clk_500khz, '0');
                check_equal(counter, 0);
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_counter_is_increased") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_counter_is_increased");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 12;
                check_equal(clk_500khz, '0');
                check_equal(counter, 12);
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_500khz_clock_is_toggled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_500khz_clock_is_toggled");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 50;
                check_equal(clk_500khz, '1');
                check_equal(counter, 0);
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
