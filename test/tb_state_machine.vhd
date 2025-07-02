library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use work.states_package.all;

entity tb_state_machine is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_state_machine;

architecture tb of tb_state_machine is

    signal   clk               : std_logic := '0';
    signal   reset             : std_logic := '0';
    signal   halt              : std_logic := '0';
    signal   fetch_enable      : std_logic := '0';
    signal   decode_enable     : std_logic := '0';
    signal   execute_enable    : std_logic := '0';
    signal   write_back_enable : std_logic := '0';
    signal   check_sig         : natural := 0;
    constant CLK_PERIOD        : time := 2 us;

    component state_machine is
        port (
            clk               : in    std_logic;
            reset             : in    std_logic;
            halt              : in    std_logic;
            fetch_enable      : out   std_logic;
            decode_enable     : out   std_logic;
            execute_enable    : out   std_logic;
            write_back_enable : out   std_logic
        );
    end component;

begin

    state_machine_instance : component state_machine
        port map (
            clk               => clk,
            reset             => reset,
            halt              => halt,
            fetch_enable      => fetch_enable,
            decode_enable     => decode_enable,
            execute_enable    => execute_enable,
            write_back_enable => write_back_enable
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

        alias state      is <<signal .tb_state_machine.state_machine_instance.state : instruction_state>>;
        alias next_state is <<signal .tb_state_machine.state_machine_instance.next_state : instruction_state>>;

    begin

        test_runner_setup(runner, runner_cfg);
        show(get_logger(default_checker), display_handler, pass);

        test_cases_loop : while test_suite loop

            if run("test_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD;
                check_equal(fetch_enable, '0', "Comparing fetch_enable against reference.");
                check_equal(decode_enable, '0', "Comparing decode_enable against reference.");
                check_equal(execute_enable, '0', "Comparing execute_enable against reference.");
                check_equal(write_back_enable, '0', "Comparing write_back_enable against reference.");
                assert state = fetch;
                assert next_state = fetch;
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_fetch_state") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_fetch_state");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                state     <= force fetch;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(fetch_enable, '1', "Comparing fetch_enable against reference.");
                check_equal(decode_enable, '0', "Comparing decode_enable against reference.");
                check_equal(execute_enable, '0', "Comparing execute_enable against reference.");
                check_equal(write_back_enable, '0', "Comparing write_back_enable against reference.");
                assert next_state = decode;
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_state") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_state");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                state     <= force decode;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(fetch_enable, '0', "Comparing fetch_enable against reference.");
                check_equal(decode_enable, '1', "Comparing decode_enable against reference.");
                check_equal(execute_enable, '0', "Comparing execute_enable against reference.");
                check_equal(write_back_enable, '0', "Comparing write_back_enable against reference.");
                assert next_state = execute;
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_execute_state") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_execute_state");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                state     <= force execute;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(fetch_enable, '0', "Comparing fetch_enable against reference.");
                check_equal(decode_enable, '0', "Comparing decode_enable against reference.");
                check_equal(execute_enable, '1', "Comparing execute_enable against reference.");
                check_equal(write_back_enable, '0', "Comparing write_back_enable against reference.");
                assert next_state = write_back;
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_write_back_state") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_write_back_state");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                state     <= force write_back;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(fetch_enable, '0', "Comparing fetch_enable against reference.");
                check_equal(decode_enable, '0', "Comparing decode_enable against reference.");
                check_equal(execute_enable, '0', "Comparing execute_enable against reference.");
                check_equal(write_back_enable, '1', "Comparing write_back_enable against reference.");
                assert next_state = fetch;
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
