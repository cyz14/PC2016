library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

use std.textio.all;

entity testbench is
end entity testbench;

architecture RTL of testbench is
    signal clk : std_logic := '1';
    signal rst : std_logic := '0';

    constant PERIOD : time := 200 ps;
    constant MAX_ADDR : integer := 65535;
    type RAM is array(natural range <>) of std_logic_vector(15 downto 0);

    signal hda1_init : std_logic := '0';
    signal hda2_init : std_logic := '0';
    signal hda1, hda2 : RAM(0 to 40000); -- 小空间便于查看

    component CPU IS PORT (
        CLK     :    IN    STD_LOGIC; -- 
        CLK_11  :    IN    STD_LOGIC; -- 11M
        CLK_50  :    IN    STD_LOGIC; -- 50M
        RST     :    IN    STD_LOGIC;

        INT     :    IN    STD_LOGIC;
        
        Ram1_en:     OUT   STD_LOGIC;
        Ram1_oe:     OUT   STD_LOGIC;
        Ram1_we:     OUT   STD_LOGIC;
        RAM1_Addr:   OUT   STD_LOGIC_VECTOR(17 downto 0);
        Ram1_Data:   INOUT STD_LOGIC_VECTOR(15 downto 0);
        Ram2_en:     OUT   STD_LOGIC;
        Ram2_oe:     OUT   STD_LOGIC;
        Ram2_we:     OUT   STD_LOGIC;
        RAM2_Addr:   OUT   STD_LOGIC_VECTOR(17 downto 0);
        Ram2_Data:   INOUT STD_LOGIC_VECTOR(15 downto 0);
        
        rdn:         OUT   STD_LOGIC;
        wrn:         OUT   STD_LOGIC;
        data_ready:  IN    STD_LOGIC;
        tbre:        IN    STD_LOGIC;
        tsre:        IN    STD_LOGIC;
        
        ps2clk     : in    STD_LOGIC;
        ps2data    : in    STD_LOGIC;

        VGA_R:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
        VGA_G:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
        VGA_B:       OUT   STD_LOGIC_VECTOR( 2 downto 0);
        Hs:          OUT   STD_LOGIC;
        Vs:          OUT   STD_LOGIC;
        
        --FLASH
        -- flash_byte : OUT STD_LOGIC := '1'; 
        -- flash_vpen : OUT STD_LOGIC := '1';
        -- flash_ce   : OUT STD_LOGIC := '0';
        -- flash_oe   : OUT STD_LOGIC := '1';
        -- flash_we   : OUT STD_LOGIC := '1';
        -- flash_rp   : OUT STD_LOGIC := '0';
        -- flash_addr : OUT STD_LOGIC_VECTOR( 22 downto 1 ) := "0000000000000000000000";
        -- flash_data : INOUT STD_LOGIC_VECTOR( 15 downto 0 );
        
        -- used to display debug info
        SW         : IN    STD_LOGIC_VECTOR(15 downto 0);
        LED        : OUT   STD_LOGIC_VECTOR(15 downto 0);
        Number1    : OUT   STD_LOGIC_VECTOR( 6 downto 0);
        Number0    : OUT   STD_LOGIC_VECTOR( 6 downto 0)
    );
    END component;

    signal CLK_11  :       STD_LOGIC; -- 11M
    signal CLK_50  :       STD_LOGIC; -- 50M

    signal INT     :       STD_LOGIC;

    signal Ram1_en:        STD_LOGIC;
    signal Ram1_oe:        STD_LOGIC;
    signal Ram1_we:        STD_LOGIC;
    signal RAM1_Addr:      STD_LOGIC_VECTOR(17 downto 0);
    signal Ram1_Data:      STD_LOGIC_VECTOR(15 downto 0);
    signal Ram2_en:        STD_LOGIC;
    signal Ram2_oe:        STD_LOGIC;
    signal Ram2_we:        STD_LOGIC;
    signal RAM2_Addr:      STD_LOGIC_VECTOR(17 downto 0);
    signal Ram2_Data:      STD_LOGIC_VECTOR(15 downto 0);

    signal rdn:            STD_LOGIC;
    signal wrn:            STD_LOGIC;
    signal data_ready:     STD_LOGIC;
    signal tbre:           STD_LOGIC;
    signal tsre:           STD_LOGIC;

    signal VGA_R:          STD_LOGIC_VECTOR( 2 downto 0);
    signal VGA_G:          STD_LOGIC_VECTOR( 2 downto 0);
    signal VGA_B:          STD_LOGIC_VECTOR( 2 downto 0);
    signal Hs:             STD_LOGIC;
    signal Vs:             STD_LOGIC;


    signal flash_byte :  STD_LOGIC := '1';
    signal flash_vpen :  STD_LOGIC := '1';
    signal flash_ce   :  STD_LOGIC := '0';
    signal flash_oe   :  STD_LOGIC := '1';
    signal flash_we   :  STD_LOGIC := '1';
    signal flash_rp   :  STD_LOGIC := '1';
    signal flash_addr :  STD_LOGIC_VECTOR( 22 downto 1 ) := "0000000000000000000000";
    signal flash_data :  STD_LOGIC_VECTOR( 15 downto 0 );

    signal LED        :  STD_LOGIC_VECTOR(15 downto 0);

    signal ps2data    :  STD_LOGIC;


