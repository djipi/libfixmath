# Makefile for the libfixmath's M68K fixtest library

# Parameters list
#
# $2: mode is used
# $1: cmd sets the command / order to be used


# Text/message colors
# Green (0;32)        : Compilation
# Brown/Orange (0;33) : Data & Source transformation
# Purple (0;35)       : Build
# Cyan (00;36)        : Reporting
# Light Red (1;31)    : Remove/Delete data
# Light Green (1;32)  : Assembling
# Yellow (1;33)       : Updating
# Light Cyan (1;36)   : Config reading
# White (1;37)        : Creation directory
COLOR_ASSEMBLER = 01;32
COLOR_COMPILE   = 00;32
COLOR_BUILD     = 00;35
COLOR_MKDIR     = 01;37
COLOR_REPORTS	= 00;36
COLOR_REMOVE    = 01;31
COLOR_TRANSFORM = 00;33
COLOR_UPDATING  = 01;33
COLOR_CONFIG    = 01;36


# Environement detections
#
ifdef mode
ifneq ($(mode), Debug)
ifneq ($(mode), Release)
ifneq ($(mode), Profile)
ifneq ($(mode), Retail)
$(error mode is not recognised)
endif
endif
endif
endif
MODE = $(shell echo $(mode) | tr a-z A-Z)
else
$(error mode is not recognised, must be either Debug, Release, Retail or - eventualy Profile)
endif


# Configuration
#
# Compilation verbose
Q := @
#
# Include the tools executables and paths
include ../../libfixmath/m68k/config.mk

# Libraries selection (lib-gcc, lib-m68k, none)
LIBC_SELECT = lib-m68k
LIBGCC_SELECT = lib-gcc
# lib-m68k version
LIBC_VERSION = 1.2e
LIBGCC_VERSION = 1.1
# Support for the in-house O/S Jaguar (yes, no)
OSJAG_SELECT = yes
# OS Jag version
OSJAG_VERSION = 1.3
# libfixmath version
LIBFIXMATH_VERSION = 1.1
# Maths selection (cephes, fdlibm, libm-gcc, libm-m68k, none)
MATHS_SELECT = libm-gcc
# libm-m68k version
LIBM_VERSION = 1.1
# fdlibm version (5.2-2_IEEE_LIBM, 5.3_IEEE_LIBM)
FDLIBM_VERSION = 5.2-2
EFDLIBM_VERSION = IEEE_LIBM
VERSIONFDLIBM = $(FDLIBM_VERSION)_$(EFDLIBM_VERSION)
# cephes math version (2.2_cmath-MIEEE)
CEPHESMATH_VERSION = 2.2
ECEPHESMATH_VERSION = cmath-MIEEE
VERSIONCEPHESMATH = $(CEPHESMATH_VERSION)_$(ECEPHESMATH_VERSION)
# Executable selection (elf)
EXE_FORMAT	=	elf


# Directories 
SRC = ./..
RUNTIME	= ./src/Runtime
EXE_DIR	= ./$(mode)
DUMP_DIR = ./$(mode)/reports/$(FORMAT)
OBJ_C = ./$(mode)/obj/$(FORMAT)/$(COMPILER_C)
OBJ_ASM = ./$(mode)/obj/$(FORMAT)
OBJ_S = ./$(mode)/s/$(FORMAT)/$(COMPILER_C)
#
# Libraries directories list
DIR_LIBS = ./$(mode)/Libs
DIR_LIBFIXMATH = ../../libfixmath/m68k
#
# Executable name
EXE_FILENAME = fixtest_$(mode)_$(COMPILER_SELECT).$(EXE_FORMAT)


# C compiler information
#
# Defines
include $(DIR_LIBFIXMATH)/Defines
#
# GCC
#
ifeq ($(COMPILER_C_TYPE), gcc)
CCDefine = -D$(MODE) $(COMPILE) $(ACCURACY) $(PLATFORM) $(ALGORITHMS)
CFLAGS = -c -Wall -m68000 $(CCDefine)
ifeq ($(FORMAT), elf)
CFLAGSD = -gdwarf-2
endif
ifeq ($(mode), Debug)
CFLAGS += -g $(CFLAGSD) -O0
# -fleading-underscore
else
ifeq ($(mode), Profile)
CFLAGS += -pg -g $(CFLAGSD) -Ofast -DDEBUG -DNDEBUG
else
ifeq ($(mode), Release)
CFLAGS += -Ofast -DNDEBUG
else
$(error mode is not recognised)
endif
endif
endif
CCINC = -IC:/Projects/Lib-M68K/include -I$(CCINC1) -I$(CCINC2) -I../..
CCOBJ = -o $@
#
# Compiler not recognised
else
$(error COMPILER_C_TYPE is not recognised)
endif


