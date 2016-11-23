-- MUX_IF_ID.vhd

ENTITY MUX_IF_ID IS PORT (
    InsType :  OUT    STD_LOGIC_VECTOR(4  downto 0);
    rx      :  OUT    STD_LOGIC_VECTOR(2  downto 0);
    ry      :  OUT    STD_LOGIC_VECTOR(2  downto 0);
    rz      :  OUT    STD_LOGIC_VECTOR(2  downto 0);
    funct   :  OUT    STD_LOGIC_VECTOR(1  downto 0);
    imme    :  OUT    STD_LOGIC_VECTOR(7  downto 0)
);
END MUX_IF_ID;

ARCHITECTURE Behaviour OF MUX_IF_ID IS

BEGIN


END Behaviour;