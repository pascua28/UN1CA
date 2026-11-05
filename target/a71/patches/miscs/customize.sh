# Use TEE SPI in setCosNameProp()
HEX_PATCH "$WORK_DIR/system/system/lib64/libsec_sem.so" \
    "e0031f2a52000014" \
    "2000805252000014"

if [[ "$SOURCE_PLATFORM_SDK_VERSION" -ge 36 ]]; then
    LOG_STEP_IN "- Updating Codec2 seccomp policy"
    EVAL "sed -i 's/mremap: arg3 == 3/mremap: 1/g' \"$WORK_DIR/vendor/etc/seccomp_policy/samsung.software.media.c2-base-policy\""
fi
