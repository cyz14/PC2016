-- Control.vhd

ENTITY Control IS PORT (
    InsType :  IN  STD_LOGIC_VECTOR(4 downto 0);
    Funct   :  IN  STD_LOGIC_VECTOR(1 downto 0)
    WB      :  OUT STD_LOGIC_VECTOR();
);
END ENTITY;

ARCHITECTURE Behaviour OF Control IS
    Component Ctrl_WB IS PORT(

    );
    END Component;

    Component Ctrl_M IS PORT (

    );
    END Component;

    Component Ctrl_EXE IS PORT (
        InsType :  In  STD_LOGIC_VECTOR(4 downto 0);
        funct   :  IN  STD_LOGIC_VECTOR(1 downto 0);
        ALUop   :  OUT STD_LOGIC_VECTOR(3 downto 0)
    );
    END Component;
BEGIN


END ARCHITECTURE;
