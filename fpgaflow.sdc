derive_clock_uncertainty

create_clock -period 200MHz -name {CLOCK} [get_ports {CLOCK}]

create_clock -period 125MHz -name {PCLK} [get_ports {PCLK}]
