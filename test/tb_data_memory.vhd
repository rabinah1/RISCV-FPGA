library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_data_memory is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_data_memory;

architecture tb of tb_data_memory is

    signal   clk          : std_logic := '0';
    signal   reset        : std_logic := '0';
    signal   address      : std_logic_vector(31 downto 0) := (others => '0');
    signal   data_in      : std_logic_vector(31 downto 0) := (others => '0');
    signal   write_enable : std_logic := '0';
    signal   data_out     : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig    : natural := 0;
    constant CLK_PERIOD   : time := 250 us;

    component data_memory is
        port (
            clk          : in    std_logic;
            reset        : in    std_logic;
            address      : in    std_logic_vector(31 downto 0);
            data_in      : in    std_logic_vector(31 downto 0);
            write_enable : in    std_logic;
            data_out     : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    data_memory_instance : component data_memory
        port map (
            clk          => clk,
            reset        => reset,
            address      => address,
            data_in      => data_in,
            write_enable => write_enable,
            data_out     => data_out
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

            if run("test_data_out_is_zero_if_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_data_out_is_zero_if_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset        <= '1';
                write_enable <= '0';
                address      <= std_logic_vector(to_unsigned(100, 32));
                data_in      <= std_logic_vector(to_unsigned(123, 32));
                wait for CLK_PERIOD * 2;
                check_equal(data_out, std_logic_vector(to_unsigned(0, 32)), "Comparing data_out against reference.");
                check_sig    <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_read_and_write") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_read_and_write");
                info("--------------------------------------------------------------------------------");
                reset        <= '1';
                wait for CLK_PERIOD * 2;
                reset        <= '0';
                write_enable <= '1';
                data_in      <= std_logic_vector(to_unsigned(155, 32));
                address      <= std_logic_vector(to_unsigned(25, 32));
                wait for CLK_PERIOD * 2;
                write_enable <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(data_out, std_logic_vector(to_unsigned(155, 32)), "Comparing data_out against reference.");
                check_sig    <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
