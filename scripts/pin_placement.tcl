# Generics
set_location_assignment PIN_AF14 -to CLK_50MHZ
set_location_assignment PIN_AB30 -to KEY[0]
set_location_assignment PIN_Y27  -to SW[0]
set_location_assignment PIN_AB28 -to SW[1]
set_location_assignment PIN_AC30 -to SW[2]


# VGA Red pin assignments
set_location_assignment PIN_AK29 -to VGA_R[0]
set_location_assignment PIN_AK28 -to VGA_R[1]
set_location_assignment PIN_AK27 -to VGA_R[2]
set_location_assignment PIN_AJ27 -to VGA_R[3]
set_location_assignment PIN_AH27 -to VGA_R[4]
set_location_assignment PIN_AF26 -to VGA_R[5]
set_location_assignment PIN_AG26 -to VGA_R[6]
set_location_assignment PIN_AJ26 -to VGA_R[7]

# VGA Green pin assignments
set_location_assignment PIN_AK26 -to VGA_G[0]
set_location_assignment PIN_AJ25 -to VGA_G[1]
set_location_assignment PIN_AH25 -to VGA_G[2]
set_location_assignment PIN_AK24 -to VGA_G[3]
set_location_assignment PIN_AJ24 -to VGA_G[4]
set_location_assignment PIN_AH24 -to VGA_G[5]
set_location_assignment PIN_AK23 -to VGA_G[6]
set_location_assignment PIN_AH23 -to VGA_G[7]

# VGA Blue pin assignments
set_location_assignment PIN_AJ21 -to VGA_B[0]
set_location_assignment PIN_AJ20 -to VGA_B[1]
set_location_assignment PIN_AH20 -to VGA_B[2]
set_location_assignment PIN_AJ19 -to VGA_B[3]
set_location_assignment PIN_AH19 -to VGA_B[4]
set_location_assignment PIN_AJ17 -to VGA_B[5]
set_location_assignment PIN_AJ16 -to VGA_B[6]
set_location_assignment PIN_AK16 -to VGA_B[7]

# VGA Control signal pin assignments
set_location_assignment PIN_AK21 -to VGA_CLK
set_location_assignment PIN_AK22 -to VGA_BLANK_N
set_location_assignment PIN_AK19 -to VGA_HS
set_location_assignment PIN_AK18 -to VGA_VS
set_location_assignment PIN_AJ22 -to VGA_SYNC_N

# Set I/O standards to 3.3-V LVTTL for all VGA signals
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_BLANK_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_SYNC_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_HS
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_VS
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLK_50MHZ
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[2]

