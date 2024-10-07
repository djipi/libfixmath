# Makefile config for the libfixmath's M68K library


# Format selection (elf, aout, coff)
FORMAT = elf


# Assembler selection (smac, vasm, rmac)
ASM = vasm
# VASM information (madmac, std, or mot)
ifeq ($(ASM), vasm)
VASM_SUPPORT = madmac
endif
# Compiler C type (gcc, vbcc)
COMPILER_C_TYPE	= gcc
# Compiler C version depend his type
COMPILER_C_VERSION = 5.5.0
# Compiler tools version depend his type
COMPILER_TOOLS_VERSION = 13.2.0
# Compiler selection based on type and version
COMPILER_C = $(COMPILER_C_TYPE)$(COMPILER_C_VERSION)
# Compiler selection based on type, and version
COMPILER_SELECT	= $(COMPILER_C_TYPE)-$(COMPILER_C_VERSION)
# Linker selection (jlinker, vlink, rln, sln)
LINKER_SELECT =	vlink


# Linker information
#
ifeq ($(LINKER_SELECT), vlink)
LNKProg = C:/VB/vlink0.17a
else
ifeq ($(LINKER_SELECT), rln)
LNKProg = C:/Tools/RlnRmac/rln
else
ifeq ($(LINKER_SELECT), sln)
LNKProg = C:/AJaguar/SlnSmac/sln
else
ifeq ($(LINKER_SELECT),jlinker)
LNKProg = C:/AJaguar/Jlinker/jlinker
else
$(error LINKER_SELECT is not set or wrongly dispatched)
endif
endif
endif
endif


# ASM information
#
ifeq ($(ASM), vasm)
ASMProg	= C:/VB/Vasmm68k/vasmm68k_$(VASM_SUPPORT)_win32_1.9f
else
ifeq ($(ASM), smac)
ASMProg	= C:/AJaguar/SlnSmac/smac
else
ifeq ($(ASM), rmac)
ASMProg	= C:/Tools/RlnRmac/rmac
else
$(error ASM is not set or wrongly dispatched)
endif
endif
endif


# String manipulation tools
TODOS = C:/Tools/tfd1713/todos

# Tools executables
ifneq ("$(wildcard C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_TOOLS_VERSION)/bin)","")
ARProg = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_TOOLS_VERSION)/bin/m68k-$(FORMAT)-ar
ARANProg = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_TOOLS_VERSION)/bin/m68k-$(FORMAT)-ranlib
readelf	= C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_TOOLS_VERSION)/bin/m68k-$(FORMAT)-readelf
stripelf = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_TOOLS_VERSION)/bin/m68k-$(FORMAT)-strip
objdump = C:/GNU/m68k-$(FORMAT)-gcc-$(COMPILER_TOOLS_VERSION)/bin/m68k-$(FORMAT)-objdump
else
$(error GNU toolchain $(COMPILER_TOOLS_VERSION) not found)
endif


# C compiler, headers & library information
#
# GCC
#
ifeq ($(COMPILER_C_TYPE), gcc)
# gcc compiler
ifneq ("$(wildcard C:/GNU/m68k-$(FORMAT)-$(COMPILER_SELECT)/bin)","")
CCProg = C:/GNU/m68k-$(FORMAT)-$(COMPILER_SELECT)/bin/m68k-$(FORMAT)-gcc
else
$(error $(COMPILER_SELECT) is not set or wrongly dispatched)
endif
# gcc headers library
ifneq ("$(wildcard C:/GNU/m68k-$(FORMAT)-$(COMPILER_SELECT)/m68k-$(FORMAT)/include)","")
CCINC1 = C:/GNU/m68k-$(FORMAT)-$(COMPILER_SELECT)/m68k-$(FORMAT)/include
CCINC2 = C:/GNU/m68k-$(FORMAT)-$(COMPILER_SELECT)/lib/gcc/m68k-$(FORMAT)/$(COMPILER_C_VERSION)/include
else
CCINC1 = C:/GNU/m68k-$(FORMAT)-gcc-4.9.3/m68k-$(FORMAT)/include
CCINC2 = C:/GNU/m68k-$(FORMAT)-gcc-4.9.3/lib/gcc/m68k-$(FORMAT)/4.9.3/include
endif
# gcc libraries
ifneq ("$(wildcard C:/GNU/m68k-$(FORMAT)-$(COMPILER_SELECT)/lib/gcc/m68k-$(FORMAT)/$(COMPILER_C_VERSION)/mcpu32)", "")
DIRLIBGCC = C:/GNU/m68k-$(FORMAT)-$(COMPILER_SELECT)/lib/gcc/m68k-$(FORMAT)/$(COMPILER_C_VERSION)
DIRLIBC = C:/GNU/m68k-$(FORMAT)-$(COMPILER_SELECT)/m68k-$(FORMAT)/lib
else
DIRLIBGCC = C:/GNU/m68k-$(FORMAT)-gcc-4.9.3/lib/gcc/m68k-$(FORMAT)/4.9.3
DIRLIBC = C:/GNU/m68k-$(FORMAT)-gcc-4.9.3/m68k-$(FORMAT)/lib
endif
#
# VBCC
#
else
ifeq ($(COMPILER_C_TYPE), vbcc)
#
# ELF format
ifeq ($(FORMAT), elf)
# ELF vbcc compiler
CCProg = C:/VB/vbcc$(COMPILER_C_VERSION)/bin/vc
# CCProg = C:/VB/vbcc$(COMPILER_C_VERSION)/bin/vbccm68k
#
# Unknown format
else
$(error FORMAT is not set or wrongly dispatched for $(COMPILER_SELECT))
endif
#
# Compiler not set
#
else
$(error COMPILER_C_TYPE is not set or wrongly dispatched)
endif
endif
