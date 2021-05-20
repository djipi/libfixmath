# Parameters list
#
# version is used
# cmd sets the command / order to be used


# Version detection
#
ifdef version
ifneq ($(version), Debug)
ifneq ($(version), Release)
ifneq ($(version), Profile)
ifneq ($(version), Retail)
$(error version is not recognised)
endif
endif
endif
endif
VERSION = $(shell echo $(version) | tr a-z A-Z)
else
$(error version is not recognised, must be either Debug, Release, Retail or - eventualy Profile)
endif


# Configuration
include ../../libfixmath/m68k/config.mk

# Libraries selection (lib-gcc, lib-m68k, null)
LIB_SELECT = lib-m68k
LIBC_SELECT = lib-gcc
LIBGCC_SELECT = lib-m68k
# Library version
VERSION_LIBS = 1.1
# Maths selection (cephes, fdlibm, libm-gcc, libm-m68k, null)
MATHS_SELECT = libm-gcc
# fdlibm version (5.2-2_IEEE_LIBM, 5.3_IEEE_LIBM)
VER_FDLIBM = 5.2-2
VER_EFDLIBM = IEEE_LIBM
VERSIONFDLIBM = $(VER_FDLIBM)_$(VER_EFDLIBM)
# cephes math version (2.2_cmath-MIEEE)
VER_CEPHESMATH = 2.2
VER_ECEPHESMATH = cmath-MIEEE
VERSIONCEPHESMATH = $(VER_CEPHESMATH)_$(VER_ECEPHESMATH)
# Executable selection (elf)
EXE_FORMAT	=	elf


# Directories 
SRC			=	./..
RUNTIME		=	./src/Runtime
EXE_DIR		=	./$(version)
DUMP_DIR	=	./$(version)/reports/$(FORMAT)
OBJ_C		=	./$(version)/obj/$(FORMAT)/$(COMPILER_C)
OBJ_ASM		=	./$(version)/obj/$(FORMAT)
OBJ_S		=	./$(version)/s/$(FORMAT)/$(COMPILER_C)
#
# Libraries directories list
DIR_LIBS	=	./$(version)/Lib
#
# Executable name
EXE_FILENAME = tests_$(version)_$(COMPILER_SELECT).$(EXE_FORMAT)


# Compiler information
ifeq ($(COMPILER_C_TYPE), gcc)
ACCURACY = -DFIXMATH_NO_ROUNDING -DFIXMATH_NO_OVERFLOW
PLATFORM = -DFIXMATH_NO_64BIT -DFIXMATH_OPTIMIZE_8BIT
COMPILE = -DFIXMATH_DEFINEVALUES -DFIXMATH_NO_CTYPE
# -DFIXMATH_NO_CACHE
ALGORITHMS = -DFIXMATH_SIN_LUT -DFIXMATH_FAST_SIN
CCDefine = -DTESTS_NO_PRINT -D$(VERSION) $(ACCURACY) $(PLATFORM) $(ALGORITHMS)
CFLAGS = -c -Wall -m68000 $(CCDefine)
ifeq ($(FORMAT), elf)
CFLAGSD = -gdwarf-2
endif
ifeq ($(version), Debug)
CFLAGS += -g $(CFLAGSD) -O0
# -fleading-underscore
else
ifeq ($(version), Profile)
CFLAGS += -pg -g $(CFLAGSD) -Ofast -DDEBUG -DNDEBUG
else
ifeq ($(version), Release)
CFLAGS += -Ofast -DNDEBUG
else
$(error version is not recognised)
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
AOPT = -s -v -fb -d$(VERSION) -d$(ASM)
ifneq ($(FORMAT), aout)
$(error FORMAT is not recognised, must be aout)
endif
else
ifeq ($(ASM), vasm)
AOPT = -m68000 -dwarf -F$(FORMAT) -D$(VERSION) -D$(ASM) -Ic:/SDK/AJaguar/OfficialJaguarKit/Include
else
$(error ASM is not recognised)
endif
endif


