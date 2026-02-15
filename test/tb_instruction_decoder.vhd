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

    signal   clk           : std_logic := '0';
    signal   reset         : std_logic := '0';
    signal   enable        : std_logic := '0';
    signal   instruction   : std_logic_vector(31 downto 0);
    signal   halt          : std_logic := '0';
    signal   rs1           : std_logic_vector(4 downto 0);
    signal   rs2           : std_logic_vector(4 downto 0);
    signal   rd            : std_logic_vector(4 downto 0);
    signal   write         : std_logic;
    signal   alu_operation : std_logic_vector(10 downto 0);
    signal   alu_source    : std_logic;
    signal   immediate     : std_logic_vector(31 downto 0);
    signal   load          : std_logic;
    signal   store         : std_logic;
    signal   branch        : std_logic;
    signal   jump          : std_logic;
    signal   jalr_flag     : std_logic;
    signal   unknown_instr : std_logic;
    signal   check_sig     : natural   := 0;
    constant CLK_PERIOD    : time      := 2 us;

    component instruction_decoder is
        port (
            clk           : in    std_logic;
            reset         : in    std_logic;
            enable        : in    std_logic;
            instruction   : in    std_logic_vector(31 downto 0);
            halt          : in    std_logic;
            rs1           : out   std_logic_vector(4 downto 0);
            rs2           : out   std_logic_vector(4 downto 0);
            rd            : out   std_logic_vector(4 downto 0);
            write         : out   std_logic;
            alu_operation : out   std_logic_vector(10 downto 0);
            alu_source    : out   std_logic;
            immediate     : out   std_logic_vector(31 downto 0);
            load          : out   std_logic;
            store         : out   std_logic;
            branch        : out   std_logic;
            jump          : out   std_logic;
            jalr_flag     : out   std_logic;
            unknown_instr : out   std_logic
        );
    end component instruction_decoder;

