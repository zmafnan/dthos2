#!/usr/bin/env -S PYTHONPATH=../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

"""Extract Xiaomi 13T (aristotle) HyperOS 2 baseline proprietary files."""

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    "device/xiaomi/aristotle",
    "hardware/mediatek",
    "hardware/xiaomi",
    "vendor/xiaomi/aristotle",
]


def lib_fixup_xiaomi_suffix(lib: str, partition: str, *args, **kwargs):
    """Disambiguate Xiaomi C++ blob from unrelated AOSP Rust crate."""
    return f"{lib}-xiaomi" if partition == "system_ext" else None


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    ("libsink",): lib_fixup_xiaomi_suffix,
}


blob_fixups: blob_fixups_user_type = {
    "vendor/bin/hw/android.hardware.security.keymint@1.0-service.mitee": blob_fixup()
    .replace_needed("android.hardware.keymaster@4.0.so", "android.hardware.keymaster@4.0-v31.so")
    .replace_needed("lib_android_keymaster_keymint_utils.so", "lib_android_keymaster_keymint_utils-v31.so")
    .replace_needed("libkeymaster_messages.so", "libkeymaster_messages-v31.so")
    .replace_needed("libkeymaster_portable.so", "libkeymaster_portable-v31.so")
    .replace_needed("libkeymint.so", "libkeymint-v31.so")
    .replace_needed("libcppbor_external.so", "libcppbor_external-v31.so")
    .replace_needed("libcppcose_rkp.so", "libcppcose_rkp-v31.so"),
    (
        "vendor/bin/hw/android.hardware.gnss-service.mediatek",
        "vendor/lib64/hw/android.hardware.gnss-impl-mediatek.so",
    ): blob_fixup().replace_needed(
        "android.hardware.gnss-V1-ndk_platform.so", "android.hardware.gnss-V1-ndk.so"
    ),
    "vendor/bin/hw/vendor.mediatek.hardware.mtkpower@1.0-service": blob_fixup().replace_needed(
        "android.hardware.power-V2-ndk_platform.so", "android.hardware.power-V2-ndk.so"
    ),
    (
        "vendor/etc/init/hw/init.batterysecret.rc",
        "vendor/etc/init/hw/init.mi_thermald.rc",
    ): blob_fixup().regex_replace(".*seclabel.*\n", ""),
    (
        "vendor/lib64/libMiPhotoFilter.so",
        "vendor/lib64/mt6895/libneuralnetworks_sl_driver_mtk_prebuilt.so",
    ): blob_fixup()
    .clear_symbol_version("AHardwareBuffer_allocate")
    .clear_symbol_version("AHardwareBuffer_createFromHandle")
    .clear_symbol_version("AHardwareBuffer_describe")
    .clear_symbol_version("AHardwareBuffer_getNativeHandle")
    .clear_symbol_version("AHardwareBuffer_isSupported")
    .clear_symbol_version("AHardwareBuffer_lock")
    .clear_symbol_version("AHardwareBuffer_lockPlanes")
    .clear_symbol_version("AHardwareBuffer_release")
    .clear_symbol_version("AHardwareBuffer_unlock"),
    (
        "vendor/lib/libnvram.so",
        "vendor/lib/libsysenv.so",
        "vendor/lib64/libnvram.so",
        "vendor/lib64/libsysenv.so",
    ): blob_fixup().add_needed("libbase_shim.so"),
    "system_ext/lib64/libimsma.so": blob_fixup().replace_needed(
        "libsink.so", "libsink-mtk.so"
    ),
}


module = ExtractUtilsModule(
    "aristotle",
    "xiaomi",
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)


if __name__ == "__main__":
    ExtractUtils.device(module).run()
