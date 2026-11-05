# Use TEE SPI in setCosNameProp()
HEX_PATCH "$WORK_DIR/system/system/lib64/libsec_sem.so" \
    "e0031f2a52000014" \
    "2000805252000014"
