transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {d:/edatools/quartus18/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {d:/edatools/quartus18/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {d:/edatools/quartus18/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {d:/edatools/quartus18/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {d:/edatools/quartus18/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {d:/edatools/quartus18/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware/seg_dynamic {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware/seg_dynamic/seg_dynamic.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware/seg_dynamic {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware/seg_dynamic/binary_8421.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware/key.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/image_process {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/image_process/sobel_top.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/image_process {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/image_process/sobel_filtering.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/image_process {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/image_process/opr_3.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/image_process/shift_ip {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/image_process/shift_ip/shift_ip_3.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/ov5640_pip.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/vga {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/vga/video_define.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port/sdram_pll {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port/sdram_pll/Sdram_PLL.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port/sdram_fifo {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port/sdram_fifo/Sdram_FIFO.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware/Reset_Delay.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware/getRGB.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware/getPos {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware/getPos/getPosedge.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware/getPos {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/mid_ware/getPos/getPos.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/image_process {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/image_process/YCbCr.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/cmos {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/cmos/i2c_com.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/cmos {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/cmos/cmos2_reg_config.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/cmos {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/cmos/CMOS_Capture.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/clock_pll {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/clock_pll/clock_pll.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/quartusPrj/db {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/quartusPrj/db/clock_pll_altpll.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/quartusPrj/db {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/quartusPrj/db/sdram_pll_altpll.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/vga {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/vga/color_bar.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port/Sdram_Control_4Port.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port/sdr_data_path.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port/control_interface.v}
vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/rtl/sdram_4port/command.v}

vlog -vlog01compat -work work +incdir+D:/PrjWorkspace/OV5640/Prj/OV5640_v1/quartusPrj/../tb/tb_VGA_Controller {D:/PrjWorkspace/OV5640/Prj/OV5640_v1/quartusPrj/../tb/tb_VGA_Controller/sobel_img_gen.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  sobel_img_gen

add wave *
view structure
view signals
run 55 ms