# Assembler information
ifeq ($(ASM), smac)
AOPT = -s -v -fb -d$(MODE) -d$(ASM)
ifneq ($(FORMAT), aout)
$(error FORMAT is not recognised, must be aout)
endif
else
ifeq ($(ASM), vasm)
AOPT = -m68000 -quiet -F$(FORMAT) -Ic:/SDK/AJaguar/OfficialJaguarKit/Include
# -dwarf -D$(MODE) -D$(ASM)
else
$(error ASM is not recognised)
endif
endif


# Linker information
ifeq ($(EXE_FORMAT), elf)
LINKER_SCRIPT  = -belf32m68k -TJagELFls
LINKER_OPTIONS = -e_start -EB -Ttext 0x4000
endif


# Libraries information
#
# libgcc selection
ifeq ($(LIBGCC_SELECT), lib-gcc)
LIB_GCC	= $(DIRLIBGCC)/libgcc.a
else
ifeq ($(LIBGCC_SELECT), lib-m68k)
LIB_GCC	= $(DIR_LIBS)/libgcc-$(LIBGCC_VERSION)_$(mode)-M68K.$(FORMAT).a
endif
endif
# libc selection
ifeq ($(LIBC_SELECT), lib-gcc)
LIB_C = $(DIRLIBC)/libc.a $(DIRLIBC)/libbcc.a
else
ifeq ($(LIBC_SELECT), lib-m68k)
LIB_C = $(DIR_LIBS)/libc-$(LIBC_VERSION)_$(mode)_$(COMPILER_C_TYPE)-M68K.$(FORMAT).a
endif
endif
#
# OS library selection
ifeq ($(OSJAG_SELECT), yes)
LIB_OS = $(DIR_LIBS)/OSJag/$(OSJAG_VERSION)/OSJag-$(OSJAG_VERSION)_$(mode)_gcc-$(COMPILER_C_VERSION).$(FORMAT).a
else
LIB_OS =
endif
#
# Libfixmath library
LIB_FIXMATH = $(DIR_LIBFIXMATH)/$(mode)/lib/$(LIBFIXMATH_VERSION)/libfixmath-$(LIBFIXMATH_VERSION)_$(mode)_$(COMPILER_SELECT).elf.a
#
# Maths funtions library selection
ifeq ($(MATHS_SELECT), cephes)
LIB_MATHS = $(DIR_LIBS)/cephes/cephes-$(VERSIONCEPHESMATH)_$(mode)_m68k-$(COMPILER_SELECT).$(FORMAT).a
else
ifeq ($(MATHS_SELECT), fdlibm)
LIB_MATHS = $(DIR_LIBS)/fdlibm/$(VERSIONFDLIBM)/fdlibm-$(VERSIONFDLIBM)_$(mode)_m68k-$(COMPILER_SELECT).$(FORMAT).a
else
ifeq ($(MATHS_SELECT), libm-gcc)
LIB_MATHS = $(DIRLIBC)/libm.a
else
ifeq ($(MATHS_SELECT), libm-m68k)
LIB_MATHS = $(DIR_LIBS)/libm-$(LIBM_VERSION)_$(mode)-M68K.$(FORMAT).a
else
ifeq ($(MATHS_SELECT), none)
LIB_MATHS =
else
$(error MATHS_SELECT is not set or wrongly dispatched)
endif
endif
endif
endif
endif


# Tools information
TODOS_OPT = -o -u -v


# Extra dependence list for compilation
#
EXTRA_DEPEND_LIST = Makefile $(DIR_LIBFIXMATH)/Defines $(DIR_LIBFIXMATH)/config.mk JagELFls


