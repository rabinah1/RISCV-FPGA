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

    signal   clk         : std_logic;
    signal   reset       : std_logic;
    signal   address_in  : std_logic_vector(31 downto 0);
    signal   address_out : std_logic_vector(31 downto 0);
    signal   instruction : std_logic_vector(31 downto 0);
    signal   check_sig   : natural := 0;
    constant CLK_PERIOD  : time := 250 us;

    component program_memory is
        port (
            clk         : in    std_logic;
            reset       : in    std_logic;
            address_in  : in    std_logic_vector(31 downto 0);
            address_out : out   std_logic_vector(31 downto 0);
            instruction : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    program_memory_instance : component program_memory
        port map (
            clk         => clk,
            reset       => reset,
            address_in  => address_in,
            address_out => address_out,
            instruction => instruction
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

            if run("test_output_instruction_is_read_correctly_with_specific_address") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_output_instruction_is_read_correctly_with_specific_address");
                info("--------------------------------------------------------------------------------");
                reset      <= '1';
                address_in <= (others => '0');
                wait for CLK_PERIOD * 2;
                reset      <= '0';
                address_in <= std_logic_vector(to_unsigned(123, 32));
                wait for CLK_PERIOD * 2;
                check_equal(instruction, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing instruction against reference.");
                check_equal(address_out, std_logic_vector(to_unsigned(123, 32)),
                            "Comparing address_out against reference.");
                check_sig  <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
