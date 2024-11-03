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

    signal   clk        : std_logic := '0';
    signal   reset      : std_logic := '0';
    signal   control    : std_logic := '0';
    signal   alu_res    : std_logic_vector(31 downto 0) := (others => '0');
    signal   dmem_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal   data_out   : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig  : natural := 0;
    constant CLK_PERIOD : time := 250 us;

    component writeback_mux is
        port (
            clk       : in    std_logic;
            reset     : in    std_logic;
            control   : in    std_logic;
            alu_res   : in    std_logic_vector(31 downto 0);
            dmem_data : in    std_logic_vector(31 downto 0);
            data_out  : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    writeback_mux_instance : component writeback_mux
        port map (
            clk       => clk,
            reset     => reset,
            control   => control,
            alu_res   => alu_res,
            dmem_data => dmem_data,
            data_out  => data_out
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
                reset     <= '1';
                control   <= '0';
                alu_res   <= std_logic_vector(to_unsigned(123, 32));
                dmem_data <= std_logic_vector(to_unsigned(456, 32));
                wait for CLK_PERIOD * 2;
                check_equal(data_out, std_logic_vector(to_unsigned(0, 32)), "Comparing data_out against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_data_out_is_alu_res_when_control_is_zero") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_data_out_is_alu_res_when_control_is_zero");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                control   <= '0';
                alu_res   <= std_logic_vector(to_unsigned(123, 32));
                dmem_data <= std_logic_vector(to_unsigned(456, 32));
                wait for CLK_PERIOD * 2;
                check_equal(data_out, alu_res, "Comparing data_out against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_data_out_is_dmem_data_in_when_control_is_one") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_data_out_is_dmem_data_in_when_control_is_one");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                control   <= '1';
                alu_res   <= std_logic_vector(to_unsigned(123, 32));
                dmem_data <= std_logic_vector(to_unsigned(456, 32));
                wait for CLK_PERIOD * 2;
                check_equal(data_out, dmem_data, "Comparing data_out against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
