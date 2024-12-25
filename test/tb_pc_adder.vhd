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

    signal   clk        : std_logic := '0';
    signal   reset      : std_logic := '0';
    signal   input_1    : std_logic_vector(31 downto 0) := (others => '0');
    signal   input_2    : std_logic_vector(31 downto 0) := (others => '0');
    signal   sum        : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig  : natural := 0;
    constant CLK_PERIOD : time := 250 us;

    component pc_adder is
        port (
            clk     : in    std_logic;
            reset   : in    std_logic;
            input_1 : in    std_logic_vector(31 downto 0);
            input_2 : in    std_logic_vector(31 downto 0);
            sum     : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    pc_adder_instance : component pc_adder
        port map (
            clk     => clk,
            reset   => reset,
            input_1 => input_1,
            input_2 => input_2,
            sum     => sum
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

            if run("test_sum_is_zero_when_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sum_is_zero_when_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(123, 32));
                input_2   <= std_logic_vector(to_unsigned(333, 32));
                wait for CLK_PERIOD * 2;
                check_equal(sum, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing sum against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_adder_when_reset_is_disabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_adder_when_reset_is_disabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                input_1   <= std_logic_vector(to_unsigned(123, 32));
                input_2   <= std_logic_vector(to_unsigned(333, 32));
                wait for CLK_PERIOD * 2;
                check_equal(sum, std_logic_vector(to_unsigned(456, 32)),
                            "Comparing sum against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
