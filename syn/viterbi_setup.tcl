#================================
#DC setup file for viterbi decoder
#Written by Cheng Wai Kin and Lo Hon Yik
#1/6/09
#================================

#===========================
#Set work path
#===========================
define_design_lib WORK -path ./work

#======================================
#Analyze file - read parameters required
#========================================
analyze -lib WORK -format verilog ../hdl/ACS.v
analyze -lib WORK -format verilog ../hdl/BMU.v 
analyze -lib WORK -format verilog ../hdl/PMU.v 
analyze -lib WORK -format verilog ../hdl/SPMU.v 
analyze -lib WORK -format verilog ../hdl/RSTK.v
analyze -lib WORK -format verilog ../hdl/viterbi_decoder.v 

#=============================
#Elaborate design
#============================
elaborate -lib WORK viterbi_decoder

#===========================
#Set top design
#===========================
current_design "viterbi_decoder"
set top_design "viterbi_decoder"

#======================
#Link Design
#======================
link

#======================
#source constraint file
#======================
source ./viterbi.con

#=========================
#uniquify for confirmation
#=========================
uniquify

set_fix_multiple_port_nets -all -buffer_constant [get_designs *]

#=========================
#compile
#=========================
compile

#=================================
#Change names for place and route
#=================================
change_names -rules verilog -hierarchy

#======================================
#Output netlist and database
#======================================
write -f ddc -hier -output ./mapped/viterbi.ddc
write -f verilog -hier -output ./mapped/viterbi.gv

#=======================================
#Output constraint and timing file
#=======================================
write_sdc ./mapped/viterbi.sdc
