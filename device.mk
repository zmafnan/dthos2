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

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service.lineage-libperfmgr \
    vendor.mediatek.hardware.mtkpower@1.2-service.stub

# Graphics composer service for the stock HIDL HWC implementation & Gralloc dependencies
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.3-service \
    android.hardware.graphics.allocator@4.0.vendor \
    android.hardware.graphics.common@1.0.vendor \
    android.hardware.graphics.common@1.1.vendor \
    android.hardware.graphics.common@1.2.vendor \
    android.hardware.graphics.mapper@2.0.vendor \
    android.hardware.graphics.mapper@2.1.vendor \
    android.hardware.graphics.mapper@3.0.vendor \
    android.hardware.graphics.mapper@4.0.vendor \
    libgralloctypes.vendor \
    libdmabufheap.vendor \
    libdrm.vendor \
    libion.vendor \
    libbase_shim

# Stock HOS2 KeyMint ABI required by the Android 31 MiTEE service
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-v31 \
    android.hardware.keymaster@4.0-v31 \
    android.hardware.security.keymint-V1-ndk_platform-v31 \
    android.hardware.security.secureclock-V1-ndk_platform-v31 \
    android.hardware.security.sharedsecret-V1-ndk_platform-v31 \
    lib_android_keymaster_keymint_utils-v31 \
    libcppbor_external-v31 \
    libcppcose_rkp-v31 \
    libkeymaster_messages-v31 \
    libkeymaster_portable-v31 \
    libkeymint-v31 \
    libpuresoftkeymasterdevice-v31 \
    libsoft_attestation_cert-v31

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@7.1-impl \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.soundtrigger@2.3-impl \
    android.hardware.audio.service \
    audio.primary.default \
    audio.bluetooth.default \
    audio.usb.default \
    android.hardware.bluetooth.audio-impl \
    MtkInCallService

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.6.vendor \
    android.hardware.camera.common@1.0.vendor \
    android.hardware.camera.device@3.2.vendor \
    android.hardware.camera.device@3.3.vendor \
    android.hardware.camera.device@3.4.vendor \
    android.hardware.camera.device@3.5.vendor \
    android.hardware.camera.device@3.6.vendor \
    android.frameworks.sensorservice@1.0.vendor \
    libsensorndkbridge \
    libcamera_metadata.vendor

# Wi-Fi
$(call soong_config_set_bool,mediatek_wifi_hal,use_pre_u_qpr2_struct,true)

PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    libwifi-hal-wrapper \
    wpa_supplicant \
    libnl.vendor

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/wifi/,$(TARGET_COPY_OUT_VENDOR)/etc/wifi)

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0.vendor \
    android.hardware.bluetooth@1.1.vendor \
    android.hardware.bluetooth.audio@2.0.vendor \
    android.hardware.bluetooth.audio@2.1.vendor \
    android.hardware.bluetooth.audio@2.2.vendor

# Network & Radio
PRODUCT_PACKAGES += \
    com.android.hardware.net.nlinterceptor \
    android.hardware.radio@1.0.vendor \
    android.hardware.radio@1.1.vendor \
    android.hardware.radio@1.2.vendor \
    android.hardware.radio@1.3.vendor \
    android.hardware.radio@1.4.vendor \
    android.hardware.radio@1.5.vendor \
    android.hardware.radio@1.6.vendor \
    android.hardware.radio.config@1.0.vendor \
    android.hardware.radio.config@1.1.vendor \
    android.hardware.radio.config@1.2.vendor \
    android.hardware.radio.config@1.3.vendor

# Vendor HALs & Libraries
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0.vendor \
    android.hardware.usb@1.1.vendor \
    android.hardware.usb@1.2.vendor \
    android.hardware.gnss@1.0.vendor \
    android.hardware.gnss@1.1.vendor \
    android.hardware.gnss@2.0.vendor \
    android.hardware.gnss@2.1.vendor \
    android.hardware.drm@1.0.vendor \
    android.hardware.drm@1.1.vendor \
    android.hardware.drm@1.2.vendor \
    android.hardware.drm@1.3.vendor \
    android.hardware.drm@1.4.vendor \
    android.hardware.secure_element@1.0.vendor \
    android.hardware.secure_element@1.1.vendor \
    android.hardware.secure_element@1.2.vendor \
    android.hardware.power@1.0.vendor \
    android.hardware.power@1.1.vendor \
    android.hardware.power@1.2.vendor \
    libexpat.vendor \
    libcurl.vendor \
    libpcap.vendor

# Fingerprint / UDFPS
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.xiaomi \
    libudfpshandler \
    vendor.xiaomi.hardware.fx.tunnel@1.0.vendor \
    libhidltransport \
    libhidltransport.vendor \
    libhwbinder \
    libhwbinder.vendor \
    libion.vendor

# Permissions & Feature XMLs
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.telephony.calling.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.calling.xml \
    frameworks/native/data/etc/android.hardware.telephony.data.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.data.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.telephony.messaging.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.messaging.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_3.xml \
    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    $(LOCAL_PATH)/configs/adb_keys:root/adb_keys \
    $(LOCAL_PATH)/configs/adb_keys:$(TARGET_COPY_OUT_PRODUCT)/etc/security/adb_keys \
    $(LOCAL_PATH)/configs/adb_keys:$(TARGET_COPY_OUT_SYSTEM)/etc/security/adb_keys

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.lineage

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@2.0-subhal-impl-1.0 \
    android.hardware.sensors-service.xiaomi-multihal \
    sensors.xiaomi.v2 \
    sensors.dynamic_sensor_hal

# Vibrator, IFAA & Power
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
    $(LOCAL_PATH)/rootdir/fstab.mt6895:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt6895 \
    $(LOCAL_PATH)/rootdir/init.mt6895.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mt6895.rc \
    $(LOCAL_PATH)/rootdir/init.mtkgki.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mtkgki.rc \
    $(LOCAL_PATH)/rootdir/init.batterysecret.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.batterysecret.rc \
    $(LOCAL_PATH)/rootdir/init.cgroup.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.cgroup.rc \
    $(LOCAL_PATH)/rootdir/init.connectivity.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.connectivity.rc \
    $(LOCAL_PATH)/rootdir/init.connectivity.common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.connectivity.common.rc \
    $(LOCAL_PATH)/rootdir/init_conninfra.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init_conninfra.rc \
    $(LOCAL_PATH)/rootdir/init.mi_thermald.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mi_thermald.rc \
    $(LOCAL_PATH)/rootdir/init.sensor_2_0.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.sensor_2_0.rc \
    $(LOCAL_PATH)/rootdir/init.project.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.project.rc \
    $(LOCAL_PATH)/rootdir/init.mt6895.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mt6895.usb.rc \
    $(LOCAL_PATH)/rootdir/init.fingerprint.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.fingerprint.rc \
    $(LOCAL_PATH)/rootdir/ueventd.mt6895.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    $(LOCAL_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json \
    $(LOCAL_PATH)/configs/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

$(call inherit-product, vendor/mediatek/ims/ims.mk)
$(call inherit-product-if-exists, vendor/xiaomi/aristotle/aristotle-vendor.mk)

# Filter out deprecated/broken vendor lights HAL inherited from aristotle-vendor.mk
PRODUCT_PACKAGES := $(filter-out android.hardware.lights-service.mediatek,$(PRODUCT_PACKAGES))
PRODUCT_COPY_FILES := $(filter-out %/lights-mtk-default.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/lights-mtk-default.rc,$(PRODUCT_COPY_FILES))

