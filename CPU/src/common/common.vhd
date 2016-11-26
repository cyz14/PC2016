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


-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--

CONSTANT ONE16  : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000001";

CONSTANT ZERO1  : STD_LOGIC                     := '0';
CONSTANT ZERO2  : STD_LOGIC_VECTOR( 1 downto 0) := "00";
CONSTANT ZERO3  : STD_LOGIC_VECTOR( 2 downto 0) := "000";
CONSTANT ZERO4  : STD_LOGIC_VECTOR( 3 downto 0) := "0000";
CONSTANT ZERO16 : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

CONSTANT MEM_WRITE_ENABLE  : STD_LOGIC := '0';
CONSTANT MEM_WRITE_DISABLE : STD_LOGIC := '1';
CONSTANT MEM_READ_ENABLE   : STD_LOGIC := '0'; 
CONSTANT MEM_READ_DISABLE  : STD_LOGIC := '1';
CONSTANT INST_VALID        : STD_LOGIC := '0';
CONSTANT INST_INVALID      : STD_LOGIC := '1';
CONSTANT CHIP_ENABLE       : STD_LOGIC := '0';
CONSTANT CHIP_DISABLE      : STD_LOGIC := '1';

CONSTANT RAM_ENABLE        : STD_LOGIC := '0';
CONSTANT RAM_DISABLE       : STD_LOGIC := '1';
CONSTANT RAM_READ_ENABLE   : STD_LOGIC := '0';
CONSTANT RAM_READ_DISABLE  : STD_LOGIC := '1';
CONSTANT RAM_WRITE_ENABLE  : STD_LOGIC := '0';
CONSTANT RAM_WRITE_DISABLE : STD_LOGIC := '1';

CONSTANT KEEP_ENABLE       : STD_LOGIC := '0';
CONSTANT KEEP_DISABLE      : STD_LOGIC := '1';


CONSTANT TYPE_ADD_SUB :  STD_LOGIC_VECTOR(4 downto 0) := "11100";
CONSTANT TYPE_AND_OR_CMP_MFPC_SLLV_SRLV_JR: STD_LOGIC_VECTOR(4 downto 0) := "11101";
CONSTANT TYPE_MFIH_MTIH : STD_LOGIC_VECTOR(4 downto 0):= "11110";
CONSTANT TYPE_MTSP_ADDSP_BTEQZ_BTNEZ :  STD_LOGIC_VECTOR(4 downto 0) := "01100";
CONSTANT TYPE_SLL_SRA :  STD_LOGIC_VECTOR(4 downto 0) := "00110";
CONSTANT TYPE_MOVE    :  STD_LOGIC_VECTOR(4 downto 0) := "01111";
CONSTANT TYPE_ADDIU   :  STD_LOGIC_VECTOR(4 downto 0) := "01001";
CONSTANT TYPE_ADDIU3  :  STD_LOGIC_VECTOR(4 downto 0) := "01000";
CONSTANT TYPE_LI      :  STD_LOGIC_VECTOR(4 downto 0) := "01101";
CONSTANT TYPE_SLTI    :  STD_LOGIC_VECTOR(4 downto 0) := "01010";
CONSTANT TYPE_LW      :  STD_LOGIC_VECTOR(4 downto 0) := "10011";
CONSTANT TYPE_LW_SP   :  STD_LOGIC_VECTOR(4 downto 0) := "10010";
CONSTANT TYPE_SW      :  STD_LOGIC_VECTOR(4 downto 0) := "11011";
CONSTANT TYPE_SW_SP   :  STD_LOGIC_VECTOR(4 downto 0) := "11010";
CONSTANT TYPE_B       :  STD_LOGIC_VECTOR(4 downto 0) := "00010";
CONSTANT TYPE_BEQZ    :  STD_LOGIC_VECTOR(4 downto 0) := "00100";
CONSTANT TYPE_BNEZ    :  STD_LOGIC_VECTOR(4 downto 0) := "00101";
-- CONSTANT TYPE_JR      :  STD_LOGIC_VECTOR(4 downto 0) := "11101";
CONSTANT TYPE_NOP     :  STD_LOGIC_VECTOR(4 downto 0) := "00001";
-- CONSTANT InstNop   :  STD_LOGIC_VECTOR(15 downto 0):= "0000100000000000";

CONSTANT FUNCT_ADD    :  STD_LOGIC_VECTOR(1 downto 0) := "01";
CONSTANT FUNCT_SUB    :  STD_LOGIC_VECTOR(1 downto 0) := "11";

