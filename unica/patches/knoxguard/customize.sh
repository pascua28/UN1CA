# SEC_PRODUCT_FEATURE_KNOX_SUPPORT_KNOXGUARD
APPLY_PATCH "system" "system/framework/services.jar" \
    "$MODPATH/services.jar/0001-Disable-KnoxGuard.patch"

SET_FLOATING_FEATURE_CONFIG \
        "SEC_FLOATING_FEATURE_FRAMEWORK_SUPPORT_BLOCKCHAIN_SERVICE" --delete
    DECODE_APK "system" "system/framework/framework.jar"

SET_PROP_IF_DIFF "vendor" "ro.security.fips.ux" "Disabled"

SMALI_PATCH "system" "system/framework/framework.jar" \
    "smali_classes6/com/samsung/android/ProductPackagesRune.smali" "replaceall" \
    "SERVICE_SAMSUNG_BLOCKCHAIN:Z = true" \
    "SERVICE_SAMSUNG_BLOCKCHAIN:Z = false"
