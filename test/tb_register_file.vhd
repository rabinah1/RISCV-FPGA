library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_register_file is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_register_file;

architecture tb of tb_register_file is

    signal   clk        : std_logic := '0';
    signal   reset      : std_logic := '0';
    signal   enable     : std_logic := '0';
    signal   rs1        : std_logic_vector(4 downto 0) := (others => '0');
    signal   rs2        : std_logic_vector(4 downto 0) := (others => '0');
    signal   rd         : std_logic_vector(4 downto 0) := (others => '0');
    signal   write      : std_logic := '0';
    signal   write_data : std_logic_vector(31 downto 0) := (others => '0');
    signal   reg_out_1  : std_logic_vector(31 downto 0) := (others => '0');
    signal   reg_out_2  : std_logic_vector(31 downto 0) := (others => '0');
    signal   cpu_reg    : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig  : natural := 0;
    constant CLK_PERIOD : time := 2 us;

    type memory is array(31 downto 0) of std_logic_vector(31 downto 0);

    component register_file is
        port (
            clk        : in    std_logic;
            reset      : in    std_logic;
            enable     : in    std_logic;
            rs1        : in    std_logic_vector(4 downto 0);
            rs2        : in    std_logic_vector(4 downto 0);
            rd         : in    std_logic_vector(4 downto 0);
            write      : in    std_logic;
            write_data : in    std_logic_vector(31 downto 0);
            reg_out_1  : out   std_logic_vector(31 downto 0);
            reg_out_2  : out   std_logic_vector(31 downto 0);
            cpu_reg    : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    register_file_instance : component register_file
        port map (
            clk        => clk,
            reset      => reset,
            enable     => enable,
            rs1        => rs1,
            rs2        => rs2,
            rd         => rd,
            write      => write,
            write_data => write_data,
            reg_out_1  => reg_out_1,
            reg_out_2  => reg_out_2,
            cpu_reg    => cpu_reg
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

        alias regs is <<signal .tb_register_file.register_file_instance.regs : memory>>;

    begin

        test_runner_setup(runner, runner_cfg);
        show(get_logger(default_checker), display_handler, pass);

        test_cases_loop : while test_suite loop

            if run("test_outputs_are_zero_if_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_outputs_are_zero_if_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset      <= '1';
                enable     <= '1';
                rs1        <= std_logic_vector(to_unsigned(12, 5));
                rs2        <= std_logic_vector(to_unsigned(6, 5));
                rd         <= (others => '0');
                write      <= '1';
                write_data <= (others => '0');
                wait for CLK_PERIOD * 2;
                check_equal(reg_out_1, std_logic_vector(to_unsigned(0, 32)), "Comparing reg_out_1 against reference.");
                check_equal(reg_out_2, std_logic_vector(to_unsigned(0, 32)), "Comparing reg_out_2 against reference.");
                check_equal(cpu_reg, std_logic_vector(to_unsigned(0, 32)), "Comparing cpu_reg against reference.");
                check_equal(regs(2), std_logic_vector(to_unsigned(512, 32)),
                            "Comparing stack pointer against reference.");
                check_sig  <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_cpu_reg") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_cpu_reg");
                info("--------------------------------------------------------------------------------");
                reset      <= '1';
                enable     <= '0';
                rs1        <= (others => '0');
                rs2        <= (others => '0');
                rd         <= (others => '0');
                write      <= '0';
                write_data <= (others => '0');
                wait for CLK_PERIOD * 2;
                reset      <= '0';
                regs(10)   <= force std_logic_vector(to_unsigned(85, 32));
                wait for CLK_PERIOD * 2;
                check_equal(cpu_reg, std_logic_vector(to_unsigned(85, 32)),
                            "Comparing cpu_reg against reference.");
                check_sig  <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_data_is_read_to_output_registers") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_data_is_read_to_output_registers");
                info("--------------------------------------------------------------------------------");
                reset      <= '1';
                enable     <= '0';
                rs1        <= std_logic_vector(to_unsigned(15, 5));
                rs2        <= std_logic_vector(to_unsigned(20, 5));
                rd         <= (others => '0');
                write      <= '0';
                write_data <= (others => '0');
                wait for CLK_PERIOD * 2;
                reset      <= '0';
                regs(15)   <= force std_logic_vector(to_unsigned(100, 32));
                regs(20)   <= force std_logic_vector(to_unsigned(200, 32));
                wait for CLK_PERIOD * 2;
                check_equal(reg_out_1, std_logic_vector(to_unsigned(100, 32)),
                            "Comparing reg_out_1 against reference.");
                check_equal(reg_out_2, std_logic_vector(to_unsigned(200, 32)),
                            "Comparing reg_out_2 against reference.");
                check_sig  <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_write_data") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_write_data");
                info("--------------------------------------------------------------------------------");
                reset      <= '1';
                enable     <= '1';
                rs1        <= (others => '0');
                rs2        <= (others => '0');
                rd         <= std_logic_vector(to_unsigned(6, 5));
                write      <= '1';
                write_data <= std_logic_vector(to_unsigned(123, 32));
                wait for CLK_PERIOD * 2;
                reset      <= '0';
                wait for CLK_PERIOD * 2;
                write      <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(regs(6), std_logic_vector(to_unsigned(123, 32)),
                            "Comparing register address 6 against reference.");
                check_sig  <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_write_to_address_0_is_blocked") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_write_to_address_0_is_blocked");
                info("--------------------------------------------------------------------------------");
                reset      <= '1';
                enable     <= '1';
                rs1        <= (others => '0');
                rs2        <= (others => '0');
                rd         <= std_logic_vector(to_unsigned(0, 5));
                write      <= '1';
                write_data <= std_logic_vector(to_unsigned(123, 32));
                wait for CLK_PERIOD * 2;
                reset      <= '0';
                wait for CLK_PERIOD * 2;
                write      <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(regs(0), std_logic_vector(to_unsigned(0, 32)),
                            "Comparing register address 6 against reference.");
                check_sig  <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
