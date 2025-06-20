library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pc_adder is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_pc_adder;

architecture tb of tb_pc_adder is

    signal reset     : std_logic := '0';
    signal halt      : std_logic := '0';
    signal input_1   : std_logic_vector(31 downto 0) := (others => '0');
    signal input_2   : std_logic_vector(31 downto 0) := (others => '0');
    signal sum       : std_logic_vector(31 downto 0) := (others => '0');
    signal check_sig : natural := 0;

    component pc_adder is
        port (
            reset   : in    std_logic;
            halt    : in    std_logic;
            input_1 : in    std_logic_vector(31 downto 0);
            input_2 : in    std_logic_vector(31 downto 0);
            sum     : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    pc_adder_instance : component pc_adder
        port map (
            reset   => reset,
            halt    => halt,
            input_1 => input_1,
            input_2 => input_2,
            sum     => sum
        );

    test_runner : process is
    begin

        test_runner_setup(runner, runner_cfg);
        show(get_logger(default_checker), display_handler, pass);

        test_cases_loop : while test_suite loop

            if run("test_sum_is_zero_when_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sum_is_zero_when_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                halt      <= '0';
                input_1   <= std_logic_vector(to_unsigned(23, 32));
                input_2   <= std_logic_vector(to_unsigned(33, 32));
                check_equal(sum, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing sum against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_sum_is_zero_when_halt_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sum_is_zero_when_halt_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '0';
                halt      <= '1';
                input_1   <= std_logic_vector(to_unsigned(23, 32));
                input_2   <= std_logic_vector(to_unsigned(33, 32));
                check_equal(sum, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing sum against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_adder_when_reset_and_halt_are_disabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_adder_when_reset_and_halt_are_disabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '0';
                halt      <= '0';
                input_1   <= std_logic_vector(to_unsigned(23, 32));
                input_2   <= std_logic_vector(to_unsigned(33, 32));
                wait for 10 us;
                check_equal(sum, std_logic_vector(to_unsigned(56, 32)),
                            "Comparing sum against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
