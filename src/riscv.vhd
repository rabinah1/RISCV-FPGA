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

    signal alu_input_1                 : std_logic_vector(31 downto 0);
    signal alu_input_2                 : std_logic_vector(31 downto 0);
    signal alu_operand                 : std_logic_vector(10 downto 0);
    signal alu_out                     : std_logic_vector(31 downto 0);
    signal program_counter_address_out : std_logic_vector(31 downto 0);
    signal program_counter_address_in  : std_logic_vector(31 downto 0);
    signal program_memory_pc_out       : std_logic_vector(31 downto 0);
    signal instruction                 : std_logic_vector(31 downto 0);
    signal rs1_int                     : std_logic_vector(4 downto 0);
    signal rs2_int                     : std_logic_vector(4 downto 0);
    signal rd_int                      : std_logic_vector(4 downto 0);
    signal write_int                   : std_logic;
    signal writeback_data              : std_logic_vector(31 downto 0);
    signal alu_src_reg_in              : std_logic_vector(31 downto 0);
    signal alu_src_ctrl                : std_logic_vector(1 downto 0);
    signal immediate_int               : std_logic_vector(31 downto 0);
    signal writeback_ctrl              : std_logic;
    signal dmem_data_int               : std_logic_vector(31 downto 0);
    signal dmem_write                  : std_logic;
    signal offset_int                  : std_logic_vector(31 downto 0);
    signal branch_int                  : std_logic;
    signal jump_int                    : std_logic;
    signal instruction_decoder_pc_out  : std_logic_vector(31 downto 0);
    signal jalr_flag_int               : std_logic;
    signal pc_input_mux_output         : std_logic_vector(31 downto 0);

    component alu is
        port (
            clk        : in    std_logic;
            reset      : in    std_logic;
            input_1    : in    std_logic_vector(31 downto 0);
            input_2    : in    std_logic_vector(31 downto 0);
            operand    : in    std_logic_vector(10 downto 0);
            alu_output : out   std_logic_vector(31 downto 0)
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
            clk             : in    std_logic;
            reset           : in    std_logic;
            pc_in           : in    std_logic_vector(31 downto 0);
            pc_out          : out   std_logic_vector(31 downto 0);
            instruction_reg : out   std_logic_vector(31 downto 0)
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
            clk            : in    std_logic;
            reset          : in    std_logic;
            instruction_in : in    std_logic_vector(31 downto 0);
            pc_in          : in    std_logic_vector(31 downto 0);
            rs1            : out   std_logic_vector(4 downto 0);
            rs2            : out   std_logic_vector(4 downto 0);
            rd             : out   std_logic_vector(4 downto 0);
            write          : out   std_logic;
            alu_operation  : out   std_logic_vector(10 downto 0);
            alu_source     : out   std_logic_vector(1 downto 0);
            immediate      : out   std_logic_vector(31 downto 0);
            load           : out   std_logic;
            store          : out   std_logic;
            branch         : out   std_logic;
            jump           : out   std_logic;
            jalr_flag      : out   std_logic;
            pc_out         : out   std_logic_vector(31 downto 0)
        );
    end component instruction_decoder;

    component alu_src is
        port (
            clk         : in    std_logic;
            reset       : in    std_logic;
            control     : in    std_logic_vector(1 downto 0);
            immediate   : in    std_logic_vector(31 downto 0);
            register_in : in    std_logic_vector(31 downto 0);
            pc_in       : in    std_logic_vector(31 downto 0);
            data_out    : out   std_logic_vector(31 downto 0)
        );
    end component alu_src;

    component writeback_mux is
        port (
            clk       : in    std_logic;
            reset     : in    std_logic;
            control   : in    std_logic;
            alu_res   : in    std_logic_vector(31 downto 0);
            dmem_data : in    std_logic_vector(31 downto 0);
            data_out  : out   std_logic_vector(31 downto 0)
        );
    end component writeback_mux;

    component data_memory is
        port (
            clk          : in    std_logic;
            reset        : in    std_logic;
            address      : in    std_logic_vector(31 downto 0);
            data_in      : in    std_logic_vector(31 downto 0);
            write_enable : in    std_logic;
            data_out     : out   std_logic_vector(31 downto 0)
        );
    end component data_memory;

    component pc_offset_mux is
        port (
            clk        : in    std_logic;
            reset      : in    std_logic;
            control    : in    std_logic;
            input_1    : in    std_logic_vector(31 downto 0);
            input_2    : in    std_logic_vector(31 downto 0);
            offset_out : out   std_logic_vector(31 downto 0)
        );
    end component pc_offset_mux;

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
            clk        => clk,
            reset      => reset,
            input_1    => alu_input_1,
            input_2    => alu_input_2,
            operand    => alu_operand,
            alu_output => alu_out
        );

    program_counter_unit : component program_counter
        port map (
            clk         => clk,
            reset       => reset,
            address_in  => program_counter_address_in,
            address_out => program_counter_address_out
        );

    program_memory_unit : component program_memory
        port map (
            clk             => clk,
            reset           => reset,
            pc_in           => program_counter_address_out,
            pc_out          => program_memory_pc_out,
            instruction_reg => instruction
        );

    register_file_unit : component register_file
        port map (
            clk        => clk,
            reset      => reset,
            rs1        => rs1_int,
            rs2        => rs2_int,
            rd         => rd_int,
            write      => write_int,
            write_data => writeback_data,
            reg_out_1  => alu_input_1,
            reg_out_2  => alu_src_reg_in
        );

    instruction_decoder_unit : component instruction_decoder
        port map (
            clk            => clk,
            reset          => reset,
            instruction_in => instruction,
            pc_in          => program_memory_pc_out,
            rs1            => rs1_int,
            rs2            => rs2_int,
            rd             => rd_int,
            write          => write_int,
            alu_operation  => alu_operand,
            alu_source     => alu_src_ctrl,
            immediate      => immediate_int,
            load           => writeback_ctrl,
            store          => dmem_write,
            branch         => branch_int,
            jump           => jump_int,
            jalr_flag      => jalr_flag_int,
            pc_out         => instruction_decoder_pc_out
        );

    alu_src_unit : component alu_src
        port map (
            clk         => clk,
            reset       => reset,
            control     => alu_src_ctrl,
            immediate   => immediate_int,
            register_in => alu_src_reg_in,
            pc_in       => instruction_decoder_pc_out,
            data_out    => alu_input_2
        );

    writeback_mux_unit : component writeback_mux
        port map (
            clk       => clk,
            reset     => reset,
            control   => writeback_ctrl,
            alu_res   => alu_out,
            dmem_data => dmem_data_int,
            data_out  => writeback_data
        );

    data_memory_unit : component data_memory
        port map (
            clk          => clk,
            reset        => reset,
            address      => alu_out,
            data_in      => alu_src_reg_in,
            write_enable => dmem_write,
            data_out     => dmem_data_int
        );

    pc_offset_mux_unit : component pc_offset_mux
        port map (
            clk        => clk,
            reset      => reset,
            control    => (alu_out(0) and branch_int) or jump_int,
            input_1    => std_logic_vector(to_unsigned(1, 32)),
            input_2    => immediate_int,
            offset_out => offset_int
        );

    pc_input_mux_unit : component pc_offset_mux
        port map (
            clk        => clk,
            reset      => reset,
            control    => jalr_flag_int,
            input_1    => program_counter_address_out,
            input_2    => alu_input_1,
            offset_out => pc_input_mux_output
        );

    pc_adder_unit : component pc_adder
        port map (
            clk     => clk,
            reset   => reset,
            input_1 => offset_int,
            input_2 => pc_input_mux_output,
            sum     => program_counter_address_in
        );

end architecture struct;
