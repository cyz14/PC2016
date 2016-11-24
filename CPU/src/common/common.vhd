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
type WriteRegDst is (
    Dst_R0, Dst_R1, Dst_R2, Dst_R3, Dst_R4, Dst_R5, Dst_R6, Dst_R7,
    Dst_SP, Dst_T, Dst_IH
);

Type ALUOP IS (
    OP_NONE,-- No operation 
    OP_ADD, -- F <= A  +  B
    OP_SUB, -- F <= A  -  B
    OP_AND, -- F <= A  &  B
    OP_OR,  -- F <= A  |  B
    OP_XOR, -- F <= A xor B
    OP_CMP, -- F <= A !=  B, not equal
    OP_LT,  -- F <= A  <  B
    OP_POS, -- F <= A
    OP_SLL, -- F <= A <<  B
    OP_SRL, -- F <= A >>  B(logical)
    OP_SRA  -- F <= A >>  B(arith)
    );



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
