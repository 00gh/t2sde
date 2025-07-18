dnl --- T2-COPYRIGHT-BEGIN ---
dnl t2/architecture/powerpc/linux.conf.m4
dnl Copyright (C) 2004 - 2025 The T2 SDE Project
dnl SPDX-License-Identifier: GPL-2.0
dnl --- T2-COPYRIGHT-END ---

define(`PPC', 'PowerPC')dnl

dnl System type (default=Macintosh)
dnl
CONFIG_PPC=y
CONFIG_6xx=y
CONFIG_CLASSIC32=y
# CONFIG_4xx is not set
# CONFIG_PPC64 is not set
# CONFIG_82xx is not set
# CONFIG_8xx is not set
CONFIG_PMAC=y
CONFIG_PREP=y
CONFIG_CHRP=y
CONFIG_ALL_PPC=y
# CONFIG_GEMINI is not set
# CONFIG_APUS is not set

CONFIG_NR_CPUS=4

dnl additional 2.6 kernel configs
CONFIG_PPC32=y
# CONFIG_40x is not set
# CONFIG_POWER3 is not set

CONFIG_ALTIVEC=y

dnl more than 768 MB of RAM
CONFIG_HIGHMEM=y

dnl Platform specific support
dnl

CONFIG_PROC_DEVICETREE=y

CONFIG_ADB=y
CONFIG_ADB_CUDA=y
CONFIG_ADB_PMU=y
CONFIG_PMAC_APM_EMU=y
CONFIG_PMAC_MEDIABAY=y
CONFIG_PMAC_BACKLIGHT=y
CONFIG_ADB_MACIO=y
CONFIG_INPUT_ADBHID=y
CONFIG_USB_HIDINPUT_POWERBOOK=y
CONFIG_MAC_EMUMOUSEBTN=y

dnl older IBM machines
CONFIG_ISA=y

include(`linux-common.conf.m4')
include(`linux-block.conf.m4')
include(`linux-net.conf.m4')
include(`linux-fs.conf.m4')

# CONFIG_FONT_PEARL_8x8 is not set

dnl read-only enlarges kernel by 66%, does not load on IBM rs6k B50
# CONFIG_STRICT_KERNEL_RWX is not set

dnl macs need a special RTC ... (this needs to be fixed in the kernel so we
dnl can have generic support for the rs6k and mac support at the same time)
dnl
CONFIG_GEN_RTC=y
CONFIG_PPC_RTC=y

CONFIG_SERIAL_PMACZILOG=y
CONFIG_SERIAL_PMACZILOG_CONSOLE=y

dnl AGP
dnl
CONFIG_AGP_UNINORTH=y
CONFIG_FB=m

dnl power management
dnl
CONFIG_PMAC_PBOOK=y
CONFIG_PMAC_BACKLIGHT=y
CONFIG_PMAC_APM_EMU=y

dnl the thermal control stuff needed for newer desktop macs and iBook G4
dnl
CONFIG_I2C=y
CONFIG_I2C_POWERMAC=y
CONFIG_I2C_KEYWEST=y
CONFIG_THERM_WINDTUNNEL=y
CONFIG_THERM_ADT746X=y

dnl for 2.6 kernels
dnl
CONFIG_TAU=y

CONFIG_CPU_FREQ_PMAC=y

CONFIG_BLK_DEV_IDE_PMAC=y
CONFIG_BLK_DEV_IDE_PMAC_ATA100FIRST=y
CONFIG_BLK_DEV_IDEDMA_PMAC=y
CONFIG_BLK_DEV_IDE_PMAC_BLINK=y
CONFIG_PMU_HD_BLINK=y
# CONFIG_MAC_ADBKEYCODES is not set

dnl some network teaks (the GMAC is obsoleted by SUNGEM)
dnl
# CONFIG_GMAC is not set
CONFIG_SUNGEM=m

CONFIG_XMON=y

dnl enables PATA_LEGACY
# CONFIG_PATA_QDI is not set
