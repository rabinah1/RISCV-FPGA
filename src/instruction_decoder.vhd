library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity instruction_decoder is
    port (
        clk            : in    std_logic;
        reset          : in    std_logic;
        instruction_in : in    std_logic_vector(31 downto 0);
        rs1            : out   std_logic_vector(4 downto 0);
        rs2            : out   std_logic_vector(4 downto 0);
        rd             : out   std_logic_vector(4 downto 0);
        write          : out   std_logic;
        alu_operation  : out   std_logic_vector(10 downto 0);
        alu_source     : out   std_logic;
        immediate      : out   std_logic_vector(31 downto 0);
        load           : out   std_logic;
        store          : out   std_logic;
        branch         : out   std_logic
    );
end entity instruction_decoder;

architecture rtl of instruction_decoder is

begin

    instruction_decoder : process (all) is

        variable opcode : std_logic_vector(6 downto 0);

    begin

        if (reset = '1') then
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
            opcode        := (others => '0');
        elsif (rising_edge(clk)) then
            opcode := instruction_in(6 downto 0);
            if (opcode = "0110011") then -- R-type
                rd            <= instruction_in(11 downto 7);
                alu_operation <= opcode & instruction_in(30) & instruction_in(14 downto 12);
                rs1           <= instruction_in(19 downto 15);
                rs2           <= instruction_in(24 downto 20);
                write         <= '1';
                store         <= '0';
                load          <= '0';
                immediate     <= (others => '0');
                alu_source    <= '1';
                branch        <= '0';
            elsif (opcode = "0010011") then -- I-type
                rd                      <= instruction_in(11 downto 7);
                alu_operation           <= opcode & '0' & instruction_in(14 downto 12);
                rs1                     <= instruction_in(19 downto 15);
                rs2                     <= (others => '0');
                write                   <= '1';
                immediate(11 downto 0)  <= instruction_in(31 downto 20);
                immediate(31 downto 12) <= (others => instruction_in(31));
                store                   <= '0';
                load                    <= '0';
                alu_source              <= '0';
                branch                  <= '0';
            elsif (opcode = "0000011") then -- Load
                rd                      <= instruction_in(11 downto 7);
                alu_operation           <= opcode & '0' & instruction_in(14 downto 12);
                rs1                     <= instruction_in(19 downto 15);
                rs2                     <= (others => '0');
                write                   <= '1';
                immediate(11 downto 0)  <= instruction_in(31 downto 20);
                immediate(31 downto 12) <= (others => instruction_in(31));
                store                   <= '0';
                load                    <= '1';
                alu_source              <= '0';
                branch                  <= '0';
            elsif (opcode = "0100011") then -- Store
                immediate(11 downto 0)  <= instruction_in(31 downto 25) & instruction_in(11 downto 7);
                immediate(31 downto 12) <= (others => instruction_in(31));
                rs2                     <= instruction_in(24 downto 20);
                rs1                     <= instruction_in(19 downto 15);
                alu_operation           <= opcode & '0' & instruction_in(14 downto 12);
                store                   <= '1';
                load                    <= '0';
                rd                      <= (others => '0');
                write                   <= '1';
                alu_source              <= '0';
                branch                  <= '0';
            elsif (opcode = "1100011") then -- Conditional
                immediate(12 downto 0)  <= instruction_in(31) & instruction_in(7) &
                                           instruction_in(30 downto 25) & instruction_in(11 downto 8) & '0';
                immediate(31 downto 13) <= (others => instruction_in(31));
                rs2                     <= instruction_in(24 downto 20);
                rs1                     <= instruction_in(19 downto 15);
                alu_operation           <= opcode & '0' & instruction_in(14 downto 12);
                store                   <= '0';
                load                    <= '0';
                rd                      <= (others => '0');
                write                   <= '1';
                alu_source              <= '1';
                branch                  <= '1';
            elsif (opcode = "1101111") then -- JAL
                immediate(20 downto 0)  <= instruction_in(31) & instruction_in(19 downto 12) &
                                           instruction_in(20) & instruction_in(30 downto 21) & '0';
                immediate(31 downto 21) <= (others => instruction_in(31));
                rd                      <= instruction_in(11 downto 7);
                alu_operation           <= (others => '0');
                store                   <= '0';
                load                    <= '0';
                rs1                     <= (others => '0');
                rs2                     <= (others => '0');
                write                   <= '1';
                alu_source              <= '0';
                branch                  <= '0';
            elsif (opcode = "1100111") then -- JALR
                immediate(11 downto 0)  <= instruction_in(31 downto 20);
                immediate(31 downto 12) <= (others => instruction_in(31));
                rs1                     <= instruction_in(19 downto 15);
                alu_operation           <= opcode & '0' & instruction_in(14 downto 12);
                rd                      <= instruction_in(11 downto 7);
                store                   <= '0';
                load                    <= '0';
                rs2                     <= (others => '0');
                write                   <= '1';
                alu_source              <= '0';
                branch                  <= '0';
            end if;
        end if;

    end process instruction_decoder;

end architecture rtl;
