library ieee;

package uart_package is

    type tx_state is (
        idle, start, data, stop
    );

end package uart_package;
