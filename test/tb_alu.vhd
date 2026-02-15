library ieee;
library vunit_lib;
    context vunit_lib.vunit_context;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_pkg.all;

entity tb_alu is
    generic (
        runner_cfg : string := runner_cfg_default
    );
end entity tb_alu;

architecture tb of tb_alu is

    signal   clk        : std_logic                     := '0';
    signal   reset      : std_logic                     := '0';
    signal   enable     : std_logic                     := '0';
    signal   input_1    : std_logic_vector(31 downto 0) := (others => '0');
    signal   input_2    : std_logic_vector(31 downto 0) := (others => '0');
    signal   pc_in      : std_logic_vector(31 downto 0) := (others => '0');
    signal   operator   : std_logic_vector(10 downto 0) := (others => '0');
    signal   halt       : std_logic                     := '0';
    signal   result     : std_logic_vector(31 downto 0) := (others => '0');
    signal   check_sig  : natural                       := 0;
    constant CLK_PERIOD : time                          := 2 us;

    component alu is
        port (
            clk      : in    std_logic;
            reset    : in    std_logic;
            enable   : in    std_logic;
            input_1  : in    std_logic_vector(31 downto 0);
            input_2  : in    std_logic_vector(31 downto 0);
            pc_in    : in    std_logic_vector(31 downto 0);
            operator : in    std_logic_vector(10 downto 0);
            halt     : in    std_logic;
            result   : out   std_logic_vector(31 downto 0)
        );
    end component alu;

begin

    alu_instance : component alu
        port map (
            clk      => clk,
            reset    => reset,
            enable   => enable,
            input_1  => input_1,
            input_2  => input_2,
            pc_in    => pc_in,
            operator => operator,
            halt     => halt,
            result   => result
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

            if run("test_result_is_zero_if_reset_is_enabled") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_result_is_zero_if_reset_is_enabled");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                operator  <= (others => '0');
                input_1   <= std_logic_vector(to_unsigned(123, 32));
                input_2   <= std_logic_vector(to_unsigned(456, 32));
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_add_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_add_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                operator  <= ADD;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(181, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_addi_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_addi_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                operator  <= ADDI;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(181, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_sub_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sub_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(100, 32));
                input_2   <= std_logic_vector(to_unsigned(46, 32));
                operator  <= MY_SUB;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(54, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_sll_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sll_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(470, 32));
                input_2   <= std_logic_vector(to_unsigned(3, 32));
                operator  <= MY_SLL;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(3760, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_slli_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_slli_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(470, 32));
                input_2   <= std_logic_vector(to_unsigned(3, 32));
                operator  <= SLLI;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(3760, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_slt_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_slt_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(49, 32));
                input_2   <= std_logic_vector(to_unsigned(123, 32));
                operator  <= SLT;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(1, 32)));
                wait for CLK_PERIOD * 2;
                input_1   <= std_logic_vector(to_unsigned(100, 32));
                input_2   <= std_logic_vector(to_unsigned(98, 32));
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_slti_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_slti_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(49, 32));
                input_2   <= std_logic_vector(to_unsigned(123, 32));
                operator  <= SLTI;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(1, 32)));
                wait for CLK_PERIOD * 2;
                input_1   <= std_logic_vector(to_unsigned(100, 32));
                input_2   <= std_logic_vector(to_unsigned(98, 32));
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_sltu_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sltu_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(49, 32));
                input_2   <= std_logic_vector(to_unsigned(123, 32));
                operator  <= SLTU;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(1, 32)));
                wait for CLK_PERIOD * 2;
                input_1   <= std_logic_vector(to_unsigned(100, 32));
                input_2   <= std_logic_vector(to_unsigned(98, 32));
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_sltiu_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sltiu_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(49, 32));
                input_2   <= std_logic_vector(to_unsigned(123, 32));
                operator  <= SLTIU;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(1, 32)));
                wait for CLK_PERIOD * 2;
                input_1   <= std_logic_vector(to_unsigned(100, 32));
                input_2   <= std_logic_vector(to_unsigned(98, 32));
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_xor_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_xor_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operator  <= MY_XOR;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(72, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_xori_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_xori_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operator  <= XORI;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(72, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_srl_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_srl_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(2670, 32));
                input_2   <= std_logic_vector(to_unsigned(3, 32));
                operator  <= MY_SRL;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(333, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_srli_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_srli_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(2670, 32));
                input_2   <= std_logic_vector(to_unsigned(3, 32));
                operator  <= SRLI;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(333, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_or_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_or_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operator  <= MY_OR;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(205, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_ori_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_ori_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operator  <= ORI;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(205, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_and_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_and_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operator  <= MY_AND;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(133, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_andi_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_andi_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(141, 32));
                input_2   <= std_logic_vector(to_unsigned(197, 32));
                operator  <= ANDI;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(133, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_lw_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_lw_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                operator  <= LW;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(181, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_sw_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_sw_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                operator  <= SW;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(181, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_beq_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_beq_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(105, 32));
                input_2   <= std_logic_vector(to_unsigned(105, 32));
                operator  <= BEQ;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(1, 32)));
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(85, 32));
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_bne_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_bne_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(103, 32));
                input_2   <= std_logic_vector(to_unsigned(105, 32));
                operator  <= BNE;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(1, 32)));
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(103, 32));
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_blt_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_blt_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(50, 32));
                input_2   <= std_logic_vector(to_unsigned(57, 32));
                operator  <= BLT;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(1, 32)));
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(49, 32));
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_bge_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_bge_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(50, 32));
                input_2   <= std_logic_vector(to_unsigned(50, 32));
                operator  <= BGE;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(1, 32)));
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(51, 32));
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_bltu_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_bltu_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(50, 32));
                input_2   <= std_logic_vector(to_unsigned(57, 32));
                operator  <= BLTU;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(1, 32)));
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(49, 32));
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_bgeu_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_bgeu_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(50, 32));
                input_2   <= std_logic_vector(to_unsigned(50, 32));
                operator  <= BGEU;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(1, 32)));
                wait for CLK_PERIOD;
                input_2   <= std_logic_vector(to_unsigned(51, 32));
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_jal_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_jal_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                pc_in     <= std_logic_vector(to_unsigned(100, 32));
                operator  <= JAL;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(404, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_jalr_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_jalr_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                pc_in     <= std_logic_vector(to_unsigned(100, 32));
                operator  <= JAL;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(404, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_lui_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_lui_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                operator  <= LUI;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(157, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_auipc_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_auipc_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                pc_in     <= std_logic_vector(to_unsigned(100, 32));
                operator  <= AUIPC;
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(557, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_unrecognized_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_unrecognized_instruction");
                info("--------------------------------------------------------------------------------");
                reset     <= '1';
                enable    <= '1';
                input_1   <= std_logic_vector(to_unsigned(24, 32));
                input_2   <= std_logic_vector(to_unsigned(157, 32));
                operator  <= "11111111111";
                wait for CLK_PERIOD * 2;
                reset     <= '0';
                wait for CLK_PERIOD * 2;
                check_equal(result, std_logic_vector(to_unsigned(0, 32)));
                check_sig <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
