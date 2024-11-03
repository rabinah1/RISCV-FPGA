library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pc_offset_mux is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_pc_offset_mux;

architecture tb of tb_pc_offset_mux is

    signal   clk        : std_logic := '0';
    signal   reset      : std_logic := '0';
    signal   control    : std_logic := '0';
    signal   offset_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal   offset_out : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig  : natural := 0;
    constant CLK_PERIOD : time := 250 us;

    component pc_offset_mux is
        port (
            clk        : in    std_logic;
            reset      : in    std_logic;
            control    : in    std_logic;
            offset_in  : in    std_logic_vector(31 downto 0);
            offset_out : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    pc_offset_mux_instance : component pc_offset_mux
        port map (
            clk        => clk,
            reset      => reset,
            control    => control,
            offset_in  => offset_in,
            offset_out => offset_out
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

            if run("test_offset_out_is_zero_if_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_offset_out_is_zero_if_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                control   <= '0';
                offset_in <= std_logic_vector(to_unsigned(123, 32));
                wait for CLK_PERIOD * 2;
                check_equal(offset_out, std_logic_vector(to_unsigned(0, 32)), "Comparing offset_out against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_offset_out_is_one_when_control_is_zero") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_offset_out_is_one_when_control_is_zero");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                control   <= '0';
                offset_in <= std_logic_vector(to_unsigned(123, 32));
                wait for CLK_PERIOD * 2;
                check_equal(offset_out, std_logic_vector(to_unsigned(1, 32)), "Comparing offset_out against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_offset_out_is_offset_in_when_control_is_one") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_offset_out_is_offset_in_when_control_is_one");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                control   <= '1';
                offset_in <= std_logic_vector(to_unsigned(123, 32));
                wait for CLK_PERIOD * 2;
                check_equal(offset_out, offset_in, "Comparing offset_out against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
