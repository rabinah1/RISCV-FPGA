library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv is
    port (
        clk   : in    std_logic;
        reset : in    std_logic
    );
end entity riscv;

architecture struct of riscv is

    signal register_file_reg_out_1           : std_logic_vector(31 downto 0);
    signal alu_src_mux_output                : std_logic_vector(31 downto 0);
    signal instruction_decoder_alu_operation : std_logic_vector(10 downto 0);
    signal alu_result                        : std_logic_vector(31 downto 0);
    signal pc_adder_sum                      : std_logic_vector(31 downto 0);
    signal program_counter_address_out       : std_logic_vector(31 downto 0);
    signal program_memory_address_out        : std_logic_vector(31 downto 0);
    signal program_memory_instruction        : std_logic_vector(31 downto 0);
    signal instruction_decoder_rs1           : std_logic_vector(4 downto 0);
    signal instruction_decoder_rs2           : std_logic_vector(4 downto 0);
    signal instruction_decoder_rd            : std_logic_vector(4 downto 0);
    signal instruction_decoder_write         : std_logic;
    signal writeback_mux_output              : std_logic_vector(31 downto 0);
    signal register_file_reg_out_2           : std_logic_vector(31 downto 0);
    signal instruction_decoder_alu_source    : std_logic_vector(1 downto 0);
    signal instruction_decoder_immediate     : std_logic_vector(31 downto 0);
    signal instruction_decoder_load          : std_logic;
    signal instruction_decoder_store         : std_logic;
    signal instruction_decoder_branch        : std_logic;
    signal instruction_decoder_jump          : std_logic;
    signal instruction_decoder_jalr_flag     : std_logic;
    signal instruction_decoder_pc_out        : std_logic_vector(31 downto 0);
    signal data_memory_output                : std_logic_vector(31 downto 0);
    signal pc_offset_mux_output              : std_logic_vector(31 downto 0);
    signal pc_input_mux_output               : std_logic_vector(31 downto 0);

    component alu is
        port (
            clk      : in    std_logic;
            reset    : in    std_logic;
            input_1  : in    std_logic_vector(31 downto 0);
            input_2  : in    std_logic_vector(31 downto 0);
            operator : in    std_logic_vector(10 downto 0);
            result   : out   std_logic_vector(31 downto 0)
        );
    end component alu;

    component program_counter is
        port (
            clk         : in    std_logic;
            reset       : in    std_logic;
            address_in  : in    std_logic_vector(31 downto 0);
            address_out : out   std_logic_vector(31 downto 0)
        );
    end component program_counter;

    component program_memory is
        port (
            clk         : in    std_logic;
            reset       : in    std_logic;
            address_in  : in    std_logic_vector(31 downto 0);
            address_out : out   std_logic_vector(31 downto 0);
            instruction : out   std_logic_vector(31 downto 0)
        );
    end component program_memory;

    component register_file is
        port (
            clk        : in    std_logic;
            reset      : in    std_logic;
            rs1        : in    std_logic_vector(4 downto 0);
            rs2        : in    std_logic_vector(4 downto 0);
            rd         : in    std_logic_vector(4 downto 0);
            write      : in    std_logic;
            write_data : in    std_logic_vector(31 downto 0);
            reg_out_1  : out   std_logic_vector(31 downto 0);
            reg_out_2  : out   std_logic_vector(31 downto 0)
        );
    end component register_file;

    component instruction_decoder is
        port (
            clk           : in    std_logic;
            reset         : in    std_logic;
            instruction   : in    std_logic_vector(31 downto 0);
            pc_in         : in    std_logic_vector(31 downto 0);
            rs1           : out   std_logic_vector(4 downto 0);
            rs2           : out   std_logic_vector(4 downto 0);
            rd            : out   std_logic_vector(4 downto 0);
            write         : out   std_logic;
            alu_operation : out   std_logic_vector(10 downto 0);
            alu_source    : out   std_logic_vector(1 downto 0);
            immediate     : out   std_logic_vector(31 downto 0);
            load          : out   std_logic;
            store         : out   std_logic;
            branch        : out   std_logic;
            jump          : out   std_logic;
            jalr_flag     : out   std_logic;
            pc_out        : out   std_logic_vector(31 downto 0)
        );
    end component instruction_decoder;

    component mux_3_inputs is
        port (
            clk     : in    std_logic;
            reset   : in    std_logic;
            control : in    std_logic_vector(1 downto 0);
            input_1 : in    std_logic_vector(31 downto 0);
            input_2 : in    std_logic_vector(31 downto 0);
            input_3 : in    std_logic_vector(31 downto 0);
            output  : out   std_logic_vector(31 downto 0)
        );
    end component mux_3_inputs;

    component mux_2_inputs is
        port (
            clk     : in    std_logic;
            reset   : in    std_logic;
            control : in    std_logic;
            input_1 : in    std_logic_vector(31 downto 0);
            input_2 : in    std_logic_vector(31 downto 0);
            output  : out   std_logic_vector(31 downto 0)
        );
    end component mux_2_inputs;

    component data_memory is
        port (
            clk          : in    std_logic;
            reset        : in    std_logic;
            address      : in    std_logic_vector(31 downto 0);
            write_data   : in    std_logic_vector(31 downto 0);
            write_enable : in    std_logic;
            output       : out   std_logic_vector(31 downto 0)
        );
    end component data_memory;

    component pc_adder is
        port (
            clk     : in    std_logic;
            reset   : in    std_logic;
            input_1 : in    std_logic_vector(31 downto 0);
            input_2 : in    std_logic_vector(31 downto 0);
            sum     : out   std_logic_vector(31 downto 0)
        );
    end component pc_adder;

