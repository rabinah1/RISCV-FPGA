library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_alu;

architecture tb of tb_alu is

    signal   clk        : std_logic := '0';
    signal   reset      : std_logic := '0';
    signal   input_1    : std_logic_vector(31 downto 0) := (others => '0');
    signal   input_2    : std_logic_vector(31 downto 0) := (others => '0');
    signal   operand    : std_logic_vector(10 downto 0) := (others => '0');
    signal   alu_output : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig  : natural := 0;
    constant CLK_PERIOD : time := 250 us;

    component alu is
        port (
            clk        : in    std_logic;
            reset      : in    std_logic;
            input_1    : in    std_logic_vector(31 downto 0);
            input_2    : in    std_logic_vector(31 downto 0);
            operand    : in    std_logic_vector(10 downto 0);
            alu_output : out   std_logic_vector(31 downto 0)
        );
    end component;

begin

    alu_instance : component alu
        port map (
            clk        => clk,
            reset      => reset,
            input_1    => input_1,
            input_2    => input_2,
            operand    => operand,
            alu_output => alu_output
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

            if run("test_output_is_zero_if_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_output_is_zero_if_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                operand   <= (others => '0');
                input_1   <= std_logic_vector(to_unsigned(123, 32));
                input_2   <= std_logic_vector(to_unsigned(456, 32));
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_add_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_add_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                operand   <= "01100110000";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(181, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_addi_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_addi_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                operand   <= "00100110000";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(181, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_sub_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sub_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(100, 32));
                input_2   <= std_logic_vector(to_unsigned(46, 32));
                operand   <= "01100111000";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(54, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_sll_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sll_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(470, 32));
                input_2   <= std_logic_vector(to_unsigned(3, 32));
                operand   <= "01100110001";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(3760, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_slli_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_slli_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(470, 32));
                input_2   <= std_logic_vector(to_unsigned(3, 32));
                operand   <= "00100110001";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(3760, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_slt_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_slt_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(49, 32));
                input_2   <= std_logic_vector(to_unsigned(123, 32));
                operand   <= "01100110010";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(1, 32)),
                            "Comparing alu_output against reference.");
                wait for CLK_PERIOD * 2;
                input_1   <= std_logic_vector(to_unsigned(100, 32));
                input_2   <= std_logic_vector(to_unsigned(98, 32));
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_slti_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_slti_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(49, 32));
                input_2   <= std_logic_vector(to_unsigned(123, 32));
                operand   <= "00100110010";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(1, 32)),
                            "Comparing alu_output against reference.");
                wait for CLK_PERIOD * 2;
                input_1   <= std_logic_vector(to_unsigned(100, 32));
                input_2   <= std_logic_vector(to_unsigned(98, 32));
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_sltu_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sltu_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(49, 32));
                input_2   <= std_logic_vector(to_unsigned(123, 32));
                operand   <= "01100110011";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(1, 32)),
                            "Comparing alu_output against reference.");
                wait for CLK_PERIOD * 2;
                input_1   <= std_logic_vector(to_unsigned(100, 32));
                input_2   <= std_logic_vector(to_unsigned(98, 32));
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_sltiu_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sltiu_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(49, 32));
                input_2   <= std_logic_vector(to_unsigned(123, 32));
                operand   <= "00100110011";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(1, 32)),
                            "Comparing alu_output against reference.");
                wait for CLK_PERIOD * 2;
                input_1   <= std_logic_vector(to_unsigned(100, 32));
                input_2   <= std_logic_vector(to_unsigned(98, 32));
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_xor_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_xor_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operand   <= "01100110100";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(72, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_xori_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_xori_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operand   <= "00100110100";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(72, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_srl_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_srl_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(2670, 32));
                input_2   <= std_logic_vector(to_unsigned(3, 32));
                operand   <= "01100110101";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(333, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_srli_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_srli_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(2670, 32));
                input_2   <= std_logic_vector(to_unsigned(3, 32));
                operand   <= "00100110101";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(333, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_or_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_or_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operand   <= "01100110110";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(205, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_ori_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_ori_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operand   <= "00100110110";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(205, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_and_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_and_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operand   <= "01100110111";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(133, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_andi_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_andi_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operand   <= "00100110111";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(133, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_lw_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_lw_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                operand   <= "00000110010";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(181, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_sw_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sw_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                operand   <= "01000110010";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(181, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_beq_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_beq_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(105, 32));
                input_2   <= std_logic_vector(to_unsigned(105, 32));
                operand   <= "11000110000";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(1, 32)),
                            "Comparing alu_output against reference.");
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(85, 32));
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_bne_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_bne_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(103, 32));
                input_2   <= std_logic_vector(to_unsigned(105, 32));
                operand   <= "11000110001";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(1, 32)),
                            "Comparing alu_output against reference.");
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(103, 32));
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_blt_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_blt_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(50, 32));
                input_2   <= std_logic_vector(to_unsigned(57, 32));
                operand   <= "11000110100";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(1, 32)),
                            "Comparing alu_output against reference.");
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(49, 32));
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_bge_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_bge_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(50, 32));
                input_2   <= std_logic_vector(to_unsigned(50, 32));
                operand   <= "11000110101";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(1, 32)),
                            "Comparing alu_output against reference.");
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(51, 32));
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_bltu_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_bltu_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(50, 32));
                input_2   <= std_logic_vector(to_unsigned(57, 32));
                operand   <= "11000110110";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(1, 32)),
                            "Comparing alu_output against reference.");
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(49, 32));
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_bgeu_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_bgeu_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(50, 32));
                input_2   <= std_logic_vector(to_unsigned(50, 32));
                operand   <= "11000110111";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(1, 32)),
                            "Comparing alu_output against reference.");
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(51, 32));
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(0, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_jal_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_jal_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                operand   <= "11011110000";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(alu_output, std_logic_vector(to_unsigned(158, 32)),
                            "Comparing alu_output against reference.");
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
