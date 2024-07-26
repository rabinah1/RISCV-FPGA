library ieee;
use ieee.std_logic_1164.all;

entity top_level is
    port (
        clk : in std_logic;
        reset : in std_logic
    );
end entity top_level;

architecture struct of top_level is

    component alu is
        port (
            clk : in std_logic;
            reset : in std_logic;
            input_1 : in std_logic_vector(31 downto 0);
            input_2 : in std_logic_vector(31 downto 0);
            operand : in std_logic_vector(3 downto 0);
            alu_output : out std_logic_vector(31 downto 0)
        );
    end component alu;

    component program_counter is
        port (
            clk : in std_logic;
            reset : in std_logic;
            address_out : out std_logic_vector(31 downto 0)
        );
    end component program_counter;

    component program_memory is
        port (
            clk : in std_logic;
            reset : in std_logic;
            pc_in : in std_logic_vector(31 downto 0);
            instruciton_reg : out std_logic_vector(31 downto 0)
        );
    end component program_memory;

    component register_file is
        port (
            clk : in std_logic;
            reset : in std_logic;
            rs1 : in std_logic_vector(4 downto 0);
            rs2 : in std_logic_vector(4 downto 0);
            rd : in std_logic_vector(4 downto 0);
            write : in std_logic;
            write_data : in std_logic_vector(31 downto 0);
            reg_out_1 : out std_logic_vector(31 downto 0);
            reg_out_2 : out std_logic_vector(31 downto 0)
        );
    end component register_file;

    component instruction_decoder is
        port (
            clk : in std_logic;
            reset : in std_logic;
            instruction_in : in std_logic_vector(31 downto 0);
            rs1 : out std_logic_vector(4 downto 0);
            rs2 : out std_logic_vector(4 downto 0);
            rd : out std_logic_vector(4 downto 0);
            write : out std_logic;
            alu_operation : std_logic_vector(3 downto 0)
        );
    end component instruction_decoder;

    component alu_src is
        port (
            clk : in std_logic;
            reset : in std_logic;
            control : in std_logic;
            immediate : in std_logic_vector(31 downto 0);
            register_in : in std_logic_vector(31 downto 0);
            data_out : out std_logic_vector(31 downto 0)
        );
    end component alu_src;

    component writeback_mux is
        port (
            clk : in std_logic;
            reset : in std_logic;
            control : in std_logic;
            alu_res : in std_logic_vector(31 downto 0);
            dmem_data : in std_logic_vector(31 downto 0);
            data_out : out std_logic_vector(31 downto 0)
        );
    end component writeback_mux;

    component data_memory is
        port (
            clk : in std_logic;
            reset : in std_logic;
            address : in std_logic_vector(31 downto 0);
            data_in : in std_logic_vector(31 downto 0);
            write_enable : in std_logic;
            data_out : out std_logic_vector(31 downto 0)
        );
    end component data_memory;

    component pc_offset_mux is
        port (
            clk : in std_logic;
            reset : in std_logic;
            control : in std_logic;
            offset_in : in std_logic_vector(31 downto 0);
            offset_out : out std_logic_vector(31 downto 0)
        );
    end component pc_offset_mux;

end architecture struct;
