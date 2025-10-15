## Clock de la PL (125 MHz en H16)
set_property PACKAGE_PIN H16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 8.000 -name sys_clk [get_ports clk]
# OJO: en tu VHDL pon CLK_FREQ => 125_000_000

## Reset (usa el switch SW0 para rst_n activo en 0)
# SW0 = M20 (1 = normal, 0 = reset)
set_property PACKAGE_PIN M20 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

## UART RX en un PMOD (el USB-UART ONBOARD va al PS, no a la PL)
# Usa JA1 (pin JA1_P = Y18) y conecta allí el TX de tu adaptador USB–UART (3.3V)
set_property PACKAGE_PIN Y18 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]
set_property PULLUP true [get_ports uart_rx]   ;# reposo alto

## LEDs de usuario (4)
set_property PACKAGE_PIN R14 [get_ports {leds[0]}]
set_property PACKAGE_PIN P14 [get_ports {leds[1]}]
set_property PACKAGE_PIN N16 [get_ports {leds[2]}]
set_property PACKAGE_PIN M14 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[*]}]
