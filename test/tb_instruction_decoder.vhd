library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_instruction_decoder is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_instruction_decoder;

architecture tb of tb_instruction_decoder is

    signal   clk            : std_logic := '0';
    signal   reset          : std_logic := '0';
    signal   instruction_in : std_logic_vector(31 downto 0);
    signal   rs1            : std_logic_vector(4 downto 0);
    signal   rs2            : std_logic_vector(4 downto 0);
    signal   rd             : std_logic_vector(4 downto 0);
    signal   write          : std_logic;
    signal   alu_operation  : std_logic_vector(3 downto 0);
    signal   alu_source     : std_logic;
    signal   immediate      : std_logic_vector(31 downto 0);
    signal   load           : std_logic;
    signal   store          : std_logic;
    signal   branch         : std_logic;
    signal   check_sig      : natural := 0;
    constant CLK_PERIOD     : time := 250 us;

    component instruction_decoder is
        port (
            clk            : in    std_logic;
            reset          : in    std_logic;
            instruction_in : in    std_logic_vector(31 downto 0);
            rs1            : out   std_logic_vector(4 downto 0);
            rs2            : out   std_logic_vector(4 downto 0);
            rd             : out   std_logic_vector(4 downto 0);
            write          : out   std_logic;
            alu_operation  : out   std_logic_vector(3 downto 0);
            alu_source     : out   std_logic;
            immediate      : out   std_logic_vector(31 downto 0);
            load           : out   std_logic;
            store          : out   std_logic;
            branch         : out   std_logic
        );
    end component;