CONSTANT FUNCT_AND    :  STD_LOGIC_VECTOR(4 downto 0) := "01100";
CONSTANT FUNCT_OR     :  STD_LOGIC_VECTOR(4 downto 0) := "01101";
CONSTANT FUNCT_CMP    :  STD_LOGIC_VECTOR(4 downto 0) := "01010";
CONSTANT FUNCT_SLLV   :  STD_LOGIC_VECTOR(4 downto 0) := "00100";
CONSTANT FUNCT_SRLV   :  STD_LOGIC_VECTOR(4 downto 0) := "00110";
CONSTANT FUNCT_MFPC_JR:  STD_LOGIC_VECTOR(4 downto 0) := "00000";
CONSTANT FUNCT_MFPC   :  STD_LOGIC_VECTOR(2 downto 0) := "010";
CONSTANT FUNCT_JR     :  STD_LOGIC_VECTOR(2 downto 0) := "000";

CONSTANT FUNCT_MFIH   :  STD_LOGIC_VECTOR(7 downto 0) := "00000000";
CONSTANT FUNCT_MTIH   :  STD_LOGIC_VECTOR(7 downto 0) := "00000001";

CONSTANT FUNCT_MTSP   :  STD_LOGIC_VECTOR(2 downto 0) := "100";
CONSTANT FUNCT_ADDSP  :  STD_LOGIC_VECTOR(2 downto 0) := "011";
CONSTANT FUNCT_BTEQZ  :  STD_LOGIC_VECTOR(2 downto 0) := "000";
CONSTANT FUNCT_BTNEZ  :  STD_LOGIC_VECTOR(2 downto 0) := "001";

CONSTANT FUNCT_SLL    :  STD_LOGIC_VECTOR(1 downto 0) := "00";
CONSTANT FUNCT_SRA    :  STD_LOGIC_VECTOR(1 downto 0) := "11";

-- RegisterFile DataSrc
constant DS_NONE    : std_logic_vector(2 downto 0) := "000";
constant DS_RX      : std_logic_vector(2 downto 0) := "001";
constant DS_RY      : std_logic_vector(2 downto 0) := "010";
constant DS_PCplus1 : std_logic_vector(2 downto 0) := "011";
constant DS_SP      : std_logic_vector(2 downto 0) := "100";
constant DS_IH      : std_logic_vector(2 downto 0) := "101";
constant DS_T       : std_logic_vector(2 downto 0) := "110";

-- ALU oprand Src
constant AS_NONE  : std_logic_vector(1 downto 0) := "00";
constant AS_DATA1 : std_logic_vector(1 downto 0) := "01";
constant AS_DATA2 : std_logic_vector(1 downto 0) := "10";
constant AS_IMME  : std_logic_vector(1 downto 0) := "11";

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
constant Dst_PC   : std_logic_vector (3 downto 0) := "1100";

-- ALU op code
CONSTANT OP_NONE : std_logic_vector (3 downto 0) := "0000";
CONSTANT OP_ADD  : std_logic_vector (3 downto 0) := "0001";
constant OP_SUB  : std_logic_vector (3 downto 0) := "0010";
constant OP_AND  : std_logic_vector (3 downto 0) := "0011";
constant OP_OR   : std_logic_vector (3 downto 0) := "0100";
constant OP_XOR  : std_logic_vector (3 downto 0) := "0101";
constant OP_CMP  : std_logic_vector (3 downto 0) := "0110";
constant OP_LT   : std_logic_vector (3 downto 0) := "0111"; -- LessThan op in SLTI
constant OP_POS  : std_logic_vector (3 downto 0) := "1000";
constant OP_SLL  : std_logic_vector (3 downto 0) := "1001";
constant OP_SRL  : std_logic_vector (3 downto 0) := "1010";
constant OP_SRA  : std_logic_vector (3 downto 0) := "1011";

-- Immediate Source
CONSTANT IMM_NONE   : std_logic_vector (2 downto 0) := "000";
CONSTANT IMM_THREE  : std_logic_vector (2 downto 0) := "001";
CONSTANT IMM_FOUR   : std_logic_vector (2 downto 0) := "010";
CONSTANT IMM_FIVE   : std_logic_vector (2 downto 0) := "011";
CONSTANT IMM_EIGHT  : std_logic_vector (2 downto 0) := "100";
CONSTANT IMM_ELEVEN : std_logic_vector (2 downto 0) := "101";

-- PCMux Signal
CONSTANT PC_None   : std_logic_vector(1 downto 0) := "00";
CONSTANT PC_Add1   : std_logic_vector(1 downto 0) := "01";
CONSTANT PC_Rx     : std_logic_vector(1 downto 0) := "10";
CONSTANT PC_AddImm : std_logic_vector(1 downto 0) := "11";

-- VGA background color
CONSTANT background_r:  STD_LOGIC_VECTOR(2 downto 0) := ZERO3;
CONSTANT background_g:  STD_LOGIC_VECTOR(2 downto 0) := ZERO3;
CONSTANT background_b:  STD_LOGIC_VECTOR(2 downto 0) := ZERO3;

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
