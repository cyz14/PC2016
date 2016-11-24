-- test alu

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY testalu IS
END testalu;

ARCHITECTURE RTL OF testalu IS

    Component ALU IS PORT (
        A  :  IN  STD_LOGIC_VECTOR(15 downto 0);
        B  :  IN  STD_LOGIC_VECTOR(15 downto 0);
        OP :  IN  STD_LOGIC_VECTOR(4  downto 0);
        F  :  OUT STD_LOGIC_VECTOR(15 downto 0);
        T  :  OUT STD_LOGIC
    );
    End Component;

    CONSTANT period : time := 200 ps;
    SIGNAL clk, rst : STD_LOGIC := '0';
    SIGNAL a_i, b_i : STD_LOGIC_VECTOR(15 downto 0) := CONV_STD_LOGIC_VECTOR(0, 16);
    SIGNAL op_i     : STD_LOGIC_VECTOR( 3 downto 0) := CONV_STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL F_o      : STD_LOGIC_VECTOR(15 downto 0) := CONV_STD_LOGIC_VECTOR(0, 16);
    SIGNAL T_o      : STD_LOGIC := '0';

Begin
    U_ALU : ALU PORT MAP (
        A => a_i,
        B => b_i,
        OP => op_i,
        F => F_o,
        T => T_o 
    );

    Process()
    Begin


    End Process;

END RTL;