begin

    instruction_decoder_instance : component instruction_decoder
        port map (
            clk            => clk,
            reset          => reset,
            instruction_in => instruction_in,
            rs1            => rs1,
            rs2            => rs2,
            rd             => rd,
            write          => write,
            alu_operation  => alu_operation,
            alu_source     => alu_source,
            immediate      => immediate,
            load           => load,
            store          => store,
            branch         => branch
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

            if run("test_all_outputs_are_zero_when_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_all_outputs_are_zero_when_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset          <= '1';
                instruction_in <= "01010101010101010101010101010101";
                wait for CLK_PERIOD * 2;
                check_equal(rs1, std_logic_vector(to_unsigned(0, 5)), "Comparing rs1 against reference.");
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)), "Comparing rs2 against reference.");
                check_equal(rd, std_logic_vector(to_unsigned(0, 5)), "Comparing rd against reference.");
                check_equal(write, '0', "Comparing write against reference.");
                check_equal(alu_operation, std_logic_vector(to_unsigned(0, 4)),
                            "Comparing alu_operation against reference.");
                check_equal(alu_source, '0', "Comparing alu_source against reference.");
                check_equal(immediate, std_logic_vector(to_unsigned(0, 32)), "Comparing immediate against reference.");
                check_equal(load, '0', "Comparing load against reference.");
                check_equal(store, '0', "Comparing store against reference.");
                check_equal(branch, '0', "Comparing branch against reference.");
                check_sig      <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_R_type_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_R_type_instruction");
                info("--------------------------------------------------------------------------------");
                reset          <= '1';
                wait for CLK_PERIOD * 2;
                reset          <= '0';
                instruction_in <= "10101010101010101010101010110011";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction_in(11 downto 7), "Comparing rd against reference.");
                check_equal(alu_operation, instruction_in(30) & instruction_in(14 downto 12),
                            "Comparing alu_operation against reference.");
                check_equal(rs1, instruction_in(19 downto 15), "Comparing rs1 against reference.");
                check_equal(rs2, instruction_in(24 downto 20), "Comparing rs2 against reference.");
                check_equal(write, '1', "Comparing write against reference.");
                check_equal(store, '0', "Comparing store against reference.");
                check_equal(load, '0', "Comparing load against reference.");
                check_equal(immediate, std_logic_vector(to_unsigned(0, 32)), "Comparing immediate against reference.");
                check_equal(alu_source, '1', "Comparing alu_source against reference.");
                check_equal(branch, '0', "Comparing branch against reference.");
                check_sig      <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_I_type_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_I_type_instruction");
                info("--------------------------------------------------------------------------------");
                reset          <= '1';
                wait for CLK_PERIOD * 2;
                reset          <= '0';
                instruction_in <= "10101010101010101010101010010011";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction_in(11 downto 7), "Comparing rd against reference.");
                check_equal(alu_operation, '0' & instruction_in(14 downto 12),
                            "Comparing alu_operation against reference.");
                check_equal(rs1, instruction_in(19 downto 15), "Comparing rs1 against reference.");
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)), "Comparing rs2 against reference.");
                check_equal(write, '1', "Comparing write against reference.");
                check_equal(store, '0', "Comparing store against reference.");
                check_equal(load, '0', "Comparing load against reference.");
                check_equal(immediate, "11111111111111111111" & instruction_in(31 downto 20),
                            "Comparing immediate against reference.");
                check_equal(alu_source, '0', "Comparing alu_source against reference.");
                check_equal(branch, '0', "Comparing branch against reference.");
                check_sig      <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_load_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_load_instruction");
                info("--------------------------------------------------------------------------------");
                reset          <= '1';
                wait for CLK_PERIOD * 2;
                reset          <= '0';
                instruction_in <= "10101010101010101010101010000011";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction_in(11 downto 7), "Comparing rd against reference.");
                check_equal(alu_operation, '0' & instruction_in(14 downto 12),
                            "Comparing alu_operation against reference.");
                check_equal(rs1, instruction_in(19 downto 15), "Comparing rs1 against reference.");
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)), "Comparing rs2 against reference.");
                check_equal(write, '1', "Comparing write against reference.");
                check_equal(store, '0', "Comparing store against reference.");
                check_equal(load, '1', "Comparing load against reference.");
                check_equal(immediate, "11111111111111111111" & instruction_in(31 downto 20),
                            "Comparing immediate against reference.");
                check_equal(alu_source, '0', "Comparing alu_source against reference.");
                check_equal(branch, '0', "Comparing branch against reference.");
                check_sig      <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_store_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_store_instruction");
                info("--------------------------------------------------------------------------------");
                reset          <= '1';
                wait for CLK_PERIOD * 2;
                reset          <= '0';
                instruction_in <= "10101010101010101010101010100011";
                wait for CLK_PERIOD * 2;
                check_equal(rd, std_logic_vector(to_unsigned(0, 5)), "Comparing rd against reference.");
                check_equal(alu_operation, '0' & instruction_in(14 downto 12),
                            "Comparing alu_operation against reference.");
                check_equal(rs1, instruction_in(19 downto 15), "Comparing rs1 against reference.");
                check_equal(rs2, instruction_in(24 downto 20), "Comparing rs2 against reference.");
                check_equal(write, '1', "Comparing write against reference.");
                check_equal(store, '1', "Comparing store against reference.");
                check_equal(load, '0', "Comparing load against reference.");
                check_equal(immediate, "11111111111111111111" & instruction_in(31 downto 25) &
                            instruction_in(11 downto 7), "Comparing immediate against reference.");
                check_equal(alu_source, '0', "Comparing alu_source against reference.");
                check_equal(branch, '0', "Comparing branch against reference.");
                check_sig      <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_conditional_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_conditional_instruction");
                info("--------------------------------------------------------------------------------");
                reset          <= '1';
                wait for CLK_PERIOD * 2;
                reset          <= '0';
                instruction_in <= "11010101010101010100101011100011";
                wait for CLK_PERIOD * 2;
                check_equal(rd, std_logic_vector(to_unsigned(0, 5)), "Comparing rd against reference.");
                check_equal(alu_operation, '0' & instruction_in(14 downto 12),
                            "Comparing alu_operation against reference.");
                check_equal(rs1, instruction_in(19 downto 15), "Comparing rs1 against reference.");
                check_equal(rs2, instruction_in(24 downto 20), "Comparing rs2 against reference.");
                check_equal(write, '1', "Comparing write against reference.");
                check_equal(store, '0', "Comparing store against reference.");
                check_equal(load, '0', "Comparing load against reference.");
                check_equal(immediate, "1111111111111111111" & instruction_in(31) & instruction_in(7) &
                            instruction_in(30 downto 25) & instruction_in(11 downto 8) & '0',
                            "Comparing immediate against reference.");
                check_equal(alu_source, '1', "Comparing alu_source against reference.");
                check_equal(branch, '1', "Comparing branch against reference.");
                check_sig      <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_jal_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_jal_instruction");
                info("--------------------------------------------------------------------------------");
                reset          <= '1';
                wait for CLK_PERIOD * 2;
                reset          <= '0';
                instruction_in <= "01010101010101010100101011101111";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction_in(11 downto 7), "Comparing rd against reference.");
                check_equal(alu_operation, std_logic_vector(to_unsigned(0, 4)),
                            "Comparing alu_operation against reference.");
                check_equal(rs1, std_logic_vector(to_unsigned(0, 5)), "Comparing rs1 against reference.");
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)), "Comparing rs2 against reference.");
                check_equal(write, '1', "Comparing write against reference.");
                check_equal(store, '0', "Comparing store against reference.");
                check_equal(load, '0', "Comparing load against reference.");
                check_equal(immediate, "00000000000" & instruction_in(31) & instruction_in(19 downto 12) &
                            instruction_in(20) & instruction_in(30 downto 21) & '0',
                            "Comparing immediate against reference.");
                check_equal(alu_source, '0', "Comparing alu_source against reference.");
                check_equal(branch, '0', "Comparing branch against reference.");
                check_sig      <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_jalr_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_jalr_instruction");
                info("--------------------------------------------------------------------------------");
                reset          <= '1';
                wait for CLK_PERIOD * 2;
                reset          <= '0';
                instruction_in <= "01010101010101010100101011100111";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction_in(11 downto 7), "Comparing rd against reference.");
                check_equal(alu_operation, '0' & instruction_in(14 downto 12),
                            "Comparing alu_operation against reference.");
                check_equal(rs1, instruction_in(19 downto 15), "Comparing rs1 against reference.");
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)), "Comparing rs2 against reference.");
                check_equal(write, '1', "Comparing write against reference.");
                check_equal(store, '0', "Comparing store against reference.");
                check_equal(load, '0', "Comparing load against reference.");
                check_equal(immediate, "00000000000000000000" & instruction_in(31 downto 20),
                            "Comparing immediate against reference.");
                check_equal(alu_source, '0', "Comparing alu_source against reference.");
                check_equal(branch, '0', "Comparing branch against reference.");
                check_sig      <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;