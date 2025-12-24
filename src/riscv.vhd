library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv is
    port (
        clk            : in    std_logic;
        reset          : in    std_logic;
        data_in        : in    std_logic;
        data_out       : out   std_logic;
        mem_access_err : out   std_logic;
        unknown_instr  : out   std_logic
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
    signal instruction_decoder_alu_source    : std_logic;
    signal instruction_decoder_immediate     : std_logic_vector(31 downto 0);
    signal instruction_decoder_load          : std_logic;
    signal instruction_decoder_store         : std_logic;
    signal instruction_decoder_branch        : std_logic;
    signal instruction_decoder_jump          : std_logic;
    signal instruction_decoder_jalr_flag     : std_logic;
    signal data_memory_output                : std_logic_vector(31 downto 0);
    signal pc_offset_mux_output              : std_logic_vector(31 downto 0);
    signal pc_input_mux_output               : std_logic_vector(31 downto 0);
    signal state_machine_fetch_enable        : std_logic;
    signal state_machine_decode_enable       : std_logic;
    signal state_machine_execute_enable      : std_logic;
    signal state_machine_write_back_enable   : std_logic;
    signal clk_500khz                        : std_logic;
    signal uart_write_trig                   : std_logic;
    signal uart_data_to_imem                 : std_logic_vector(31 downto 0);
    signal uart_data_from_reg_file           : std_logic_vector(31 downto 0);
    signal uart_address_from_reg_file        : std_logic_vector(5 downto 0);
    signal uart_address                      : std_logic_vector(31 downto 0);
    signal halt                              : std_logic;
    signal uart_write_done                   : std_logic;
    signal register_file_reg_dump_start      : std_logic;
    signal trig_reg_dump                     : std_logic;

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

    component program_counter is
        port (
            clk         : in    std_logic;
            reset       : in    std_logic;
            enable      : in    std_logic;
            address_in  : in    std_logic_vector(31 downto 0);
            halt        : in    std_logic;
            address_out : out   std_logic_vector(31 downto 0)
        );
    end component program_counter;

    component program_memory is
        port (
            clk                    : in    std_logic;
            reset                  : in    std_logic;
            fetch_enable           : in    std_logic;
            write_trig             : in    std_logic;
            halt                   : in    std_logic;
            write_done             : in    std_logic;
            data_word_from_uart    : in    std_logic_vector(31 downto 0);
            address_word_from_uart : in    std_logic_vector(31 downto 0);
            address_in             : in    std_logic_vector(31 downto 0);
            address_out            : out   std_logic_vector(31 downto 0);
            instruction            : out   std_logic_vector(31 downto 0)
        );
    end component program_memory;

    component register_file is
        port (
            clk              : in    std_logic;
            reset            : in    std_logic;
            enable           : in    std_logic;
            rs1              : in    std_logic_vector(4 downto 0);
            rs2              : in    std_logic_vector(4 downto 0);
            rd               : in    std_logic_vector(4 downto 0);
            write            : in    std_logic;
            write_data       : in    std_logic_vector(31 downto 0);
            trig_reg_dump    : in    std_logic;
            halt             : in    std_logic;
            reg_out_1        : out   std_logic_vector(31 downto 0);
            reg_out_2        : out   std_logic_vector(31 downto 0);
            reg_out_uart     : out   std_logic_vector(31 downto 0);
            address_out_uart : out   std_logic_vector(5 downto 0);
            reg_dump_start   : out   std_logic
        );
    end component register_file;

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

    component mux_2_inputs_latch is
        port (
            reset   : in    std_logic;
            control : in    std_logic;
            input_1 : in    std_logic_vector(31 downto 0);
            input_2 : in    std_logic_vector(31 downto 0);
            halt    : in    std_logic;
            output  : out   std_logic_vector(31 downto 0)
        );
    end component mux_2_inputs_latch;

    component mux_2_inputs is
        port (
            clk     : in    std_logic;
            reset   : in    std_logic;
            control : in    std_logic;
            input_1 : in    std_logic_vector(31 downto 0);
            input_2 : in    std_logic_vector(31 downto 0);
            halt    : in    std_logic;
            output  : out   std_logic_vector(31 downto 0)
        );
    end component mux_2_inputs;

    component writeback_mux is
        port (
            reset   : in    std_logic;
            control : in    std_logic;
            input_1 : in    std_logic_vector(31 downto 0);
            input_2 : in    std_logic_vector(31 downto 0);
            halt    : in    std_logic;
            output  : out   std_logic_vector(31 downto 0)
        );
    end component writeback_mux;

    component data_memory is
        port (
            clk               : in    std_logic;
            reset             : in    std_logic;
            address_bytes     : in    std_logic_vector(31 downto 0);
            write_data        : in    std_logic_vector(31 downto 0);
            write_enable      : in    std_logic;
            load_enable       : in    std_logic;
            write_back_enable : in    std_logic;
            halt              : in    std_logic;
            mem_access_err    : out   std_logic;
            output            : out   std_logic_vector(31 downto 0)
        );
    end component data_memory;

    component pc_adder is
        port (
            reset         : in    std_logic;
            halt          : in    std_logic;
            input_1_bytes : in    std_logic_vector(31 downto 0);
            input_2_bytes : in    std_logic_vector(31 downto 0);
            sum_words     : out   std_logic_vector(31 downto 0)
        );
    end component pc_adder;

    component state_machine is
        port (
            clk               : in    std_logic;
            reset             : in    std_logic;
            halt              : in    std_logic;
            fetch_enable      : out   std_logic;
            decode_enable     : out   std_logic;
            execute_enable    : out   std_logic;
            write_back_enable : out   std_logic
        );
    end component state_machine;

    component clk_div is
        port (
            clk_in     : in    std_logic;
            reset      : in    std_logic;
            clk_500khz : out   std_logic
        );
    end component clk_div;

    component uart is
        port (
            clk                   : in    std_logic;
            reset                 : in    std_logic;
            data_in               : in    std_logic;
            data_from_reg_file    : in    std_logic_vector(31 downto 0);
            address_from_reg_file : in    std_logic_vector(5 downto 0);
            reg_dump_start        : in    std_logic;
            data_out              : out   std_logic;
            halt                  : out   std_logic;
            write_trig            : out   std_logic;
            write_done            : out   std_logic;
            trig_reg_dump         : out   std_logic;
            data_to_imem          : out   std_logic_vector(31 downto 0);
            address               : out   std_logic_vector(31 downto 0)
        );
    end component uart;

begin

    alu_unit : component alu
        port map (
            clk      => clk_500khz,
            reset    => reset,
            enable   => state_machine_execute_enable,
            input_1  => register_file_reg_out_1,
            input_2  => alu_src_mux_output,
            pc_in    => program_memory_address_out,
            operator => instruction_decoder_alu_operation,
            halt     => halt,
            result   => alu_result
        );

    program_counter_unit : component program_counter
        port map (
            clk         => clk_500khz,
            reset       => reset,
            enable      => state_machine_write_back_enable,
            address_in  => pc_adder_sum,
            halt        => halt,
            address_out => program_counter_address_out
        );

    program_memory_unit : component program_memory
        port map (
            clk                    => clk_500khz,
            reset                  => reset,
            fetch_enable           => state_machine_fetch_enable,
            write_trig             => uart_write_trig,
            halt                   => halt,
            write_done             => uart_write_done,
            data_word_from_uart    => uart_data_to_imem,
            address_word_from_uart => uart_address,
            address_in             => program_counter_address_out,
            address_out            => program_memory_address_out,
            instruction            => program_memory_instruction
        );

    register_file_unit : component register_file
        port map (
            clk              => clk_500khz,
            reset            => reset,
            enable           => state_machine_write_back_enable,
            rs1              => instruction_decoder_rs1,
            rs2              => instruction_decoder_rs2,
            rd               => instruction_decoder_rd,
            write            => instruction_decoder_write,
            write_data       => writeback_mux_output,
            trig_reg_dump    => trig_reg_dump,
            halt             => halt,
            reg_out_1        => register_file_reg_out_1,
            reg_out_2        => register_file_reg_out_2,
            reg_out_uart     => uart_data_from_reg_file,
            address_out_uart => uart_address_from_reg_file,
            reg_dump_start   => register_file_reg_dump_start
        );

    instruction_decoder_unit : component instruction_decoder
        port map (
            clk           => clk_500khz,
            reset         => reset,
            enable        => state_machine_decode_enable,
            instruction   => program_memory_instruction,
            halt          => halt,
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
            unknown_instr => unknown_instr
        );

    alu_src_mux : component mux_2_inputs_latch
        port map (
            reset   => reset,
            control => instruction_decoder_alu_source,
            input_1 => instruction_decoder_immediate,
            input_2 => register_file_reg_out_2,
            halt    => halt,
            output  => alu_src_mux_output
        );

    writeback_mux_unit : component writeback_mux
        port map (
            reset   => reset,
            control => instruction_decoder_load,
            input_1 => alu_result,
            input_2 => data_memory_output,
            halt    => halt,
            output  => writeback_mux_output
        );

    data_memory_unit : component data_memory
        port map (
            clk               => clk_500khz,
            reset             => reset,
            address_bytes     => alu_result,
            write_data        => register_file_reg_out_2,
            write_enable      => instruction_decoder_store,
            load_enable       => instruction_decoder_load,
            write_back_enable => state_machine_write_back_enable,
            halt              => halt,
            mem_access_err    => mem_access_err,
            output            => data_memory_output
        );

    pc_offset_mux : component mux_2_inputs
        port map (
            clk     => clk_500khz,
            reset   => reset,
            control => (alu_result(0) and instruction_decoder_branch) or instruction_decoder_jump,
            input_1 => std_logic_vector(to_signed(4, 32)),
            input_2 => instruction_decoder_immediate,
            halt    => halt,
            output  => pc_offset_mux_output
        );

    pc_input_mux : component mux_2_inputs
        port map (
            clk     => clk_500khz,
            reset   => reset,
            control => instruction_decoder_jalr_flag,
            input_1 => program_counter_address_out(29 downto 0) & "00",
            input_2 => register_file_reg_out_1,
            halt    => halt,
            output  => pc_input_mux_output
        );

    pc_adder_unit : component pc_adder
        port map (
            reset         => reset,
            halt          => halt,
            input_1_bytes => pc_offset_mux_output,
            input_2_bytes => pc_input_mux_output,
            sum_words     => pc_adder_sum
        );

    state_machine_unit : component state_machine
        port map (
            clk               => clk_500khz,
            reset             => reset,
            halt              => halt,
            fetch_enable      => state_machine_fetch_enable,
            decode_enable     => state_machine_decode_enable,
            execute_enable    => state_machine_execute_enable,
            write_back_enable => state_machine_write_back_enable
        );

    clk_div_unit : component clk_div
        port map (
            clk_in     => clk,
            reset      => reset,
            clk_500khz => clk_500khz
        );

    uart_unit : component uart
        port map (
            clk                   => clk_500khz,
            reset                 => reset,
            data_in               => data_in,
            data_from_reg_file    => uart_data_from_reg_file,
            address_from_reg_file => uart_address_from_reg_file,
            reg_dump_start        => register_file_reg_dump_start,
            data_out              => data_out,
            halt                  => halt,
            write_trig            => uart_write_trig,
            write_done            => uart_write_done,
            trig_reg_dump         => trig_reg_dump,
            data_to_imem          => uart_data_to_imem,
            address               => uart_address
        );

end architecture struct;
