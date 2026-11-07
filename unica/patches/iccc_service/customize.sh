APPLY_PATCH "system" "system/framework/services.jar" \
    "$MODPATH/iccc/services.jar/0001-Nuke-ICCC-service.patch"

APPLY_PATCH "system" "system/framework/framework.jar" \
    "$MODPATH/iccc/framework.jar/0001-Nuke-ICCC-service.patch"

EVAL "rm -f \"$APKTOOL_DIR/system/framework/framework.jar/smali_classes6/com/samsung/android/iccc/IIntegrityControlCheckCenter\\\$Stub.smali\""
EVAL "rm -f \"$APKTOOL_DIR/system/framework/framework.jar/smali_classes6/com/samsung/android/iccc/IIntegrityControlCheckCenter\\\$Stub\\\$Proxy.smali\""
EVAL "rm -f \"$APKTOOL_DIR/system/framework/framework.jar/smali_classes6/com/samsung/android/iccc/IIntegrityControlCheckCenter\\\$Default.smali\""
EVAL "rm -f \"$APKTOOL_DIR/system/framework/framework.jar/smali_classes6/com/samsung/android/iccc/IIntegrityControlCheckCenter.smali\""

EVAL "rm -f \"$APKTOOL_DIR/system/framework/services.jar/smali/com/android/server/IcccManagerService\\\$1.smali\""
