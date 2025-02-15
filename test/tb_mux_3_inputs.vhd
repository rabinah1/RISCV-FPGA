library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_mux_3_inputs is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_mux_3_inputs;

architecture tb of tb_mux_3_inputs is

    signal   clk        : std_logic := '0';
    signal   reset      : std_logic := '0';
    signal   control    : std_logic_vector(1 downto 0) := (others => '0');
    signal   input_1    : std_logic_vector(31 downto 0) := (others => '0');
    signal   input_2    : std_logic_vector(31 downto 0) := (others => '0');
    signal   input_3    : std_logic_vector(31 downto 0) := (others => '0');
    signal   output     : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig  : natural := 0;
    constant CLK_PERIOD : time := 20 ns;

    component mux_3_inputs is
        port (
            clk     : in    std_logic;
            reset   : in    std_logic;
            control : in    std_logic_vector(1 downto 0);
            input_1 : in    std_logic_vector(31 downto 0);
            input_2 : in    std_logic_vector(31 downto 0);
            input_3 : in    std_logic_vector(31 downto 0);
            output  : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    mux_3_inputs_instance : component mux_3_inputs
        port map (
            clk     => clk,
            reset   => reset,
            control => control,
            input_1 => input_1,
            input_2 => input_2,
            input_3 => input_3,
            output  => output
        );

    clk_process : process is
    begin

        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;

        if (check_sig = 1) then
            wait;
        end if;

    end process clk_process;

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
                control   <= "01";
                input_1   <= std_logic_vector(to_unsigned(123, 32));
                input_2   <= std_logic_vector(to_unsigned(456, 32));
                input_3   <= std_logic_vector(to_unsigned(789, 32));
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
                control   <= "00";
                input_1   <= std_logic_vector(to_unsigned(123, 32));
                input_2   <= std_logic_vector(to_unsigned(456, 32));
                input_3   <= std_logic_vector(to_unsigned(789, 32));
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
                control   <= "01";
                input_1   <= std_logic_vector(to_unsigned(123, 32));
                input_2   <= std_logic_vector(to_unsigned(456, 32));
                input_3   <= std_logic_vector(to_unsigned(789, 32));
                wait for CLK_PERIOD * 2;
                check_equal(output, input_2, "Comparing output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_output_is_input_3_when_control_is_two") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_output_is_input_3_when_control_is_two");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                control   <= "10";
                input_1   <= std_logic_vector(to_unsigned(123, 32));
                input_2   <= std_logic_vector(to_unsigned(456, 32));
                input_3   <= std_logic_vector(to_unsigned(789, 32));
                wait for CLK_PERIOD * 2;
                check_equal(output, input_3, "Comparing output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
