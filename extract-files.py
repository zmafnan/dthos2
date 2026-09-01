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
