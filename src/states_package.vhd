library ieee;

package states_package is

    type instruction_state is (
        idle, fetch, decode, execute, write_back
    );

end package states_package;