# Check directory existence
#
ifneq ($(cmd), makedirs)
ifeq ("$(wildcard $(OBJ_C))","")
$(error the directories to create $(EXE_FILENAME) don't exist, please use makedirs command)
endif
endif


# Objs list
OBJS = $(OBJ_C)/main.o $(OBJ_C)/hiclock.o
#
# ASM generated list
OBJS_S = $(OBJ_S)/main.s $(OBJ_S)/hiclock.s
#
# Objs runtime
OBJS_RUNTIME = $(OBJ_ASM)/STARTUP.o			
#
# Executable list
PROGS = $(EXE_DIR)/$(EXE_FILENAME)


all:	assemble \
		compile \
		link
#
rebuild:	clean \
			all


compile:	$(OBJS) $(OBJS_S)
#
# C compilation
$(OBJ_C)/main.o:	$(SRC)/main.c $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[00;32m Compiling $<...\033[00m"
	$(Q)$(CCProg) $< $(CFLAGS) $(CCINC) $(CCOBJ)
$(OBJ_S)/main.s:	$(SRC)/main.c $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[$(COLOR_TRANSFORM)m Creates the $@ file from $<...\033[00m"
	$(Q)$(CCProg) $< $(CFLAGS) -S $(CCINC) $(CCOBJ)
$(OBJ_C)/hiclock.o:	$(SRC)/hiclock.c $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[00;32m Compiling $<...\033[00m"
	$(Q)$(CCProg) $< $(CFLAGS) $(CCINC) $(CCOBJ)
$(OBJ_S)/hiclock.s:	$(SRC)/hiclock.c $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[$(COLOR_TRANSFORM)m Creates the $@ file from $<...\033[00m"
	$(Q)$(CCProg) $< $(CFLAGS) -S $(CCINC) $(CCOBJ)


assemble:	$(OBJS_RUNTIME)
#
$(OBJ_ASM)/STARTUP.o:	$(RUNTIME)/STARTUP.s $(EXTRA_DEPEND_LIST)
	@echo -e "\033[01;33m***\033[$(COLOR_ASSEMBLER)m Assembling $<...\033[00m"
	$(Q)$(ASMProg) $< $(AOPT) -o $@


link:	$(PROGS)
#
# Executable creation
$(EXE_DIR)/$(EXE_FILENAME):	$(OBJS) $(EXTRA_DEPEND_LIST) $(OBJS_RUNTIME) $(LIB_GCC) $(LIB_C) $(LIB_MATHS) $(LIB_FIXMATH) $(LIB_OS)
	@echo -e "\033[01;33m***\033[$(COLOR_BUILD)m Build $@...\033[00m"
	$(Q)$(LNKProg) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(OBJS_RUNTIME) $(LIB_GCC) $(LIB_C) $(LIB_MATHS) $(OBJS) $(LIB_FIXMATH) $(LIB_OS)


# Dump debug executable
ifeq ($(FORMAT), elf)
$(DUMP_DIR)/$(EXE_FILENAME).ReadElf.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W -a $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).info.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W --debug-dump=info $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).rawline.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W --debug-dump=rawline $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).decodedline.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W --debug-dump=decodedline $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).abbrev.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W --debug-dump=abbrev $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).pubnames.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W --debug-dump=pubnames $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).aranges.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W --debug-dump=aranges $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).macro.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W --debug-dump=macro $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).frames.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W --debug-dump=frames $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).addr.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W --debug-dump=addr $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).str.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W --debug-dump=str $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).loc.txt:		$(EXE_DIR)/$(EXE_FILENAME) $(EXTRA_DEPEND_LIST)
	$(Q)readelf -W --debug-dump=loc $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(Q)$(TODOS) $(TODOS_OPT) $@
endif


# Dump debug information
#
reports: $(DUMP_DIR)/$(EXE_FILENAME).ReadElf.txt \
			$(DUMP_DIR)/$(EXE_FILENAME).info.txt \
			$(DUMP_DIR)/$(EXE_FILENAME).rawline.txt \
			$(DUMP_DIR)/$(EXE_FILENAME).decodedline.txt \
			$(DUMP_DIR)/$(EXE_FILENAME).abbrev.txt \
			$(DUMP_DIR)/$(EXE_FILENAME).pubnames.txt \
			$(DUMP_DIR)/$(EXE_FILENAME).aranges.txt \
			$(DUMP_DIR)/$(EXE_FILENAME).macro.txt \
			$(DUMP_DIR)/$(EXE_FILENAME).frames.txt \
			$(DUMP_DIR)/$(EXE_FILENAME).addr.txt \
			$(DUMP_DIR)/$(EXE_FILENAME).str.txt \
			$(DUMP_DIR)/$(EXE_FILENAME).loc.txt


# Clean project
#	
clean:	clean_objs \
		clean_exe
#
# Clean objs
clean_objs:
	@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the obj files...\033[00m"	
	$(Q)rm -f $(OBJS)
	$(Q)rm -f $(OBJ_ASM)/STARTUP.o
#
# Clean executable
clean_exe:
	@echo -e "\033[01;33m***\033[$(COLOR_REMOVE)m Removing the application file...\033[00m"	
	$(Q)rm -f $(PROGS)


# Create directories
#
makedirs:	mkdir_exe \
			mkdir_s \
			mkdir_su \
			mkdir_obj \
			mkdir_reports
#
# Create the executables directories
mkdir_exe:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the application's directory...\033[00m"
		$(Q)mkdir -p $(EXE_DIR)
#
# Create the reports files directories
mkdir_reports:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the reports directories...\033[00m"
		$(Q)mkdir -p $(DUMP_DIR)
#
# Create the asm files, generated by compilation, directories	
mkdir_s:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the generated asm directories...\033[00m"
		$(Q)mkdir -p $(OBJ_S)
#
# Create the object, stack usage and dependence files directories
mkdir_obj:
mkdir_su:
		@echo -e "\033[01;33m***\033[$(COLOR_MKDIR)m Creating the dependencies and objs directories...\033[00m"
		$(Q)mkdir -p $(OBJ_C)
		$(Q)mkdir -p $(OBJ_ASM)
