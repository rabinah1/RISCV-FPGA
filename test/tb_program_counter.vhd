library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_program_counter is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_program_counter;

architecture tb of tb_program_counter is

    signal   clk           : std_logic := '0';
    signal   reset         : std_logic := '0';
    signal   start_program : std_logic := '0';
    signal   address_in    : std_logic_vector(31 downto 0) := (others => '0');
    signal   address_out   : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig     : natural := 0;
    constant CLK_PERIOD    : time := 2 us;

    component program_counter is
        port (
            clk           : in    std_logic;
            reset         : in    std_logic;
            start_program : in    std_logic;
            address_in    : in    std_logic_vector(31 downto 0);
            address_out   : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    program_counter_instance : component program_counter
        port map (
            clk           => clk,
            reset         => reset,
            start_program => start_program,
            address_in    => address_in,
            address_out   => address_out
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

            if run("test_output_address_is_zero_if_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_output_address_is_zero_if_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset         <= '1';
                start_program <= '1';
                address_in    <= std_logic_vector(to_unsigned(60, 32));
                wait for CLK_PERIOD * 2;
                check_equal(address_out, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing address_out against reference.");
                check_sig     <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_output_address_is_zero_if_start_program_is_zero") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_output_address_is_zero_if_start_program_is_zero");
                info("--------------------------------------------------------------------------------");
                reset         <= '0';
                start_program <= '0';
                address_in    <= std_logic_vector(to_unsigned(60, 32));
                wait for CLK_PERIOD * 2;
                check_equal(address_out, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing address_out against reference.");
                check_sig     <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_output_address_follows_input_address_if_reset_is_disabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_output_address_follows_input_address_if_reset_is_disabled");
                info("--------------------------------------------------------------------------------");
                reset         <= '1';
                wait for CLK_PERIOD * 2;
                reset         <= '0';
                start_program <= '1';
                address_in    <= std_logic_vector(to_unsigned(123, 32));
                wait for CLK_PERIOD * 2;
                check_equal(address_out, address_in, "Comparing address_out against reference.");
                check_sig     <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
