## Constraints for top_rf_alu_fsm (Digilent Basys 3, Artix-7 XC7A35T)

## Clock (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset button (center button, btnC)
set_property PACKAGE_PIN U18 [get_ports btnRst]
set_property IOSTANDARD LVCMOS33 [get_ports btnRst]

## Switches
##   sw[3:0]   ALUControl
##   sw[4]     WriteEnable
##   sw[9:5]   rd
##   sw[14:10] rs2
##   sw[15]    unused
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
set_property PACKAGE_PIN V2  [get_ports {sw[8]}]
set_property PACKAGE_PIN T3  [get_ports {sw[9]}]
set_property PACKAGE_PIN T2  [get_ports {sw[10]}]
set_property PACKAGE_PIN R3  [get_ports {sw[11]}]
set_property PACKAGE_PIN W2  [get_ports {sw[12]}]
set_property PACKAGE_PIN U1  [get_ports {sw[13]}]
set_property PACKAGE_PIN T1  [get_ports {sw[14]}]
set_property PACKAGE_PIN R2  [get_ports {sw[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

## LEDs
##   led[15:13] FSM state
##   led[12]    off
##   led[11:0]  ALUResult[11:0]
set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]
set_property PACKAGE_PIN V13 [get_ports {led[8]}]
set_property PACKAGE_PIN V3  [get_ports {led[9]}]
set_property PACKAGE_PIN W3  [get_ports {led[10]}]
set_property PACKAGE_PIN U3  [get_ports {led[11]}]
set_property PACKAGE_PIN P3  [get_ports {led[12]}]
set_property PACKAGE_PIN N3  [get_ports {led[13]}]
set_property PACKAGE_PIN P1  [get_ports {led[14]}]
set_property PACKAGE_PIN L1  [get_ports {led[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

































#### Constraints for top_rf_alu (Digilent Basys 3, Artix-7 XC7A35T)

#### Clock (100 MHz)
##set_property PACKAGE_PIN W5 [get_ports clk]
##set_property IOSTANDARD LVCMOS33 [get_ports clk]
##create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

#### Reset button (center button, btnC)
##set_property PACKAGE_PIN U18 [get_ports btnRst]
##set_property IOSTANDARD LVCMOS33 [get_ports btnRst]

#### Switches sw[15:0]
##set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
##set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
##set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
##set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
##set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
##set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
##set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
##set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
##set_property PACKAGE_PIN V2  [get_ports {sw[8]}]
##set_property PACKAGE_PIN T3  [get_ports {sw[9]}]
##set_property PACKAGE_PIN T2  [get_ports {sw[10]}]
##set_property PACKAGE_PIN R3  [get_ports {sw[11]}]
##set_property PACKAGE_PIN W2  [get_ports {sw[12]}]
##set_property PACKAGE_PIN U1  [get_ports {sw[13]}]
##set_property PACKAGE_PIN T1  [get_ports {sw[14]}]
##set_property PACKAGE_PIN R2  [get_ports {sw[15]}]
##set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

#### LEDs led[15:0]
##set_property PACKAGE_PIN U16 [get_ports {led[0]}]
##set_property PACKAGE_PIN E19 [get_ports {led[1]}]
##set_property PACKAGE_PIN U19 [get_ports {led[2]}]
##set_property PACKAGE_PIN V19 [get_ports {led[3]}]
##set_property PACKAGE_PIN W18 [get_ports {led[4]}]
##set_property PACKAGE_PIN U15 [get_ports {led[5]}]
##set_property PACKAGE_PIN U14 [get_ports {led[6]}]
##set_property PACKAGE_PIN V14 [get_ports {led[7]}]
##set_property PACKAGE_PIN V13 [get_ports {led[8]}]
##set_property PACKAGE_PIN V3  [get_ports {led[9]}]
##set_property PACKAGE_PIN W3  [get_ports {led[10]}]
##set_property PACKAGE_PIN U3  [get_ports {led[11]}]
##set_property PACKAGE_PIN P3  [get_ports {led[12]}]
##set_property PACKAGE_PIN N3  [get_ports {led[13]}]
##set_property PACKAGE_PIN P1  [get_ports {led[14]}]
##set_property PACKAGE_PIN L1  [get_ports {led[15]}]
##set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

#### Configuration
##set_property CFGBVS VCCO [current_design]
##set_property CONFIG_VOLTAGE 3.3 [current_design]

### ============================================================================
### top_rf_alu.xdc  -  Basys3 (Artix-7 XC7A35T-1CPG236C)
### Ports: clk, btnC, sw[15:0], led[15:0]   (no seven-segment display)
### ============================================================================

### Clock (100 MHz)
#set_property -dict { PACKAGE_PIN W5 IOSTANDARD LVCMOS33 } [get_ports clk]
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

### Reset button (center)
#set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports btnC]

### Switches
#set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports {sw[0]}]
#set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports {sw[1]}]
#set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports {sw[2]}]
#set_property -dict { PACKAGE_PIN W17 IOSTANDARD LVCMOS33 } [get_ports {sw[3]}]
#set_property -dict { PACKAGE_PIN W15 IOSTANDARD LVCMOS33 } [get_ports {sw[4]}]
#set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports {sw[5]}]
#set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports {sw[6]}]
#set_property -dict { PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports {sw[7]}]
#set_property -dict { PACKAGE_PIN V2  IOSTANDARD LVCMOS33 } [get_ports {sw[8]}]
#set_property -dict { PACKAGE_PIN T3  IOSTANDARD LVCMOS33 } [get_ports {sw[9]}]
#set_property -dict { PACKAGE_PIN T2  IOSTANDARD LVCMOS33 } [get_ports {sw[10]}]
#set_property -dict { PACKAGE_PIN R3  IOSTANDARD LVCMOS33 } [get_ports {sw[11]}]
#set_property -dict { PACKAGE_PIN W2  IOSTANDARD LVCMOS33 } [get_ports {sw[12]}]
#set_property -dict { PACKAGE_PIN U1  IOSTANDARD LVCMOS33 } [get_ports {sw[13]}]
#set_property -dict { PACKAGE_PIN T1  IOSTANDARD LVCMOS33 } [get_ports {sw[14]}]
#set_property -dict { PACKAGE_PIN R2  IOSTANDARD LVCMOS33 } [get_ports {sw[15]}]

### LEDs
#set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports {led[0]}]
#set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports {led[1]}]
#set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports {led[2]}]
#set_property -dict { PACKAGE_PIN V19 IOSTANDARD LVCMOS33 } [get_ports {led[3]}]
#set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports {led[4]}]
#set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports {led[5]}]
#set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports {led[6]}]
#set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports {led[7]}]
#set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports {led[8]}]
#set_property -dict { PACKAGE_PIN V3  IOSTANDARD LVCMOS33 } [get_ports {led[9]}]
#set_property -dict { PACKAGE_PIN W3  IOSTANDARD LVCMOS33 } [get_ports {led[10]}]
#set_property -dict { PACKAGE_PIN U3  IOSTANDARD LVCMOS33 } [get_ports {led[11]}]
#set_property -dict { PACKAGE_PIN P3  IOSTANDARD LVCMOS33 } [get_ports {led[12]}]
#set_property -dict { PACKAGE_PIN N3  IOSTANDARD LVCMOS33 } [get_ports {led[13]}]
#set_property -dict { PACKAGE_PIN P1  IOSTANDARD LVCMOS33 } [get_ports {led[14]}]
#set_property -dict { PACKAGE_PIN L1  IOSTANDARD LVCMOS33 } [get_ports {led[15]}]

### Bitstream configuration
#set_property CONFIG_VOLTAGE 3.3 [current_design]
#set_property CFGBVS VCCO [current_design]
#set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
#set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
#set_property CONFIG_MODE SPIx4 [current_design]
