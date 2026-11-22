DECODE_APK "system" "system/priv-app/PhotoEditor_AIFull/PhotoEditor_AIFull.apk"
LOG "Patching PhotoEditor_AIFull (AI watermark removal)"

SMALI_PATCH "system" "system/priv-app/PhotoEditor_AIFull/PhotoEditor_AIFull.apk" \
    "smali_classes4/com/sec/android/mimage/photoretouching/spe/util/f.smali" "null" \
    'o0(Landroid/graphics/Canvas;Landroid/content/Context;)V'