begin

    instruction_decoder_instance : component instruction_decoder
        port map (
            clk           => clk,
            reset         => reset,
            enable        => enable,
            instruction   => instruction,
            halt          => halt,
            rs1           => rs1,
            rs2           => rs2,
            rd            => rd,
            write         => write,
            alu_operation => alu_operation,
            alu_source    => alu_source,
            immediate     => immediate,
            load          => load,
            store         => store,
            branch        => branch,
            jump          => jump,
            jalr_flag     => jalr_flag,
            unknown_instr => unknown_instr
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
                reset       <= '1';
                enable      <= '1';
                instruction <= "01010101010101010101010101010101";
                wait for CLK_PERIOD * 2;
                check_equal(rs1, std_logic_vector(to_unsigned(0, 5)));
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)));
                check_equal(rd, std_logic_vector(to_unsigned(0, 5)));
                check_equal(write, '0');
                check_equal(alu_operation, std_logic_vector(to_unsigned(0, 11)));
                check_equal(alu_source, '0');
                check_equal(immediate, std_logic_vector(to_unsigned(0, 32)));
                check_equal(load, '0');
                check_equal(store, '0');
                check_equal(branch, '0');
                check_equal(jump, '0');
                check_equal(jalr_flag, '0');
                check_equal(unknown_instr, '0');
                check_sig   <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_R_type_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_R_type_instruction");
                info("--------------------------------------------------------------------------------");
                reset       <= '1';
                enable      <= '1';
                wait for CLK_PERIOD * 2;
                reset       <= '0';
                instruction <= "10101010101010101010101010110011";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction(11 downto 7));
                check_equal(alu_operation, "0110011" & instruction(30) & instruction(14 downto 12));
                check_equal(rs1, instruction(19 downto 15));
                check_equal(rs2, instruction(24 downto 20));
                check_equal(write, '1');
                check_equal(store, '0');
                check_equal(load, '0');
                check_equal(immediate, std_logic_vector(to_unsigned(0, 32)));
                check_equal(alu_source, '1');
                check_equal(branch, '0');
                check_equal(jump, '0');
                check_equal(jalr_flag, '0');
                check_equal(unknown_instr, '0');
                check_sig   <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_I_type_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_I_type_instruction");
                info("--------------------------------------------------------------------------------");
                reset       <= '1';
                enable      <= '1';
                wait for CLK_PERIOD * 2;
                reset       <= '0';
                instruction <= "10101010101010101010101010010011";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction(11 downto 7));
                check_equal(alu_operation, "0010011" & '0' & instruction(14 downto 12));
                check_equal(rs1, instruction(19 downto 15));
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)));
                check_equal(write, '1');
                check_equal(store, '0');
                check_equal(load, '0');
                check_equal(immediate, "11111111111111111111" & instruction(31 downto 20));
                check_equal(alu_source, '0');
                check_equal(branch, '0');
                check_equal(jump, '0');
                check_equal(jalr_flag, '0');
                check_equal(unknown_instr, '0');
                check_sig   <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_load_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_load_instruction");
                info("--------------------------------------------------------------------------------");
                reset       <= '1';
                enable      <= '1';
                wait for CLK_PERIOD * 2;
                reset       <= '0';
                instruction <= "10101010101010101010101010000011";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction(11 downto 7));
                check_equal(alu_operation, "0000011" & '0' & instruction(14 downto 12));
                check_equal(rs1, instruction(19 downto 15));
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)));
                check_equal(write, '1');
                check_equal(store, '0');
                check_equal(load, '1');
                check_equal(immediate, "11111111111111111111" & instruction(31 downto 20));
                check_equal(alu_source, '0');
                check_equal(branch, '0');
                check_equal(jump, '0');
                check_equal(jalr_flag, '0');
                check_equal(unknown_instr, '0');
                check_sig   <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_store_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_store_instruction");
                info("--------------------------------------------------------------------------------");
                reset       <= '1';
                enable      <= '1';
                wait for CLK_PERIOD * 2;
                reset       <= '0';
                instruction <= "10101010101010101010101010100011";
                wait for CLK_PERIOD * 2;
                check_equal(rd, std_logic_vector(to_unsigned(0, 5)));
                check_equal(alu_operation, "0100011" & '0' & instruction(14 downto 12));
                check_equal(rs1, instruction(19 downto 15));
                check_equal(rs2, instruction(24 downto 20));
                check_equal(write, '0');
                check_equal(store, '1');
                check_equal(load, '0');
                check_equal(immediate, "11111111111111111111" & instruction(31 downto 25) &
                            instruction(11 downto 7));
                check_equal(alu_source, '0');
                check_equal(branch, '0');
                check_equal(jump, '0');
                check_equal(jalr_flag, '0');
                check_equal(unknown_instr, '0');
                check_sig   <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_conditional_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_conditional_instruction");
                info("--------------------------------------------------------------------------------");
                reset       <= '1';
                enable      <= '1';
                wait for CLK_PERIOD * 2;
                reset       <= '0';
                instruction <= "11010101010101010100101011100011";
                wait for CLK_PERIOD * 2;
                check_equal(rd, std_logic_vector(to_unsigned(0, 5)));
                check_equal(alu_operation, "1100011" & '0' & instruction(14 downto 12));
                check_equal(rs1, instruction(19 downto 15));
                check_equal(rs2, instruction(24 downto 20));
                check_equal(write, '0');
                check_equal(store, '0');
                check_equal(load, '0');
                check_equal(immediate, "1111111111111111111" & instruction(31) & instruction(7) &
                            instruction(30 downto 25) & instruction(11 downto 8) & '0');
                check_equal(alu_source, '1');
                check_equal(branch, '1');
                check_equal(jump, '0');
                check_equal(jalr_flag, '0');
                check_equal(unknown_instr, '0');
                check_sig   <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_jal_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_jal_instruction");
                info("--------------------------------------------------------------------------------");
                reset       <= '1';
                enable      <= '1';
                wait for CLK_PERIOD * 2;
                reset       <= '0';
                instruction <= "01010101010101010100101011101111";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction(11 downto 7));
                check_equal(alu_operation, std_logic_vector(unsigned'("11011110000")));
                check_equal(rs1, std_logic_vector(to_unsigned(0, 5)));
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)));
                check_equal(write, '1');
                check_equal(store, '0');
                check_equal(load, '0');
                check_equal(immediate, "00000000000" & instruction(31) & instruction(19 downto 12) &
                            instruction(20) & instruction(30 downto 21) & '0');
                check_equal(alu_source, '0');
                check_equal(branch, '0');
                check_equal(jump, '1');
                check_equal(jalr_flag, '0');
                check_equal(unknown_instr, '0');
                check_sig   <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_jalr_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_jalr_instruction");
                info("--------------------------------------------------------------------------------");
                reset       <= '1';
                enable      <= '1';
                wait for CLK_PERIOD * 2;
                reset       <= '0';
                instruction <= "01010101010101010100101011100111";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction(11 downto 7));
                check_equal(alu_operation, "1100111" & '0' & instruction(14 downto 12));
                check_equal(rs1, instruction(19 downto 15));
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)));
                check_equal(write, '1');
                check_equal(store, '0');
                check_equal(load, '0');
                check_equal(immediate, "00000000000000000000" & instruction(31 downto 20));
                check_equal(alu_source, '0');
                check_equal(branch, '0');
                check_equal(jump, '1');
                check_equal(jalr_flag, '1');
                check_equal(unknown_instr, '0');
                check_sig   <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_U_type_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_U_type_instruction");
                info("--------------------------------------------------------------------------------");
                reset       <= '1';
                enable      <= '1';
                wait for CLK_PERIOD * 2;
                reset       <= '0';
                instruction <= "01010101010101010100101010110111";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction(11 downto 7));
                check_equal(alu_operation, std_logic_vector(unsigned'("01101110000")));
                check_equal(rs1, std_logic_vector(to_unsigned(0, 5)));
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)));
                check_equal(write, '1');
                check_equal(store, '0');
                check_equal(load, '0');
                check_equal(immediate, instruction(31 downto 12) & "000000000000");
                check_equal(alu_source, '0');
                check_equal(branch, '0');
                check_equal(jump, '0');
                check_equal(jalr_flag, '0');
                check_equal(unknown_instr, '0');
                check_sig   <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_AUIPC_instruction") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_AUIPC_instruction");
                info("--------------------------------------------------------------------------------");
                reset       <= '1';
                enable      <= '1';
                wait for CLK_PERIOD * 2;
                reset       <= '0';
                instruction <= "01010101010101010100101010010111";
                wait for CLK_PERIOD * 2;
                check_equal(rd, instruction(11 downto 7));
                check_equal(alu_operation, std_logic_vector(unsigned'("00101110000")));
                check_equal(rs1, std_logic_vector(to_unsigned(0, 5)));
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)));
                check_equal(write, '1');
                check_equal(store, '0');
                check_equal(load, '0');
                check_equal(immediate, instruction(31 downto 12) & "000000000000");
                check_equal(alu_source, '0');
                check_equal(branch, '0');
                check_equal(jump, '0');
                check_equal(jalr_flag, '0');
                check_equal(unknown_instr, '0');
                check_sig   <= 1;
                info("===== TEST CASE FINISHED =====");
            elsif run("test_decode_unknown_instruction_type") then
                info("--------------------------------------------------------------------------------");
                info("TEST CASE: test_decode_unknown_instruction_type");
                info("--------------------------------------------------------------------------------");
                reset       <= '1';
                enable      <= '1';
                wait for CLK_PERIOD * 2;
                reset       <= '0';
                instruction <= "10101010101010101011111111111111";
                wait for CLK_PERIOD * 2;
                check_equal(rs1, std_logic_vector(to_unsigned(0, 5)));
                check_equal(rs2, std_logic_vector(to_unsigned(0, 5)));
                check_equal(rd, std_logic_vector(to_unsigned(0, 5)));
                check_equal(write, '0');
                check_equal(alu_operation, std_logic_vector(to_unsigned(0, 11)));
                check_equal(alu_source, '0');
                check_equal(immediate, std_logic_vector(to_unsigned(0, 32)));
                check_equal(load, '0');
                check_equal(store, '0');
                check_equal(branch, '0');
                check_equal(jump, '0');
                check_equal(jalr_flag, '0');
                check_equal(unknown_instr, '1');
                check_sig   <= 1;
                info("===== TEST CASE FINISHED =====");
            end if;

        end loop;

        test_runner_cleanup(runner);

    end process test_runner;

end architecture tb;
