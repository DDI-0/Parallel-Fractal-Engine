---- this file is part of the ADS library

library ads;
use ads.ads_fixed_pkg.all;

package ads_complex_pkg is
	-- complex number in rectangular form
	type ads_complex is record
		re: ads_fixed;
		im: ads_fixed;
	end record ads_complex;

	---- functions

	-- make a complex number
	function ads_cmplx (
			re, im: in ads_fixed
		) return ads_complex;

	-- returns l + r
	function "+" (
			l, r: in ads_complex
		) return ads_complex;

	-- returns l - r
	function "-" (
			l, r: in ads_complex
		) return ads_complex;

	-- returns l * r
	function "*" (
			l, r: in ads_complex
		) return ads_complex;

	-- returns the complex conjugate of arg
	function conj (
			arg: in ads_complex
		) return ads_complex;

	-- returns || arg || ** 2
	function abs2 (
			arg: in ads_complex
		) return ads_fixed;

	-- constants
	  constant complex_zero : ads_complex; 


end package ads_complex_pkg;

package body ads_complex_pkg is

    -- constructor
    function ads_cmplx (
        re, im: in ads_fixed
    ) return ads_complex is
        variable ret : ads_complex;
    begin
        ret.re := re;
        ret.im := im;
        return ret;
    end function ads_cmplx;

    -- addition
    function "+" (
        l, r: in ads_complex
    ) return ads_complex is
        variable ret: ads_complex;
    begin
        ret.re := l.re + r.re;
        ret.im := l.im + r.im;
        return ret;
    end function "+";

    -- subtraction
    function "-" (
        l, r: in ads_complex
    ) return ads_complex is
        variable ret: ads_complex;
    begin
        ret.re := l.re - r.re;
        ret.im := l.im - r.im;
        return ret;
    end function "-";

    -- multiplication
    function "*" (
        l, r: in ads_complex
    ) return ads_complex is
        variable ret: ads_complex;
    begin
        -- (a+jb)(c+jd) = (ac - bd) + j(ad + bc)
        ret.re := (l.re * r.re) - (l.im * r.im);
        ret.im := (l.re * r.im) + (l.im * r.re);
        return ret;
    end function "*";

    -- complex conjugate
    function conj (
        arg: in ads_complex
    ) return ads_complex is
        variable ret: ads_complex;
    begin
        ret.re := arg.re;
        ret.im := -arg.im;
        return ret;
    end function conj;

    -- squared magnitude: |arg|^2 = re^2 + im^2
    function abs2 (
        arg: in ads_complex
    ) return ads_fixed is
    begin
        return (arg.re * arg.re) + (arg.im * arg.im);
    end function abs2;
	 
	 constant complex_zero : ads_complex :=
		ads_cmplx(to_ads_fixed(0), to_ads_fixed(0));

end package body ads_complex_pkg;