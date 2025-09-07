library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_writeback_mux is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_writeback_mux;

architecture tb of tb_writeback_mux is

    signal   reset      : std_logic := '0';
    signal   control    : std_logic := '0';
    signal   input_1    : std_logic_vector(31 downto 0) := (others => '0');
    signal   input_2    : std_logic_vector(31 downto 0) := (others => '0');
    signal   halt       : std_logic := '0';
    signal   output     : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig  : natural := 0;
    constant CLK_PERIOD : time := 2 us;

    component writeback_mux is
        port (
            reset   : in    std_logic;
            control : in    std_logic;
            input_1 : in    std_logic_vector(31 downto 0);
            input_2 : in    std_logic_vector(31 downto 0);
            halt    : in    std_logic;
            output  : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    writeback_mux_instance : component writeback_mux
        port map (
            reset   => reset,
            control => control,
            input_1 => input_1,
            input_2 => input_2,
            halt    => halt,
            output  => output
        );

    test_runner : process is
    begin

        test_runner_setup(runner, runner_cfg);
        show(get_logger(default_checker), display_handler, pass);

        test_cases_loop : while test_suite loop

            if run("test_output_is_zero_if_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_output_is_zero_if_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                control   <= '0';
                halt      <= '0';
                input_1   <= std_logic_vector(to_unsigned(123, 32));
                input_2   <= std_logic_vector(to_unsigned(456, 32));
                wait for CLK_PERIOD * 2;
                check_equal(output, std_logic_vector(to_unsigned(0, 32)), "Comparing output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_output_is_input_1_when_control_is_zero") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_output_is_input_1_when_control_is_zero");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                control   <= '0';
                halt      <= '0';
                input_1   <= std_logic_vector(to_unsigned(123, 32));
                input_2   <= std_logic_vector(to_unsigned(456, 32));
                wait for CLK_PERIOD * 2;
                check_equal(output, input_1, "Comparing output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_output_is_input_2_when_control_is_one") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_output_is_input_2_when_control_is_one");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                control   <= '1';
                halt      <= '0';
                input_1   <= std_logic_vector(to_unsigned(123, 32));
                input_2   <= std_logic_vector(to_unsigned(456, 32));
                wait for CLK_PERIOD * 2;
                check_equal(output, input_2, "Comparing output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
