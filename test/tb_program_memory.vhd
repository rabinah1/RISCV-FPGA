library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_program_memory is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_program_memory;

architecture tb of tb_program_memory is

    signal   clk             : std_logic;
    signal   reset           : std_logic;
    signal   fetch_enable    : std_logic;
    signal   write_trig      : std_logic;
    signal   halt            : std_logic;
    signal   write_done      : std_logic;
    signal   byte_from_uart  : std_logic_vector(31 downto 0);
    signal   uart_address_in : std_logic_vector(31 downto 0);
    signal   address_in      : std_logic_vector(31 downto 0);
    signal   address_out     : std_logic_vector(31 downto 0);
    signal   instruction     : std_logic_vector(31 downto 0);
    signal   check_sig       : natural := 0;
    constant CLK_PERIOD      : time := 2 us;

    type memory is array(511 downto 0) of std_logic_vector(31 downto 0);

    component program_memory is
        port (
            clk             : in    std_logic;
            reset           : in    std_logic;
            fetch_enable    : in    std_logic;
            write_trig      : in    std_logic;
            halt            : in    std_logic;
            write_done      : in    std_logic;
            byte_from_uart  : in    std_logic_vector(31 downto 0);
            uart_address_in : in    std_logic_vector(31 downto 0);
            address_in      : in    std_logic_vector(31 downto 0);
            address_out     : out   std_logic_vector(31 downto 0);
            instruction     : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    program_memory_instance : component program_memory
        port map (
            clk             => clk,
            reset           => reset,
            fetch_enable    => fetch_enable,
            write_trig      => write_trig,
            halt            => halt,
            write_done      => write_done,
            byte_from_uart  => byte_from_uart,
            uart_address_in => uart_address_in,
            address_in      => address_in,
            address_out     => address_out,
            instruction     => instruction
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

        alias prog_mem is <<signal .tb_program_memory.program_memory_instance.prog_mem : memory>>;

    begin

        test_runner_setup(runner, runner_cfg);
        show(get_logger(default_checker), display_handler, pass);

        test_cases_loop : while test_suite loop

            if run("test_outputs_are_correct_when_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_outputs_are_correct_when_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset           <= '1';
                fetch_enable    <= '0';
                write_trig      <= '0';
                halt            <= '0';
                write_done      <= '0';
                byte_from_uart  <= (others => '0');
                uart_address_in <= (others => '0');
                address_in      <= std_logic_vector(to_unsigned(111, 32));
                wait for CLK_PERIOD * 2;
                check_equal(instruction, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing instruction against reference.");
                check_equal(address_out, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing address_out against reference.");
                check_sig       <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_outputs_are_correct_when_halt_is_enabled_and_write_is_done") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_outputs_are_correct_when_halt_is_enabled_and_write_is_done");
                info("--------------------------------------------------------------------------------");
                reset           <= '1';
                fetch_enable    <= '0';
                write_trig      <= '1';
                halt            <= '1';
                write_done      <= '0';
                byte_from_uart  <= std_logic_vector(to_unsigned(45, 32));
                uart_address_in <= std_logic_vector(to_unsigned(200, 32));
                address_in      <= std_logic_vector(to_unsigned(111, 32));
                wait for CLK_PERIOD * 2;
                reset           <= '0';
                wait for CLK_PERIOD * 2;
                byte_from_uart  <= std_logic_vector(to_unsigned(22, 32));
                uart_address_in <= std_logic_vector(to_unsigned(100, 32));
                wait for CLK_PERIOD * 2;
                write_trig      <= '0';
                write_done      <= '1';
                wait for CLK_PERIOD * 2;
                check_equal(instruction, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing instruction against reference.");
                check_equal(address_out, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing address_out against reference.");
                check_equal(prog_mem(100), std_logic_vector(to_unsigned(22, 32)),
                            "Comparing memory address 100 against reference.");
                check_equal(prog_mem(200), std_logic_vector(to_unsigned(0, 32)),
                            "Comparing memory address 200 against reference.");
                check_sig       <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_outputs_are_correct_when_halt_is_enabled_and_write_is_not_done") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_outputs_are_correct_when_halt_is_enabled_and_write_is_not_done");
                info("--------------------------------------------------------------------------------");
                reset           <= '1';
                fetch_enable    <= '0';
                write_trig      <= '1';
                halt            <= '1';
                write_done      <= '0';
                byte_from_uart  <= std_logic_vector(to_unsigned(45, 32));
                uart_address_in <= std_logic_vector(to_unsigned(200, 32));
                address_in      <= std_logic_vector(to_unsigned(111, 32));
                wait for CLK_PERIOD * 2;
                reset           <= '0';
                wait for CLK_PERIOD * 2;
                byte_from_uart  <= std_logic_vector(to_unsigned(22, 32));
                uart_address_in <= std_logic_vector(to_unsigned(100, 32));
                wait for CLK_PERIOD * 2;
                write_done      <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(instruction, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing instruction against reference.");
                check_equal(address_out, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing address_out against reference.");
                check_equal(prog_mem(100), std_logic_vector(to_unsigned(22, 32)),
                            "Comparing memory address 100 against reference.");
                check_equal(prog_mem(200), std_logic_vector(to_unsigned(45, 32)),
                            "Comparing memory address 200 against reference.");
                check_sig       <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_output_instruction_is_read_correctly_with_specific_address") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_output_instruction_is_read_correctly_with_specific_address");
                info("--------------------------------------------------------------------------------");
                reset           <= '1';
                fetch_enable    <= '1';
                write_trig      <= '0';
                halt            <= '0';
                write_done      <= '0';
                byte_from_uart  <= (others => '0');
                uart_address_in <= (others => '0');
                prog_mem(0)     <= force std_logic_vector(to_unsigned(15, 32));
                prog_mem(45)    <= force std_logic_vector(to_unsigned(389, 32));
                wait for CLK_PERIOD * 2;
                reset           <= '0';
                fetch_enable    <= '1';
                address_in      <= std_logic_vector(to_unsigned(0, 32));
                wait for CLK_PERIOD * 2;
                check_equal(instruction, std_logic_vector(to_unsigned(15, 32)),
                            "Comparing instruction against reference.");
                check_equal(address_out, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing address_out against reference.");
                wait for CLK_PERIOD;
                address_in      <= std_logic_vector(to_unsigned(20, 32));
                wait for CLK_PERIOD * 2;
                check_equal(instruction, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing instruction against reference.");
                check_equal(address_out, std_logic_vector(to_unsigned(20, 32)),
                            "Comparing address_out against reference.");
                wait for CLK_PERIOD;
                address_in      <= std_logic_vector(to_unsigned(45, 32));
                wait for CLK_PERIOD * 2;
                check_equal(instruction, std_logic_vector(to_unsigned(389, 32)),
                            "Comparing instruction against reference.");
                check_equal(address_out, std_logic_vector(to_unsigned(45, 32)),
                            "Comparing address_out against reference.");
                check_sig       <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
