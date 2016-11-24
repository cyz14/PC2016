--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package common is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--


CONSTANT Dst_R0   : std_logic_vector (3 downto 0) := "0000";
CONSTANT Dst_R1   : std_logic_vector (3 downto 0) := "0001";
constant Dst_R2   : std_logic_vector (3 downto 0) := "0010";
constant Dst_R3   : std_logic_vector (3 downto 0) := "0011";
constant Dst_R4   : std_logic_vector (3 downto 0) := "0100";
constant Dst_R5   : std_logic_vector (3 downto 0) := "0101";
constant Dst_R6   : std_logic_vector (3 downto 0) := "0110";
constant Dst_R7   : std_logic_vector (3 downto 0) := "0111";
constant Dst_NONE : std_logic_vector (3 downto 0) := "1000";
constant Dst_SP   : std_logic_vector (3 downto 0) := "1001";
constant Dst_T    : std_logic_vector (3 downto 0) := "1010";
constant Dst_IH   : std_logic_vector (3 downto 0) := "1011";

CONSTANT OP_NONE : std_logic_vector (3 downto 0) := "0000";
CONSTANT OP_ADD  : std_logic_vector (3 downto 0) := "0001";
constant OP_SUB  : std_logic_vector (3 downto 0) := "0010";
constant OP_AND  : std_logic_vector (3 downto 0) := "0011";
constant OP_OR   : std_logic_vector (3 downto 0) := "0100";
constant OP_XOR  : std_logic_vector (3 downto 0) := "0101";
constant OP_CMP  : std_logic_vector (3 downto 0) := "0110";
constant OP_LT   : std_logic_vector (3 downto 0) := "0111";
constant OP_POS  : std_logic_vector (3 downto 0) := "1000";
constant OP_SLL  : std_logic_vector (3 downto 0) := "1001";
constant OP_SRL  : std_logic_vector (3 downto 0) := "1010";
constant OP_SRA  : std_logic_vector (3 downto 0) := "1011";



CONSTANT IMM_NONE   : std_logic_vector (2 downto 0) := "000";
CONSTANT IMM_THREE  : std_logic_vector (2 downto 0) := "001";
CONSTANT IMM_FOUR   : std_logic_vector (2 downto 0) := "010";
CONSTANT IMM_FIVE   : std_logic_vector (2 downto 0) := "011";
CONSTANT IMM_EIGHT  : std_logic_vector (2 downto 0) := "100";
CONSTANT IMM_ELEVEN : std_logic_vector (2 downto 0) := "101";



CONSTANT PC_None   : std_logic_vector(1 downto 0) := "00";
CONSTANT PC_Add1   : std_logic_vector(1 downto 0) := "01";
CONSTANT PC_Rx     : std_logic_vector(1 downto 0) := "10";
CONSTANT PC_AddImm : std_logic_vector(1 downto 0) := "11";


-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--

CONSTANT ZERO16 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";


-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end common;

package body common is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end common;
