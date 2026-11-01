SMALI_PATCH "system" "system/priv-app/SamsungDeviceHealthManagerService/SamsungDeviceHealthManagerService.apk" \
    "smali/c4/c.smali" "replace" \
    '<clinit>()V' \
    'SM6375' \
    'SM7150'

SMALI_PATCH "system" "system/priv-app/SamsungDeviceHealthManagerService/SamsungDeviceHealthManagerService.apk" \
    "smali/n5/i0.smali" "replace" \
    '<clinit>()V' \
    'SM6375' \
    'SM7150'
