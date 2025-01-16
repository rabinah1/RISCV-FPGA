library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_riscv is
    generic (
        runner_cfg : string := runner_cfg_default;
        input_file : string := ""
    );
end entity tb_riscv;

architecture tb of tb_riscv is

    signal   clk           : std_logic := '0';
    signal   reset         : std_logic := '0';
    signal   start_program : std_logic := '0';
    signal   check_sig     : natural := 0;
    constant CLK_PERIOD    : time := 250 us;

    component riscv is
        port (
            clk           : in    std_logic;
            reset         : in    std_logic;
            start_program : in    std_logic
        );
    end component;

begin

    riscv_instance : component riscv
        port map (
            clk           => clk,
            reset         => reset,
            start_program => start_program
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

        type reg_mem is array(31 downto 0) of std_logic_vector(31 downto 0);

        type memory is array(1023 downto 0) of std_logic_vector(31 downto 0);

        alias    regs           is <<signal .tb_riscv.riscv_instance.register_file_unit.regs : reg_mem>>;
        alias    prog_mem       is <<signal .tb_riscv.riscv_instance.program_memory_unit.prog_mem : memory>>;
        alias    data_mem       is <<signal .tb_riscv.riscv_instance.data_memory_unit.data_mem : memory>>;
        file     stimulus_file  : text open read_mode is input_file;
        variable linein         : line;
        variable binary_command : std_logic_vector(31 downto 0);
        variable address        : integer;

    begin

        test_runner_setup(runner, runner_cfg);
        show(get_logger(default_checker), display_handler, pass);

        test_cases_loop : while test_suite loop

            if run("test_program_to_calculate_sum_of_1_and_2") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_program_to_calculate_sum_of_1_and_2");
                info("--------------------------------------------------------------------------------");
                reset         <= '1';
                start_program <= '0';
                address       := 0;
                wait for CLK_PERIOD * 2;

                while (not endfile(stimulus_file)) loop
                    readline(stimulus_file, linein);
                    if (linein.all(1) = '#') then
                        next;
                    else
                        read(linein, binary_command);
                        prog_mem(address) <= force binary_command;
                        address           := address + 1;
                        wait for CLK_PERIOD;
                    end if;
                end loop;

                file_close(stimulus_file);
                reset         <= '0';
                wait for CLK_PERIOD * 2;
                start_program <= '1';
                wait for CLK_PERIOD * 20 * 10;
                start_program <= '0';
                assert regs(10) = std_logic_vector(to_unsigned(3, 32));
                check_sig     <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