# Linker information
ifeq ($(EXE_FORMAT), elf)
LINKER_SCRIPT  = -belf32m68k -TJagELFls_$(version)
LINKER_OPTIONS = -e_start -EB -Ttext 0x4000
endif


# Libraries information
#
# libgcc selection
ifeq ($(LIBGCC_SELECT), lib-gcc)
LIB_GCC	= $(DIRLIBGCC)/libgcc.a
else
ifeq ($(LIBGCC_SELECT), lib-m68k)
LIB_GCC	= $(DIR_LIBS)/libgcc-$(VERSION_LIBS)_$(version)-M68K.$(FORMAT).a
endif
endif
# libc selection
ifeq ($(LIBC_SELECT), lib-gcc)
LIB_C = $(DIRLIBC)/libc.a $(DIRLIBC)/libbcc.a
else
ifeq ($(LIBC_SELECT), lib-m68k)
LIB_C = $(DIR_LIBS)/libc-$(VERSION_LIBS)_$(version)-M68K.$(FORMAT).a
endif
endif
#
# Libfixmath library
LIB_FIXMATH = ../../libfixmath/m68k/$(version)/lib/1.0/libfixmath-1.0_$(version)_$(COMPILER_SELECT).elf.a
#
# Maths funtions library selection
ifeq ($(MATHS_SELECT), cephes)
LIB_MATHS = $(DIR_LIBS)/cephes/cephes-$(VERSIONCEPHESMATH)_$(version)_m68k-$(COMPILER_SELECT).$(FORMAT).a
else
ifeq ($(MATHS_SELECT), fdlibm)
LIB_MATHS = $(DIR_LIBS)/fdlibm/$(VERSIONFDLIBM)/fdlibm-$(VERSIONFDLIBM)_$(version)_m68k-$(COMPILER_SELECT).$(FORMAT).a
else
ifeq ($(MATHS_SELECT), libm-gcc)
LIB_MATHS = $(DIRLIBC)/libm.a
else
ifeq ($(MATHS_SELECT), libm-m68k)
LIB_MATHS = $(DIR_LIBS)/libm-$(VERSION_LIBS)_$(version)-M68K.$(FORMAT).a
else
ifeq ($(MATHS_SELECT), null)
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


# Check directory existence
#
ifneq ($(cmd), makedirs)
ifeq ("$(wildcard $(OBJ_C))","")
$(error the directories to create $(EXE_FILENAME) don't exist, please use makedirs command)
endif
endif


# Obj list
OBJS	=	$(OBJ_C)/tests_basic.o \
			$(OBJ_C)/tests_lerp.o \
			$(OBJ_C)/tests_macros.o \
			$(OBJ_C)/tests_sqrt.o \
			$(OBJ_C)/tests_str.o \
			$(OBJ_C)/tests.o
#
OBJS_S	=	$(OBJ_S)/tests_basic.s \
			$(OBJ_S)/tests_lerp.s \
			$(OBJ_S)/tests_macros.s \
			$(OBJ_S)/tests_sqrt.s \
			$(OBJ_S)/tests_str.s \
			$(OBJ_S)/tests.s
#
# Executable list
PROGS	=	$(EXE_DIR)/$(EXE_FILENAME)


all:	assemble \
		compile \
		link
#
rebuild:	clean \
			all
#	
assemble:	assemble_tests
#
compile:	compile_tests
#
link:	link_tests


compile_tests:	$(OBJS) $(OBJS_S)
#
# C compilation
$(OBJ_C)/tests.o:	$(SRC)/tests.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) $(CCINC) $(CCOBJ)
$(OBJ_S)/tests.s:	$(SRC)/tests.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) -S $(CCINC) $(CCOBJ)
$(OBJ_C)/tests_basic.o:	$(SRC)/tests_basic.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) $(CCINC) $(CCOBJ)
$(OBJ_S)/tests_basic.s:	$(SRC)/tests_basic.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) -S $(CCINC) $(CCOBJ)
$(OBJ_C)/tests_lerp.o:	$(SRC)/tests_lerp.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) $(CCINC) $(CCOBJ)
$(OBJ_S)/tests_lerp.s:	$(SRC)/tests_lerp.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) -S $(CCINC) $(CCOBJ)
$(OBJ_C)/tests_macros.o:	$(SRC)/tests_macros.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) $(CCINC) $(CCOBJ)
$(OBJ_S)/tests_macros.s:	$(SRC)/tests_macros.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) -S $(CCINC) $(CCOBJ)
$(OBJ_C)/tests_sqrt.o:	$(SRC)/tests_sqrt.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) $(CCINC) $(CCOBJ)
$(OBJ_S)/tests_sqrt.s:	$(SRC)/tests_sqrt.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) -S $(CCINC) $(CCOBJ)
$(OBJ_C)/tests_str.o:	$(SRC)/tests_str.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) $(CCINC) $(CCOBJ)
$(OBJ_S)/tests_str.s:	$(SRC)/tests_str.c makefile Build.bat JagELFls_$(version)
	$(CCProg) $< $(CFLAGS) -S $(CCINC) $(CCOBJ)


