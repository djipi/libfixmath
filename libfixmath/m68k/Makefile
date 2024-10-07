# Makefile for the libfixmath's M68K library

# Parameters list
#
# $2: env is used
# $1: cmd sets the command / order to be used


# Text/message colors
# Green (0;32)        : Compilation
# Brown/Orange (0;33) : Data & Source transformation
# Purple (0;35)       : Library
# Cyan (00;36)        : Reporting
# Light Red (1;31)    : Remove/Delete data
# Light Green (1;32)  : Assembling
# Yellow (1;33)       : Updating
# Light Cyan (1;36)   : Config reading
# White (1;37)        : Creation directory
COLOR_ASSEMBLER = 01;32
COLOR_COMPILE   = 00;32
COLOR_LIBRARY   = 00;35
COLOR_MKDIR     = 01;37
COLOR_REPORTS	= 00;36
COLOR_REMOVE    = 01;31
COLOR_TRANSFORM = 00;33
COLOR_UPDATING  = 01;33
COLOR_CONFIG    = 01;36


# Check perl setup
DOT := $(shell command -v perl 2> /dev/null)
ifndef DOT
$(error No setup for Perl)
endif


# Environement detections
#
ifdef env
ifneq ($(env), Debug)
ifneq ($(env), Release)
ifneq ($(env), Profile)
ifneq ($(env), Retail)
$(error env is not recognised)
endif
endif
endif
endif
VERSION = $(shell echo $(env) | tr a-z A-Z)
else
$(error env is missing; must be either Debug, Profile, Release or Retail)
endif


# Configuration
#
# Compilation verbose
Q := @
#
# Include the tools executables and paths
include config.mk

# Get asm from source C (yes, no)
GET_SFromC = no
# Current version
CURRENT_VERSION = 1.1

# Source C directories list
#
C_FIXMATH_DIR = ./..
#
# Objects (from C compilation) directories list
#
O_BASE_DIR = ./$(env)/obj/$(FORMAT)
O_FIXMATH_DIR = $(O_BASE_DIR)/$(COMPILER_SELECT)
#
# ASM sources (from C compilation) directories list
#
S_BASE_DIR = ./$(env)/s/$(FORMAT)
S_FIXMATH_DIR = $(S_BASE_DIR)/$(COMPILER_SELECT)
#
# Reports directories list
#
REPORTS_DIR	= ./$(env)/reports/$(COMPILER_SELECT)
#
# Output directories list
#
DIR_LIB = ./$(env)/lib/$(CURRENT_VERSION)


