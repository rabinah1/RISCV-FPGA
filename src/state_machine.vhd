library ieee;
use ieee.std_logic_1164.all;
use work.states_package.all;

entity state_machine is
    port (
        clk               : in    std_logic;
        reset             : in    std_logic;
        fetch_enable      : out   std_logic;
        decode_enable     : out   std_logic;
        execute_enable    : out   std_logic;
        write_back_enable : out   std_logic;
        sleep_enable      : out   std_logic
    );
end entity state_machine;

architecture rtl of state_machine is

    signal state      : instruction_state;
    signal next_state : instruction_state;

begin

    state_change : process (clk, reset) is
    begin

        if (reset = '1') then
            state <= fetch;
        elsif (rising_edge(clk)) then
            state <= next_state;
        end if;

    end process state_change;

    state_machine : process (all) is
    begin

        if (reset = '1') then
            fetch_enable      <= '0';
            decode_enable     <= '0';
            execute_enable    <= '0';
            write_back_enable <= '0';
            sleep_enable      <= '0';
            next_state        <= fetch;
        elsif (falling_edge(clk)) then

            case state is

                when fetch =>

                    fetch_enable      <= '1';
                    decode_enable     <= '0';
                    execute_enable    <= '0';
                    write_back_enable <= '0';
                    sleep_enable      <= '0';
                    next_state        <= decode;

                when decode =>

                    fetch_enable      <= '0';
                    decode_enable     <= '1';
                    execute_enable    <= '0';
                    write_back_enable <= '0';
                    sleep_enable      <= '0';
                    next_state        <= execute;

                when execute =>

                    fetch_enable      <= '0';
                    decode_enable     <= '0';
                    execute_enable    <= '1';
                    write_back_enable <= '0';
                    sleep_enable      <= '0';
                    next_state        <= write_back;

                when write_back =>

                    fetch_enable      <= '0';
                    decode_enable     <= '0';
                    execute_enable    <= '0';
                    write_back_enable <= '1';
                    sleep_enable      <= '0';
                    next_state        <= sleep;

                when sleep =>

                    fetch_enable      <= '0';
                    decode_enable     <= '0';
                    execute_enable    <= '0';
                    write_back_enable <= '0';
                    sleep_enable      <= '1';
                    next_state        <= fetch;

            end case;

        end if;

    end process state_machine;

end architecture rtl;
