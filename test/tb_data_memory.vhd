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

    signal   clk               : std_logic := '0';
    signal   reset             : std_logic := '0';
    signal   address           : std_logic_vector(31 downto 0) := (others => '0');
    signal   write_data        : std_logic_vector(31 downto 0) := (others => '0');
    signal   write_enable      : std_logic := '0';
    signal   write_back_enable : std_logic := '0';
    signal   output            : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig         : natural := 0;
    constant CLK_PERIOD        : time := 2 us;

    type memory is array(1023 downto 0) of std_logic_vector(31 downto 0);

    component data_memory is
        port (
            clk               : in    std_logic;
            reset             : in    std_logic;
            address           : in    std_logic_vector(31 downto 0);
            write_data        : in    std_logic_vector(31 downto 0);
            write_enable      : in    std_logic;
            write_back_enable : in    std_logic;
            output            : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    data_memory_instance : component data_memory
        port map (
            clk               => clk,
            reset             => reset,
            address           => address,
            write_data        => write_data,
            write_enable      => write_enable,
            write_back_enable => write_back_enable,
            output            => output
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

        alias data_mem is <<signal .tb_data_memory.data_memory_instance.data_mem : memory>>;

    begin

        test_runner_setup(runner, runner_cfg);
        show(get_logger(default_checker), display_handler, pass);

        test_cases_loop : while test_suite loop

            if run("test_output_is_zero_if_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_output_is_zero_if_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset             <= '1';
                write_enable      <= '0';
                write_back_enable <= '0';
                address           <= std_logic_vector(to_unsigned(100, 32));
                write_data        <= std_logic_vector(to_unsigned(123, 32));
                wait for CLK_PERIOD * 2;
                check_equal(output, std_logic_vector(to_unsigned(0, 32)), "Comparing output against reference.");
                check_sig         <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_read_data") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_read_data");
                info("--------------------------------------------------------------------------------");
                reset             <= '1';
                write_enable      <= '0';
                write_back_enable <= '0';
                write_data        <= (others => '0');
                data_mem(12)      <= force std_logic_vector(to_unsigned(100, 32));
                address           <= std_logic_vector(to_unsigned(12, 32));
                wait for CLK_PERIOD * 2;
                reset             <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(output, std_logic_vector(to_unsigned(100, 32)), "Comparing output against reference.");
                check_sig         <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_write_data") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_write_data");
                info("--------------------------------------------------------------------------------");
                reset             <= '1';
                wait for CLK_PERIOD * 2;
                reset             <= '0';
                write_enable      <= '1';
                write_back_enable <= '1';
                write_data        <= std_logic_vector(to_unsigned(155, 32));
                address           <= std_logic_vector(to_unsigned(25, 32));
                wait for CLK_PERIOD * 2;
                write_enable      <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(data_mem(25), std_logic_vector(to_unsigned(155, 32)),
                            "Comparing contents of data_mem against reference.");
                check_sig         <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