assemble_tests:	$(OBJ_ASM)/STARTUP.o
#
$(OBJ_ASM)/STARTUP.o:	$(RUNTIME)/STARTUP.s makefile Build.bat JagELFls_$(version)
	$(ASMProg) $< $(AOPT) -o $@


link_tests:	$(PROGS)
#
# Executable creation
$(EXE_DIR)/$(EXE_FILENAME):	$(OBJS) makefile JagELFls_$(version) Build.bat $(OBJ_ASM)/STARTUP.o $(LIB_GCC) $(LIB_C) $(LIB_MATHS) $(LIB_FIXMATH)
	$(LNKProg) $(LINKER_OPTIONS) $(LINKER_SCRIPT) -o $@ $(OBJ_ASM)/STARTUP.o $(LIB_GCC) $(LIB_C) $(LIB_MATHS) $(OBJS) $(LIB_FIXMATH)


# Dump debug executable
ifeq ($(FORMAT), elf)
$(DUMP_DIR)/$(EXE_FILENAME).ReadElf.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W -a $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).info.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W --debug-dump=info $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).rawline.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W --debug-dump=rawline $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).decodedline.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W --debug-dump=decodedline $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).abbrev.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W --debug-dump=abbrev $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).pubnames.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W --debug-dump=pubnames $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).aranges.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W --debug-dump=aranges $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).macro.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W --debug-dump=macro $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).frames.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W --debug-dump=frames $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).addr.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W --debug-dump=addr $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).str.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W --debug-dump=str $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
$(DUMP_DIR)/$(EXE_FILENAME).loc.txt:		$(EXE_DIR)/$(EXE_FILENAME) makefile JagELFls_$(version) Build.bat
	readelf -W --debug-dump=loc $(EXE_DIR)/$(EXE_FILENAME) > $@
	$(TODOS) $(TODOS_OPT) $@
endif


# Dump debug information
#
debug_dump: $(DUMP_DIR)/$(EXE_FILENAME).ReadElf.txt \
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
	rm -f $(OBJS)
	rm -f $(OBJ_ASM)/STARTUP.o
#
# Clean executable
clean_exe:
	rm -f $(PROGS)


# Create directories
#
makedirs:	mkdir_reports \
			mkdir_su \
			mkdir_obj \
			mkdir_exe
#
# Create the reports files directories
mkdir_reports:
		mkdir -p $(DUMP_DIR)
#
# Create the executables directories
mkdir_exe:
		mkdir -p $(EXE_DIR)
#
# Create the object, stack usage and dependence files directories
mkdir_obj:
mkdir_su:
		mkdir -p $(OBJ_C)
		mkdir -p $(OBJ_ASM)
