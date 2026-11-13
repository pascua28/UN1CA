# Use TEE SPI in setCosNameProp()
HEX_PATCH "$WORK_DIR/system/system/lib64/libsec_sem.so" \
    "e0031f2a52000014" \
    "2000805252000014"

if [ -d "$WORK_DIR/product/overlay/SoftapOverlay" ] && [ -f "$WORK_DIR/vendor/overlay/SoftapOverlay/SoftapOverlay.apk" ]; then
    DELETE_FROM_WORK_DIR "product" "overlay/SoftapOverlay"
fi