begin
    clk_gen : process is
    begin
        wait for PERIOD / 2;
        clk <= not clk;
    end process clk_gen;

    rst <= hda1_init and hda2_init;

    ram1 : process (Ram1_en, Ram1_oe, Ram1_we, RAM1_Addr, Ram1_Data, rst) is
        file inp : text open read_mode is "ram1.txt";
        variable inline : line;
        variable in_int : integer range 0 to MAX_ADDR;
        variable var : integer range 0 to MAX_ADDR := 0;
        variable addr : integer range 0 to MAX_ADDR;
    begin
        if hda1_init = '0' then
            --Ram1_Data <= (others => 'Z');
            addr := 0;
            while (not endfile(inp)) loop
                readline(inp, inline);
                var := 0;
                for i in 0 to 3 loop
                    read(inline, in_int);
                    var := var * 16 + in_int;
                end loop;
                hda1(addr) <= conv_std_logic_vector(var, 16);
                addr := addr + 1;
            end loop;
            hda1_init <= '1';
        end if;
        if (rst = '1') and (Ram1_en = '0') and (Ram1_oe /= Ram1_we) then
            addr := CONV_INTEGER(RAM1_Addr);
            if Ram1_oe = '0' then
                Ram1_Data <= hda1(addr);
            else
                hda1(addr) <= Ram1_Data;
            end if;
        else
            Ram1_Data <= (others => 'Z');
        end if;
    end process ram1;

    ram2 : process (Ram2_en, Ram2_oe, Ram2_we, RAM2_Addr, Ram2_Data, rst) is
        file inp : text open read_mode is "ram2.txt";
        variable inline : line;
        variable in_int : integer range 0 to MAX_ADDR;
        variable var : integer range 0 to MAX_ADDR := 0;
        variable addr : integer range 0 to MAX_ADDR;
    begin
        if hda2_init = '0' then
            --Ram2_Data <= (others => 'Z');
            addr := 0;
            while (not endfile(inp)) loop
                readline(inp, inline);
                var := 0;
                for i in 0 to 3 loop
                    read(inline, in_int);
                    var := var * 16 + in_int;
                end loop;
                hda2(addr) <= conv_std_logic_vector(var, 16);
                addr := addr + 1;
            end loop;
            hda2_init <= '1' after 10 ps;
            addr := conv_integer(RAM2_Addr);
        end if;
        if (rst = '1') and (Ram2_en = '0') and (Ram2_oe /= Ram2_we) then
            addr := conv_integer(RAM2_Addr);
            if Ram2_oe = '0' then
                Ram2_Data <= hda2(addr);
            else
                hda2(addr) <= Ram2_Data;
            end if;
        else
            Ram2_Data <= (others => 'Z');
        end if;
    end process ram2;

    u_cpu : CPU port map (
        CLK     => CLK    ,
        CLK_11  => CLK_11 ,
        CLK_50  => CLK_50 ,
        RST     => RST    ,
        
        INT     => INT    ,
        
        Ram1_en => Ram1_en,
        Ram1_oe => Ram1_oe,
        Ram1_we => Ram1_we,
        RAM1_Addr => RAM1_Addr,
        Ram1_Data => Ram1_Data,
        Ram2_en => Ram2_en,
        Ram2_oe => Ram2_oe,
        Ram2_we => Ram2_we,
        RAM2_Addr => RAM2_Addr,
        Ram2_Data => Ram2_Data,
        
        rdn => rdn,
        wrn => wrn,
        data_ready => data_ready,
        tbre => tbre,
        tsre => tsre,

        ps2clk   => '0',
        ps2data  => ps2data,
        
        VGA_R => VGA_R,
        VGA_G => VGA_G,
        VGA_B => VGA_B,
        Hs => Hs,
        Vs => Vs,
        
        -- flash_byte  => flash_byte ,
        -- flash_vpen  => flash_vpen ,
        -- flash_ce    => flash_ce   ,
        -- flash_oe    => flash_oe   ,
        -- flash_we    => flash_we   ,
        -- flash_rp    => flash_rp   ,
        -- flash_addr  => flash_addr ,
        -- flash_data  => flash_data ,
        SW => x"0000",
        LED => LED
                         );

end architecture RTL;
