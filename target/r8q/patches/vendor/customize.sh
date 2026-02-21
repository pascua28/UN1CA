LOG_STEP_IN "- Replacing vibrator blobs with a73xqxx"
DELETE_FROM_WORK_DIR "vendor" "bin/hw/vendor.samsung.hardware.vibrator@2.2-service"
DELETE_FROM_WORK_DIR "vendor" "etc/init/vendor.samsung.hardware.vibrator@2.2-service.rc"
DELETE_FROM_WORK_DIR "vendor" "lib64/vendor.samsung.hardware.vibrator@2.0.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/vendor.samsung.hardware.vibrator@2.1.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/vendor.samsung.hardware.vibrator@2.2.so"
sed -i '/<hal format="hidl">.*/{:a;N;/<\/hal>/!ba;/android.hardware.vibrator/d}' $WORK_DIR/vendor/etc/vintf/manifest.xml

ADD_TO_WORK_DIR "a73xqxx" "vendor" "bin/hw/vendor.samsung.hardware.vibrator-service" 0 2000 755 "u:object_r:hal_vibrator_default_exec:s0"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "etc/init/vendor.samsung.hardware.vibrator-default.rc" 0 0 644 "u:object_r:vendor_configs_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "etc/vintf/manifest/vendor.samsung.hardware.vibrator-default.xml" 0 0 644 "u:object_r:vendor_configs_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "lib64/vendor.samsung.hardware.vibrator-V3-ndk_platform.so" 0 0 644 "u:object_r:vendor_configs_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Adding a73xqxx MIDAS"
DELETE_FROM_WORK_DIR "vendor" "etc/midas"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "etc/midas"
LOG_STEP_OUT

LOG_STEP_IN "- Fixing MIDAS model detection"
sed -i "s/a73xq/r8q/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"
sed -i "s/ro.product.device/ro.product.vendor.device/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"
LOG_STEP_OUT

echo "Fix MIDAS model detection"
sed -i "s/ro.product.device/ro.product.vendor.device/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"

echo "Remove DualDAR mount points"
sed -i "/keydata/d" "$WORK_DIR/vendor/etc/fstab.qcom"
sed -i "/keyrefuge/d" "$WORK_DIR/vendor/etc/fstab.qcom"

echo "Fix NFC for G781B"
if ! grep -q "G781B" "$WORK_DIR/vendor/etc/init/init.nfc.samsung.rc"; then
    {
        echo ""
        echo "on property:ro.boot.em.model=SM-G781B"
        echo "    setprop ro.boot.product.hardware.sku \"s3fwrn5\""
        echo "    setprop ro.vendor.nfc.feature.chipname \"SLSI\""
        echo ""
        echo "on property:ro.boot.em.model=SM-G7810"
        echo "    setprop ro.boot.product.hardware.sku \"s3fwrn5\""
        echo "    setprop ro.vendor.nfc.feature.chipname \"SLSI\""
        echo ""
        echo "on property:ro.boot.em.model=SM-G781N"
        echo "    setprop ro.boot.product.hardware.sku \"s3fwrn5\""
        echo "    setprop ro.vendor.nfc.feature.chipname \"SLSI\""
    } >> "$WORK_DIR/vendor/etc/init/init.nfc.samsung.rc"
fi