begin

    alu_unit : component alu
        port map (
            clk      => clk,
            reset    => reset,
            input_1  => register_file_reg_out_1,
            input_2  => alu_src_mux_output,
            operator => instruction_decoder_alu_operation,
            result   => alu_result
        );

    program_counter_unit : component program_counter
        port map (
            clk         => clk,
            reset       => reset,
            address_in  => pc_adder_sum,
            address_out => program_counter_address_out
        );

    program_memory_unit : component program_memory
        port map (
            clk         => clk,
            reset       => reset,
            address_in  => program_counter_address_out,
            address_out => program_memory_address_out,
            instruction => program_memory_instruction
        );

    register_file_unit : component register_file
        port map (
            clk        => clk,
            reset      => reset,
            rs1        => instruction_decoder_rs1,
            rs2        => instruction_decoder_rs2,
            rd         => instruction_decoder_rd,
            write      => instruction_decoder_write,
            write_data => writeback_mux_output,
            reg_out_1  => register_file_reg_out_1,
            reg_out_2  => register_file_reg_out_2
        );

    instruction_decoder_unit : component instruction_decoder
        port map (
            clk           => clk,
            reset         => reset,
            instruction   => program_memory_instruction,
            pc_in         => program_memory_address_out,
            rs1           => instruction_decoder_rs1,
            rs2           => instruction_decoder_rs2,
            rd            => instruction_decoder_rd,
            write         => instruction_decoder_write,
            alu_operation => instruction_decoder_alu_operation,
            alu_source    => instruction_decoder_alu_source,
            immediate     => instruction_decoder_immediate,
            load          => instruction_decoder_load,
            store         => instruction_decoder_store,
            branch        => instruction_decoder_branch,
            jump          => instruction_decoder_jump,
            jalr_flag     => instruction_decoder_jalr_flag,
            pc_out        => instruction_decoder_pc_out
        );

    alu_src_mux : component mux_3_inputs
        port map (
            clk     => clk,
            reset   => reset,
            control => instruction_decoder_alu_source,
            input_1 => instruction_decoder_immediate,
            input_2 => register_file_reg_out_2,
            input_3 => instruction_decoder_pc_out,
            output  => alu_src_mux_output
        );

    writeback_mux : component mux_2_inputs
        port map (
            clk     => clk,
            reset   => reset,
            control => instruction_decoder_load,
            input_1 => alu_result,
            input_2 => data_memory_output,
            output  => writeback_mux_output
        );

    data_memory_unit : component data_memory
        port map (
            clk          => clk,
            reset        => reset,
            address      => alu_result,
            write_data   => register_file_reg_out_2,
            write_enable => instruction_decoder_store,
            output       => data_memory_output
        );

    pc_offset_mux : component mux_2_inputs
        port map (
            clk     => clk,
            reset   => reset,
            control => (alu_result(0) and instruction_decoder_branch) or instruction_decoder_jump,
            input_1 => std_logic_vector(to_unsigned(1, 32)),
            input_2 => instruction_decoder_immediate,
            output  => pc_offset_mux_output
        );

    pc_input_mux : component mux_2_inputs
        port map (
            clk     => clk,
            reset   => reset,
            control => instruction_decoder_jalr_flag,
            input_1 => program_counter_address_out,
            input_2 => register_file_reg_out_1,
            output  => pc_input_mux_output
        );

    pc_adder_unit : component pc_adder
        port map (
            clk     => clk,
            reset   => reset,
            input_1 => pc_offset_mux_output,
            input_2 => pc_input_mux_output,
            sum     => pc_adder_sum
        );

end architecture struct;
