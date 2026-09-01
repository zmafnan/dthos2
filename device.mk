#
# SPDX-FileCopyrightText: 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/xiaomi/aristotle

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Enable project quotas and casefolding for emulated storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Dalvik VM configuration
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

PRODUCT_SHIPPING_API_LEVEL := 33
PRODUCT_ENFORCE_VINTF_MANIFEST := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/lineage/interfaces/power-libperfmgr \
    hardware/mediatek \
    hardware/mediatek/libmtkperf_client \
    hardware/xiaomi \
    vendor/xiaomi/aristotle

PRODUCT_SYSTEM_PARTITIONS_FILE_SYSTEM_TYPE := erofs

# Recovery & OTA
PRODUCT_PACKAGES += \
    checkpoint_gc \
    create_pl_dev \
    create_pl_dev.recovery \
    fastbootd \
    android.hardware.fastboot@1.1-impl.custom \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

# BootControl AIDL
PRODUCT_PACKAGES += \
    com.android.hardware.boot \
    android.hardware.boot-service.default_recovery

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.mediatek \
    android.hardware.health-service.mediatek-recovery

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

# Audio
PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    audio.usb.default \
    android.hardware.bluetooth.audio-impl \
    MtkInCallService

# Network
PRODUCT_PACKAGES += \
    com.android.hardware.net.nlinterceptor

# Sensor, Vibrator, IFAA & Power
PRODUCT_PACKAGES += \
    IFAAService \
    PowerOffAlarm \
    vibratorfeature-wrapper

PRODUCT_VENDOR_PROPERTIES += ro.vendor.sensors.xiaomi.udfps=true

# Overlays
PRODUCT_PACKAGES += \
    CarrierConfigOverlayMT6895 \
    FrameworksResOverlayMT6895 \
    LineageApertureOverlayMT6895 \
    LineageDialerMT6895 \
    LineageSDKOverlayMT6895 \
    LineageSettingsOverlayMT6895 \
    LineageSystemUIOverlayMT6895 \
    PowerOffAlarmOverlayMT6895 \
    SettingsOverlayMT6895 \
    SystemUIOverlayMT6895 \
    TetheringResOverlayMT6895 \
    WifiResOverlayMT6895

# Copy Files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/fstab.mt6895:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6895 \
    $(LOCAL_PATH)/rootdir/fstab.mt6895:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.mt6895 \
    $(LOCAL_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json \
    $(LOCAL_PATH)/configs/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

$(call inherit-product, vendor/mediatek/ims/ims.mk)
$(call inherit-product-if-exists, vendor/xiaomi/aristotle/aristotle-vendor.mk)
