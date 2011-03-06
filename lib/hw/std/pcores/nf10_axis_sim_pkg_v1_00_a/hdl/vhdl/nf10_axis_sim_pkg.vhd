------------------------------------------------------------------------
--
--  NetFPGA-10G http://www.netfpga.org
--
--  Module:
--	    nf10_axis_sim_pkg.vhd
--
--  Description:
--	    Stream simulation I/O support package.
--
------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

use std.textio.all;
use ieee.std_logic_textio.all;

package nf10_axis_sim_pkg is
    -----------------------------------------------------------------------
    -- lookahead_char()
    --
    --	Non-destructively parse line for first non-whitespace character.
    procedure lookahead_char( l: inout line; c: out character );

    -----------------------------------------------------------------------
    -- read_char()
    --
    --	Read (as a variable) first non-whitespace character.
    procedure read_char( l: inout line; c: out character );

    -----------------------------------------------------------------------
    -- parse_int()
    --
    --	Read (as a variable) an integer from the text line.
    procedure parse_int( l: inout line; i: out integer );

    -----------------------------------------------------------------------
    -- parse_slv()
    --
    --	Read (and drive, as a signal) a standard logic vector from the
    --	text line.
    procedure parse_slv( l: inout line;
			 signal slv: out std_logic_vector );

end;

package body nf10_axis_sim_pkg is
    -----------------------------------------------------------------------
    -- lookahead_char()
    --
    --	Non-destructively parse line for first non-whitespace character.
    procedure lookahead_char( l: inout line; c: out character ) is
	variable i: natural;
    begin
	for i in 1 to l.all'length loop
	    if l(i) /= ' ' and l(i) /= ht then
		c := l(i);
		exit;
	    end if;
	end loop;
    end procedure;

    -----------------------------------------------------------------------
    -- read_char()
    --
    --	Read (as a variable) first non-whitespace character.
    procedure read_char( l: inout line; c: out character ) is
	variable tmp: character;
    begin
	while l.all /= "" loop
	    read( l, tmp );  		-- destructively read a space from
					-- the line
	    if tmp /= ' ' and tmp /= ht then
		c := tmp;
		exit;
	    end if;
	end loop;
    end procedure;

    -----------------------------------------------------------------------
    -- parse_int()
    --
    --	Read (as a variable) an integer from the text line.
    procedure parse_int( l: inout line; i: out integer ) is
	variable good: boolean;
    begin
	read( l, i, good );
	assert good
	    report "bad input: expected an integer: " & l(l'left to l'right)
	    severity failure;
    end procedure;

    -----------------------------------------------------------------------
    -- parse_slv()
    --
    --	Read (and drive, as a signal) a standard logic vector from the
    --	text line.
    procedure parse_slv( l: inout line;
			 signal slv: out std_logic_vector ) is
	variable val: std_logic_vector(slv'range);
	variable good: boolean;
    begin
	hread( l, val, good );
	assert good
	    report "bad input: expected a hex string: " & l(l'left to l'right)
	    severity failure;
	slv <= val;
    end procedure;

end;