# C compiler information
#
# Defines
include Defines
#
# GCC
#
ifeq ($(COMPILER_C_TYPE), gcc)
CCOpt = -m68000 -Wall -MMD -MP
CCDefine = -D__JAGUAR__ -D$(VERSION) $(ACCURACY) $(PLATFORM) $(ALGORITHMS) $(COMPILE)
# -fno-align-functions -Wextra
#ifneq ($(FORMAT), aout)
ifeq ($(FORMAT), elf)
ifneq ($(env), Release)
CCOpt += -gdwarf-2
endif
endif
#else
#$(error FORMAT is not set or wrongly dispatched for $(COMPILER_SELECT))
#endif
#Debug
ifeq ($(env), Debug)
CCOpt += -g -O0
# -mno-align-int -mstrict-align
# -gdwarf-2 -Werror -msoft-float -malign-int -fno-leading-underscore -MD -MP -fstack-usage -pedantic-errors -Wfatal-errors
else
#Release
ifeq ($(env), Release)
CCOpt += -fomit-frame-pointer -Ofast
CCDefine += -DNDEBUG
# -Wfatal-errors -Werror
else
# Profile
ifeq ($(env), Profile)
CCOpt += -pg -g -Ofast -fstack-usage -finstrument-functions
CCDefine += -DNDEBUG
# -pedantic-errors -Wfatal-errors
else
$(error env is not recognised, must be either Debug, Profile or Release)
endif
endif
endif
# -D_M_M68K
#-D NO_LIBGCC_A -D INT_8_BITS -D _SUPPORT_ARGS -D_USE_STDINT 
#-IC:/SDK/Jaguar/jlibc-0.5.10/include -IC:/SDK/Jaguar/glibc-2.20/include
CC_INC = -IC:/Projects/Lib-M68K/include -I$(CCINC1) -I$(CCINC2)
# -IC:\Projects\Lib-M68K\include
#
FIXMATH_INC = -I./..
#H_INC = -I$(C_JAGUAR_DIR)
#-IC:/Projects/mingw32/include
#-I./Sys 
#-IC:\SDK\Jaguar\ATARIJaguarSDK\INCLUDE
GET_SFromC_Option = -S
CCProg_F = $(CCProg) -c $< $(CCOpt) $(CCDefine) $(FIXMATH_INC) $(CC_INC) $(H_INC) -o $@
CCProg_S = $(CCProg) -c $< $(CCOpt) $(GET_SFromC_Option) $(CCDefine) $(FIXMATH_INC) $(CC_INC) $(H_INC) -o $@
else
#
# VBcc
#
ifeq ($(COMPILER_C_TYPE), vbcc)
CCOpt = +vc$(COMPILER_C_VERSION)_$(env).cfg
CCDefine =
CC_INC =
H_INC =
GET_SFromC_Option = -S
CCProg_F = $(CCProg) $< $(CCOpt) -o $@
CCProg_S = $(CCProg) $< $(CCOpt) $(GET_SFromC_Option) -o $@
else
#
# LLVM
#
ifeq ($(COMPILER_C_TYPE), llvm)
CCDefine = -D__JAGUAR__ -D$(VERSION)
#CCExp += $< -c -fcolor-diagnostics
#CCOpt = --color -mcpu=M68000 -march=m68k -o $@
CCOpt = -c -fcolor-diagnostics
#-target m68k --arch=m68k -mcpu=M68000 -march=m68k 
ifeq ($(GET_SFromC), no)
#CCOpt += --filetype=obj
else
GET_SFromC_Option = -S
endif
ifeq ($(env), Debug)
CCOpt += -g -O0 -ggdb -gdwarf-2
#  --dwarf-version=2 --debugger-tune=gdb
# -g -O0 -ggdb
# -O=0 -g --debugger-tune=gdb --dwarf-version=2
else
ifeq ($(env), Release)
CCOpt += -O=3
CCDefine += -DNDEBUG
else
ifeq ($(env), Profile)
CCOpt += -O=3
CCDefine += -DNDEBUG
else
$(error env is not recognised, must be either Debug, Profile or Release)
endif
endif
endif
OS_INC = -I./include
CC_INC = -I$(CCINC1)
# -I$(CCINC2)
#H_INC = -I$(C_JAGUAR_DIR)
# $< $(CCOpt) $(CCDefine) $(CC_INC) $(H_INC) -o $@
# $< $(CCOpt) $(CCDefine) $(OS_INC) $(CC_INC) $(H_INC) -o $@
# $< $(CCOpt) $(CCDefine) $(OS_INC) $(H_INC) -o $@
CCProg_F = $(CCProg) $< $(CCOpt) $(CCDefine) $(OS_INC) $(CC_INC) $(H_INC) -o $@
CCProg_S = $(CCProg) $< $(CCOpt) $(GET_SFromC_Option) $(CCDefine) $(OS_INC) $(CC_INC) $(H_INC) -o $@
else
#--frame-pointer -O=3
#
# Compiler not set
#
$(error C compiler type is not set or wrongly dispatched)
endif
endif
endif

# Libraries
AR_OPT = cru
# rvs
ARAN_OPT =
LIBFIXMATH = libfixmath-$(CURRENT_VERSION)_$(env)_$(COMPILER_SELECT).$(FORMAT).a

