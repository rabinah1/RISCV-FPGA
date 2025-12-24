library ieee;
use ieee.std_logic_1164.all;
use work.instruction_types_package.all;

entity instruction_decoder is
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
end entity instruction_decoder;

architecture rtl of instruction_decoder is

begin

    instruction_decoder : process (all) is

        variable opcode   : std_logic_vector(6 downto 0);
        variable jal_temp : std_logic_vector(20 downto 0);

    begin

        if (reset = '1' or halt = '1') then
            rs1           <= (others => '0');
            rs2           <= (others => '0');
            rd            <= (others => '0');
            write         <= '0';
            alu_operation <= (others => '0');
            alu_source    <= '0';
            immediate     <= (others => '0');
            load          <= '0';
            store         <= '0';
            branch        <= '0';
            jump          <= '0';
            jalr_flag     <= '0';
            unknown_instr <= '0';
            opcode        := (others => '0');
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                -- Sign extended immediates should be interpreted as 2's complement
                opcode := instruction(6 downto 0);
                if (opcode = TYPE_R) then
                    rd            <= instruction(11 downto 7);
                    alu_operation <= opcode & instruction(30) & instruction(14 downto 12);
                    rs1           <= instruction(19 downto 15);
                    rs2           <= instruction(24 downto 20);
                    write         <= '1';
                    store         <= '0';
                    load          <= '0';
                    immediate     <= (others => '0');
                    alu_source    <= '1';
                    branch        <= '0';
                    jump          <= '0';
                    jalr_flag     <= '0';
                elsif (opcode = TYPE_I) then
                    rd                      <= instruction(11 downto 7);
                    alu_operation           <= opcode & '0' & instruction(14 downto 12);
                    rs1                     <= instruction(19 downto 15);
                    rs2                     <= (others => '0');
                    write                   <= '1';
                    immediate(11 downto 0)  <= instruction(31 downto 20);
                    immediate(31 downto 12) <= (others => instruction(31));
                    store                   <= '0';
                    load                    <= '0';
                    alu_source              <= '0';
                    branch                  <= '0';
                    jump                    <= '0';
                    jalr_flag               <= '0';
                elsif (opcode = TYPE_LOAD) then
                    rd                      <= instruction(11 downto 7);
                    alu_operation           <= opcode & '0' & instruction(14 downto 12);
                    rs1                     <= instruction(19 downto 15);
                    rs2                     <= (others => '0');
                    write                   <= '1';
                    immediate(11 downto 0)  <= instruction(31 downto 20);
                    immediate(31 downto 12) <= (others => instruction(31));
                    store                   <= '0';
                    load                    <= '1';
                    alu_source              <= '0';
                    branch                  <= '0';
                    jump                    <= '0';
                    jalr_flag               <= '0';
                elsif (opcode = TYPE_STORE) then
                    immediate(11 downto 0)  <= instruction(31 downto 25) & instruction(11 downto 7);
                    immediate(31 downto 12) <= (others => instruction(31));
                    rs2                     <= instruction(24 downto 20);
                    rs1                     <= instruction(19 downto 15);
                    alu_operation           <= opcode & '0' & instruction(14 downto 12);
                    store                   <= '1';
                    load                    <= '0';
                    rd                      <= (others => '0');
                    write                   <= '0';
                    alu_source              <= '0';
                    branch                  <= '0';
                    jump                    <= '0';
                    jalr_flag               <= '0';
                elsif (opcode = TYPE_CONDITIONAL) then
                    immediate(12 downto 0)  <= instruction(31) & instruction(7) &
                                               instruction(30 downto 25) & instruction(11 downto 8) & '0';
                    immediate(31 downto 13) <= (others => instruction(31));
                    rs2                     <= instruction(24 downto 20);
                    rs1                     <= instruction(19 downto 15);
                    alu_operation           <= opcode & '0' & instruction(14 downto 12);
                    store                   <= '0';
                    load                    <= '0';
                    rd                      <= (others => '0');
                    write                   <= '0';
                    alu_source              <= '1';
                    branch                  <= '1';
                    jump                    <= '0';
                    jalr_flag               <= '0';
                elsif (opcode = TYPE_JAL) then
                    immediate(20 downto 0)  <= instruction(31) & instruction(19 downto 12) &
                                               instruction(20) & instruction(30 downto 21) & '0';
                    immediate(31 downto 21) <= (others => instruction(31));
                    rd                      <= instruction(11 downto 7);
                    alu_operation           <= opcode & "0000";
                    store                   <= '0';
                    load                    <= '0';
                    rs1                     <= (others => '0');
                    rs2                     <= (others => '0');
                    write                   <= '1';
                    alu_source              <= '0';
                    branch                  <= '0';
                    jump                    <= '1';
                    jalr_flag               <= '0';
                elsif (opcode = TYPE_JALR) then
                    immediate(11 downto 0)  <= instruction(31 downto 20);
                    immediate(31 downto 12) <= (others => instruction(31));
                    rs1                     <= instruction(19 downto 15);
                    alu_operation           <= opcode & '0' & instruction(14 downto 12);
                    rd                      <= instruction(11 downto 7);
                    store                   <= '0';
                    load                    <= '0';
                    rs2                     <= (others => '0');
                    write                   <= '1';
                    alu_source              <= '0';
                    branch                  <= '0';
                    jump                    <= '1';
                    jalr_flag               <= '1';
                elsif (opcode = TYPE_U) then
                    rd            <= instruction(11 downto 7);
                    alu_operation <= opcode & "0000";
                    rs1           <= (others => '0');
                    rs2           <= (others => '0');
                    write         <= '1';
                    immediate     <= instruction(31 downto 12) & "000000000000";
                    store         <= '0';
                    load          <= '0';
                    alu_source    <= '0';
                    branch        <= '0';
                    jump          <= '0';
                    jalr_flag     <= '0';
                elsif (opcode = TYPE_AUIPC) then
                    rd            <= instruction(11 downto 7);
                    alu_operation <= opcode & "0000";
                    rs1           <= (others => '0');
                    rs2           <= (others => '0');
                    write         <= '1';
                    immediate     <= instruction(31 downto 12) & "000000000000";
                    store         <= '0';
                    load          <= '0';
                    alu_source    <= '0';
                    branch        <= '0';
                    jump          <= '0';
                    jalr_flag     <= '0';
                else
                    rd            <= (others => '0');
                    alu_operation <= (others => '0');
                    rs1           <= (others => '0');
                    rs2           <= (others => '0');
                    write         <= '0';
                    immediate     <= (others => '0');
                    store         <= '0';
                    load          <= '0';
                    alu_source    <= '0';
                    branch        <= '0';
                    jump          <= '0';
                    jalr_flag     <= '0';
                    if (opcode /= "0000000") then
                        unknown_instr <= '1';
                    end if;
                end if;
            end if;
        end if;

    end process instruction_decoder;

end architecture rtl;
