# Show Samsung battery health/manufacture/cycle info outside Samsung's
# model/region allowlist.
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes3/com/samsung/android/settings/deviceinfo/batteryinfo/BatteryRegulatoryPreferenceController.smali" "return" \
    'getAvailabilityStatus()I' \
    '0'
