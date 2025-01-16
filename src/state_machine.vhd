library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.states_package.all;

entity state_machine is
    port (
        clk                : in    std_logic;
        reset              : in    std_logic;
        trig_state_machine : in    std_logic;
        fetch_enable       : out   std_logic;
        decode_enable      : out   std_logic;
        execute_enable     : out   std_logic;
        write_back_enable  : out   std_logic
    );
end entity state_machine;

architecture rtl of state_machine is

    signal state      : instruction_state;
    signal next_state : instruction_state;

begin

    state_change : process (clk, reset) is
    begin

        if (reset = '1') then
            state <= nop;
        elsif (falling_edge(clk)) then
            state <= next_state;
        end if;

    end process state_change;

    state_machine : process (all) is

        variable wait_cycle : std_logic;

    begin

        if (reset = '1') then
            fetch_enable      <= '0';
            decode_enable     <= '0';
            execute_enable    <= '0';
            write_back_enable <= '0';
            next_state        <= nop;
            wait_cycle        := '1';
        elsif (rising_edge(clk)) then

            case state is

                when nop =>

                    fetch_enable      <= '0';
                    decode_enable     <= '0';
                    execute_enable    <= '0';
                    write_back_enable <= '0';
                    if (trig_state_machine = '0') then
                        next_state <= nop;
                    else
                        if (wait_cycle = '1') then
                            next_state <= nop;
                            wait_cycle := '0';
                        else
                            next_state <= fetch;
                            wait_cycle := '1';
                        end if;
                    end if;

                when fetch =>

                    fetch_enable      <= '1';
                    decode_enable     <= '0';
                    execute_enable    <= '0';
                    write_back_enable <= '0';
                    if (wait_cycle = '1') then
                        next_state <= fetch;
                        wait_cycle := '0';
                    else
                        next_state <= decode;
                        wait_cycle := '1';
                    end if;

                when decode =>

                    fetch_enable      <= '0';
                    decode_enable     <= '1';
                    execute_enable    <= '0';
                    write_back_enable <= '0';
                    if (wait_cycle = '1') then
                        next_state <= decode;
                        wait_cycle := '0';
                    else
                        next_state <= execute;
                        wait_cycle := '1';
                    end if;

                when execute =>

                    fetch_enable      <= '0';
                    decode_enable     <= '0';
                    execute_enable    <= '1';
                    write_back_enable <= '0';
                    if (wait_cycle = '1') then
                        next_state <= execute;
                        wait_cycle := '0';
                    else
                        next_state <= write_back;
                        wait_cycle := '1';
                    end if;

                when write_back =>

                    fetch_enable      <= '0';
                    decode_enable     <= '0';
                    execute_enable    <= '0';
                    write_back_enable <= '1';
                    if (wait_cycle = '1') then
                        next_state <= write_back;
                        wait_cycle := '0';
                    else
                        next_state <= fetch;
                        wait_cycle := '1';
                    end if;

            end case;

        end if;

    end process state_machine;

end architecture rtl;