# Tools information
TODOS_OPT = -o -u -v


# Extra dependence list for compilation
#
EXTRA_DEPEND_LIST = Makefile Defines config.mk


# Check directory existence
#
ifneq ($(cmd), makedirs)
ifneq ($(cmd), config)
ifeq ("$(wildcard $(O_FIXMATH_DIR))","")
$(error the directories to create $(LIBFIXMATH) don't exist, please use makedirs command)
endif
ifeq ("$(wildcard $(DIR_LIB))","")
$(error the directory to create libfixmath $(CURRENT_VERSION) doesn't exist, please use makedirs command)
endif
endif
endif


compile:	compile_FIXMATH

rebuild:	clean \
			all
			
all:	compile \
		library


# Cross Platform Fixed Point Maths Library
#
ObjFIXMATH	=	$(O_FIXMATH_DIR)/uint32.o \
				$(O_FIXMATH_DIR)/fract32.o \
				$(O_FIXMATH_DIR)/fix16_trig.o \
				$(O_FIXMATH_DIR)/fix16_str.o \
				$(O_FIXMATH_DIR)/fix16_sqrt.o \
				$(O_FIXMATH_DIR)/fix16_fft.o \
				$(O_FIXMATH_DIR)/fix16_exp.o \
				$(O_FIXMATH_DIR)/fix16.o
#
ifeq ($(GET_SFromC), yes)
ObjFIXMATH_s	=	$(S_FIXMATH_DIR)/uint32.s \
					$(S_FIXMATH_DIR)/fract32.s \
					$(S_FIXMATH_DIR)/fix16_trig.s \
					$(S_FIXMATH_DIR)/fix16_str.s \
					$(S_FIXMATH_DIR)/fix16_sqrt.s \
					$(S_FIXMATH_DIR)/fix16_fft.s \
					$(S_FIXMATH_DIR)/fix16_exp.s \
					$(S_FIXMATH_DIR)/fix16.s
endif				
#
ObjFIXMATH_d	=	$(O_FIXMATH_DIR)/uint32.d \
					$(O_FIXMATH_DIR)/fract32.d \
					$(O_FIXMATH_DIR)/fix16_trig.d \
					$(O_FIXMATH_DIR)/fix16_str.d \
					$(O_FIXMATH_DIR)/fix16_sqrt.d \
					$(O_FIXMATH_DIR)/fix16_fft.d \
					$(O_FIXMATH_DIR)/fix16_exp.d \
					$(O_FIXMATH_DIR)/fix16.d


compile_FIXMATH:	$(ObjFIXMATH_s) $(ObjFIXMATH)
#
ifeq ("$(wildcard $(O_FIXMATH_DIR)\*.d)","")
include $(ObjFIXMATH_d)
endif
#
$(O_FIXMATH_DIR)/uint32.d:
$(O_FIXMATH_DIR)/uint32.o: $(C_FIXMATH_DIR)/uint32.c $(O_FIXMATH_DIR)/uint32.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[00;32m Compiling $<...\033[00m"
	$(Q)$(CCProg_F)
$(S_FIXMATH_DIR)/uint32.s: $(C_FIXMATH_DIR)/uint32.c $(O_FIXMATH_DIR)/uint32.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[$(COLOR_TRANSFORM)m Creates the $@ file from $<...\033[00m"
	$(Q)$(CCProg_S)
#
$(O_FIXMATH_DIR)/fract32.d:
$(O_FIXMATH_DIR)/fract32.o: $(C_FIXMATH_DIR)/fract32.c $(O_FIXMATH_DIR)/fract32.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[00;32m Compiling $<...\033[00m"
	$(Q)$(CCProg_F)
$(S_FIXMATH_DIR)/fract32.s: $(C_FIXMATH_DIR)/fract32.c $(O_FIXMATH_DIR)/fract32.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[$(COLOR_TRANSFORM)m Creates the $@ file from $<...\033[00m"
	$(Q)$(CCProg_S)
#
$(O_FIXMATH_DIR)/fix16_trig.d:
$(O_FIXMATH_DIR)/fix16_trig.o: $(C_FIXMATH_DIR)/fix16_trig.c $(O_FIXMATH_DIR)/fix16_trig.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[00;32m Compiling $<...\033[00m"
	$(Q)$(CCProg_F)	
$(S_FIXMATH_DIR)/fix16_trig.s: $(C_FIXMATH_DIR)/fix16_trig.c $(O_FIXMATH_DIR)/fix16_trig.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[$(COLOR_TRANSFORM)m Creates the $@ file from $<...\033[00m"
	$(Q)$(CCProg_S)
#
$(O_FIXMATH_DIR)/fix16_str.d:
$(O_FIXMATH_DIR)/fix16_str.o: $(C_FIXMATH_DIR)/fix16_str.c $(O_FIXMATH_DIR)/fix16_str.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[00;32m Compiling $<...\033[00m"
	$(Q)$(CCProg_F)	
$(S_FIXMATH_DIR)/fix16_str.s: $(C_FIXMATH_DIR)/fix16_str.c $(O_FIXMATH_DIR)/fix16_str.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[$(COLOR_TRANSFORM)m Creates the $@ file from $<...\033[00m"
	$(Q)$(CCProg_S)
#
$(O_FIXMATH_DIR)/fix16_sqrt.d:
$(O_FIXMATH_DIR)/fix16_sqrt.o: $(C_FIXMATH_DIR)/fix16_sqrt.c $(O_FIXMATH_DIR)/fix16_sqrt.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[00;32m Compiling $<...\033[00m"
	$(Q)$(CCProg_F)	
$(S_FIXMATH_DIR)/fix16_sqrt.s: $(C_FIXMATH_DIR)/fix16_sqrt.c $(O_FIXMATH_DIR)/fix16_sqrt.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[$(COLOR_TRANSFORM)m Creates the $@ file from $<...\033[00m"
	$(Q)$(CCProg_S)
#
$(O_FIXMATH_DIR)/fix16_fft.d:
$(O_FIXMATH_DIR)/fix16_fft.o: $(C_FIXMATH_DIR)/fix16_fft.c $(O_FIXMATH_DIR)/fix16_fft.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[00;32m Compiling $<...\033[00m"
	$(Q)$(CCProg_F)	
$(S_FIXMATH_DIR)/fix16_fft.s: $(C_FIXMATH_DIR)/fix16_fft.c $(O_FIXMATH_DIR)/fix16_fft.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[$(COLOR_TRANSFORM)m Creates the $@ file from $<...\033[00m"
	$(Q)$(CCProg_S)
#
$(O_FIXMATH_DIR)/fix16_exp.d:
$(O_FIXMATH_DIR)/fix16_exp.o: $(C_FIXMATH_DIR)/fix16_exp.c $(O_FIXMATH_DIR)/fix16_exp.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[00;32m Compiling $<...\033[00m"
	$(Q)$(CCProg_F)
$(S_FIXMATH_DIR)/fix16_exp.s: $(C_FIXMATH_DIR)/fix16_exp.c $(O_FIXMATH_DIR)/fix16_exp.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[$(COLOR_TRANSFORM)m Creates the $@ file from $<...\033[00m"
	$(Q)$(CCProg_S)
#
$(O_FIXMATH_DIR)/fix16.d:
$(O_FIXMATH_DIR)/fix16.o: $(C_FIXMATH_DIR)/fix16.c $(O_FIXMATH_DIR)/fix16.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[00;32m Compiling $<...\033[00m"
	$(Q)$(CCProg_F)
$(S_FIXMATH_DIR)/fix16.s: $(C_FIXMATH_DIR)/fix16.c $(O_FIXMATH_DIR)/fix16.d $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[$(COLOR_TRANSFORM)m Creates the $@ file from $<...\033[00m"
	$(Q)$(CCProg_S)


reports:	report_stack

report_stack:	$(REPORTS_DIR)/$(LIBFIXMATH).StackReport.txt

$(REPORTS_DIR)/$(LIBFIXMATH).StackReport.txt: $(ObjFIXMATH) $(DIR_LIB)/$(LIBFIXMATH) makefile Build.bat
	@echo -e "\033[01;33m***\033[$(COLOR_REPORTS)m Reporting stack usage from $<...\033[00m"
	$(Q)perl.exe avstack.pl $(ObjFIXMATH) > $@


library:	$(DIR_LIB)/$(LIBFIXMATH)


# libfixmath's library creation
$(DIR_LIB)/$(LIBFIXMATH):	$(ObjFIXMATH) $(ObjFIXMATH_s)
	@echo -e "\033[01;33m***\033[$(COLOR_LIBRARY)m Create the library $(LIBFIXMATH)...\033[00m"
	$(Q)$(ARProg) $(AR_OPT) $@ $(ObjFIXMATH)
	$(Q)$(ARANProg) $(ARAN_OPT) $@


# Project clean-up
#
clean:	clean_obj \
		clean_su \
		clean_d \
		clean_s \
		clean_lib \
		clean_report
#
# Delete the object files
clean_obj:
		@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the obj files...\033[00m"	
		$(Q)rm -f $(O_FIXMATH_DIR)/*.o
#
# Delete the stack usage files
clean_su:
		@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the stack usage generated files...\033[00m"	
		$(Q)rm -f $(O_FIXMATH_DIR)/*.su
#
# Delete the dependence files
clean_d:
		@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the dependency files...\033[00m"	
		$(Q)rm -f $(O_FIXMATH_DIR)/*.d
#
# Delete the asm files generated by compilation		
clean_s:
		@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the asm sources generated from C compilation...\033[00m"	
		$(Q)rm -f $(S_FIXMATH_DIR)/*.s
#
# Delete the libs
clean_lib:
		@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the library file...\033[00m"	
		$(Q)rm -f $(DIR_LIB)/$(LIBFIXMATH)
#
# Delete reports
clean_report:
		@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the report files...\033[00m"	
		$(Q)rm -f $(REPORTS_DIR)/*.txt
		

# Create directories
#
makedirs:	mkdir_reports \
			mkdir_lib \
			mkdir_obj \
			mkdir_su \
			mkdir_d \
			mkdir_s
#
# Create the reports files directories
mkdir_reports:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the reports directories...\033[00m"
		$(Q)mkdir -p $(REPORTS_DIR)
#
# Create the object, stack usage and dependence files directories
mkdir_obj:
mkdir_su:
mkdir_d:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the dependencies and objs directories...\033[00m"
		$(Q)mkdir -p $(O_FIXMATH_DIR)
#
# Create the library directory
mkdir_lib:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the library directory...\033[00m"
		$(Q)mkdir -p $(DIR_LIB)
#
# Create the asm files, generated by compilation, directories		
mkdir_s:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the generated asm directories...\033[00m"
		$(Q)mkdir -p $(S_FIXMATH_DIR)

		
# Display configuration
#
config:	config_command \
		config_generic \
		config_compilation
#
# Display the command from batch
config_command:
	$(info ------------------ Command)
	$(info Version          : $(env))
#
# Display generic information
config_generic:
	$(info ------------------ Generic)
	$(info Format           : $(FORMAT))
	$(info Assembler        : $(ASM))
	$(info Compiler         : $(COMPILER_C_TYPE) $(COMPILER_C_VERSION))
#
# Display the compilation information
config_compilation:
	$(info ------------------ Compilation)
	$(info Definitions      : $(sort $(CCDefine)))
	$(info C Include        : $(CC_INC))
	$(info ASM from C       : $(GET_SFromC))
	$(info Options          : $(sort $(CCOpt)))
	$(info Options C->ASM   : $(GET_SFromC_Option))
	