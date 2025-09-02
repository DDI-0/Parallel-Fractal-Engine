create_clock -period 20.000 [get_ports CLK_50MHZ]
create_clock -period 20.000 -name main_clock_virt

derive_pll_clocks
