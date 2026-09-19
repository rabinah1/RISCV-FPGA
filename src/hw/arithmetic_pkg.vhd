library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package arithmetic_pkg is

    function add_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function sub_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function shift_left_logical (
        in_value : std_logic_vector(31 downto 0);
        in_shift : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function shift_right_logical (
        in_value : std_logic_vector(31 downto 0);
        in_shift : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function shift_right_arithmetic (
        in_value : std_logic_vector(31 downto 0);
        in_shift : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function is_less_than_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function is_less_than_unsigned (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function is_equal (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function is_not_equal (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function is_greater_equal_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function is_greater_equal_unsigned (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function byte_addr_to_word_addr (
        byte_addr : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function word_addr_to_byte_addr (
        word_addr : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function mul_signed_low (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function mul_signed_high (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function mul_unsigned_high (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function mul_signed_unsigned_high (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function div_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function div_unsigned (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function rem_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

    function rem_unsigned (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector;

end package arithmetic_pkg;

package body arithmetic_pkg is

    function add_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        return std_logic_vector(signed(in_1) + signed(in_2));

    end function add_signed;

    function sub_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        return std_logic_vector(signed(in_1) - signed(in_2));

    end function sub_signed;

    function shift_left_logical (
        in_value : std_logic_vector(31 downto 0);
        in_shift : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        return std_logic_vector(shift_left(unsigned(in_value), to_integer(unsigned(in_shift))));

    end function shift_left_logical;

    function shift_right_logical (
        in_value : std_logic_vector(31 downto 0);
        in_shift : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        return std_logic_vector(shift_right(unsigned(in_value), to_integer(unsigned(in_shift))));

    end function shift_right_logical;

    function shift_right_arithmetic (
        in_value : std_logic_vector(31 downto 0);
        in_shift : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        return std_logic_vector(shift_right(signed(in_value), to_integer(unsigned(in_shift))));

    end function shift_right_arithmetic;

    function is_less_than_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        if (signed(in_1) < signed(in_2)) then
            return std_logic_vector(to_signed(1, 32));
        else
            return std_logic_vector(to_signed(0, 32));
        end if;

    end function is_less_than_signed;

    function is_less_than_unsigned (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        if (unsigned(in_1) < unsigned(in_2)) then
            return std_logic_vector(to_signed(1, 32));
        else
            return std_logic_vector(to_signed(0, 32));
        end if;

    end function is_less_than_unsigned;

    function is_equal (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        if (unsigned(in_1) = unsigned(in_2)) then
            return std_logic_vector(to_signed(1, 32));
        else
            return std_logic_vector(to_signed(0, 32));
        end if;

    end function is_equal;

    function is_not_equal (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        if (unsigned(in_1) /= unsigned(in_2)) then
            return std_logic_vector(to_signed(1, 32));
        else
            return std_logic_vector(to_signed(0, 32));
        end if;

    end function is_not_equal;

    function is_greater_equal_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        if (signed(in_1) >= signed(in_2)) then
            return std_logic_vector(to_signed(1, 32));
        else
            return std_logic_vector(to_signed(0, 32));
        end if;

    end function is_greater_equal_signed;

    function is_greater_equal_unsigned (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        if (unsigned(in_1) >= unsigned(in_2)) then
            return std_logic_vector(to_signed(1, 32));
        else
            return std_logic_vector(to_signed(0, 32));
        end if;

    end function is_greater_equal_unsigned;

    function byte_addr_to_word_addr (
        byte_addr : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        return byte_addr(31) & "00" & byte_addr(30 downto 2);

    end function byte_addr_to_word_addr;

    function word_addr_to_byte_addr (
        word_addr : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        return word_addr(31) & word_addr(28 downto 0) & "00";

    end function word_addr_to_byte_addr;

    function mul_signed_low (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is

        variable full_result : std_logic_vector(63 downto 0);

    begin

        full_result := std_logic_vector(signed(in_1) * signed(in_2));
        return full_result(31 downto 0);

    end function mul_signed_low;

    function mul_signed_high (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is

        variable full_result : std_logic_vector(63 downto 0);

    begin

        full_result := std_logic_vector(signed(in_1) * signed(in_2));
        return full_result(63 downto 32);

    end function mul_signed_high;

    function mul_unsigned_high (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is

        variable full_result : std_logic_vector(63 downto 0);

    begin

        full_result := std_logic_vector(unsigned(in_1) * unsigned(in_2));
        return full_result(63 downto 32);

    end function mul_unsigned_high;

    function mul_signed_unsigned_high (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is

        variable full_result : std_logic_vector(64 downto 0);

    begin

        full_result := std_logic_vector(signed(in_1) * ('0' & signed(in_2)));
        return full_result(63 downto 32);

    end function mul_signed_unsigned_high;

    function div_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        return std_logic_vector(signed(in_1) / signed(in_2));

    end function div_signed;

    function div_unsigned (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        return std_logic_vector(unsigned(in_1) / unsigned(in_2));

    end function div_unsigned;

    function rem_signed (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        return std_logic_vector(signed(in_1) rem signed(in_2));

    end function rem_signed;

    function rem_unsigned (
        in_1 : std_logic_vector(31 downto 0);
        in_2 : std_logic_vector(31 downto 0)
    ) return std_logic_vector is
    begin

        return std_logic_vector(unsigned(in_1) rem unsigned(in_2));

    end function rem_unsigned;

end package body arithmetic_pkg;
