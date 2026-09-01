#
# SPDX-FileCopyrightText: 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# HyperOS 2 (OS2.0.214.0.VMFMIXM) stock kernel 5.10.236 modules

ARISTOTLE_MODULES_PATH := device/xiaomi/aristotle/prebuilt/modules

ARISTOTLE_RECOVERY_TOUCH_MODULES := \
    $(ARISTOTLE_MODULES_PATH)/vendor_dlkm/xiaomi_touch.ko \
    $(ARISTOTLE_MODULES_PATH)/vendor_dlkm/goodix_core.ko

BOARD_VENDOR_RAMDISK_KERNEL_MODULES := \
    $(ARISTOTLE_RECOVERY_TOUCH_MODULES)
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := \
    xiaomi_touch.ko \
    goodix_core.ko
BOARD_DO_NOT_STRIP_VENDOR_RAMDISK_MODULES := true

BOARD_VENDOR_KERNEL_MODULES := \
    $(wildcard $(ARISTOTLE_MODULES_PATH)/vendor_dlkm/*.ko)
BOARD_VENDOR_KERNEL_MODULES_LOAD := \
    $(strip $(shell cat $(ARISTOTLE_MODULES_PATH)/vendor_dlkm/modules.load 2>/dev/null))
BOARD_DO_NOT_STRIP_VENDOR_MODULES := true

BOARD_SYSTEM_KERNEL_MODULES :=
BOARD_SYSTEM_KERNEL_MODULES_LOAD :=
BOARD_DO_NOT_STRIP_SYSTEM_MODULES := true

BOARD_ODM_KERNEL_MODULES :=
