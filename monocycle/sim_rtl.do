transcript on
if {[file exists work]} {
	vdel -lib work -all
}
vlib work
vmap work work

vlog monociclo.v
vlog monociclo_tb.v
vlog instruction_memory.v
vlog program_counter.v
vlog register_unit.v
vlog data_memory.v
vlog alu.v
vlog branch_unit.v
vlog control_unit.v
vlog immediate_generator.v

vsim -t 1ps work.monociclo_tb

add wave *
view structure
view signals
run -all
