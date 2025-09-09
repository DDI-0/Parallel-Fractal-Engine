library ieee;
use ieee.math_real.all;

package util_pkg is
    function num_bits (val: in positive) return positive;
end package util_pkg;

package body util_pkg is
    function num_bits (val: in positive) return positive is
        variable result : real;
    begin
        result := log(real(val)) / log(2.0);
        return positive (ceil(result));
    end function num_bits;
end package body util_pkg;