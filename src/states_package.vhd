library ieee;

package states_package is

    type instruction_state is (
        fetch, decode, execute, write_back
    );

end package states_package;
