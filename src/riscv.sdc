set_time_format -unit ns -decimal_places 3
create_clock -name {clk} -period 20.000 -waveform {0.000 10.000} [get_ports {clk}]
create_generated_clock -name clk_1mhz -divide_by 50 -source [get_ports {clk}] clk_div:clk_div_unit|clk_1mhz|q
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
