if [[ "$(GET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FMRADIO_CONFIG_CHIP_VENDOR")" == "0" ]]; then
    LOG "\033[0;33m! Nothing to do\033[0m"
    return 0
fi

if [ ! "$(GET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FMRADIO_SUPPORT_EXTERNAL_RADIO_CHIPSET")" ]; then
    if [ ! -f "$WORK_DIR/system/system/lib64/libfmradio_jni.so" ]; then
        ABORT "SEC_FLOATING_FEATURE_FMRADIO_SUPPORT_EXTERNAL_RADIO_CHIPSET is not set but \"libfmradio_jni.so\" is missing in /system/system/lib64"
    fi
fi

ADD_TO_WORK_DIR "m44xktt" "system" "system/etc/permissions/com.samsung.wrappers.libFmRadioImpl.FmRadio.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "m44xktt" "system" "system/etc/permissions/privapp-permissions-com.sec.android.app.fm.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "m44xktt" "system" "system/etc/permissions/signature-permissions-com.sec.android.app.fm.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "m44xktt" "system" "system/etc/sysconfig/preinstalled-packages-com.sec.android.app.fm.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "m44xktt" "system" "system/framework/samsungfmradiolib.jar" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_IN "- Adding r0qksx FMRadio"
ADD_TO_WORK_DIR "r0qksx" "system" "system/etc/permissions/privapp-permissions-com.sec.android.app.fm.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "r0qksx" "system" "system/etc/sysconfig/preinstalled-packages-com.sec.android.app.fm.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "r0qksx" "system" "system/priv-app/HybridRadio/HybridRadio.apk" 0 0 644 "u:object_r:system_file:s0"
