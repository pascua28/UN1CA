SET_PROP_IF_DIFF "vendor" "ro.security.fips.ux" "Disabled"

DELETE_FROM_WORK_DIR "system" "system/app/BlockchainBasicKit"
DELETE_FROM_WORK_DIR "system" "system/bin/dualdard"
DELETE_FROM_WORK_DIR "system" "system/etc/init/dualdard.rc"
DELETE_FROM_WORK_DIR "system" "system/etc/init/kpp.init.rc"
DELETE_FROM_WORK_DIR "system" "system/etc/init/kss.init.rc"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.hdmapp.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.kgclient.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.kfbp.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.knnr.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.mpos.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.pushmanager.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.sandbox.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.zt.framework.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/signature-permissions-com.samsung.android.kgclient.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/sysconfig/preinstalled-packages-com.samsung.android.coldwalletservice.xml"
DELETE_FROM_WORK_DIR "system" "system/priv-app/HdmApk"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxFrameBufferProvider"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxGuard"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxMposAgent"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxNeuralNetworkRuntime"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxPushManager"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxSandbox"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxZtFramework"

DECODE_APK "system" "system/framework/services.jar"
SOURCE_FILE_ATTR="$(grep -F ".source" "$APKTOOL_DIR/system/framework/services.jar/smali/android/gsi/GsiProgress.smali")"
SOURCE_FILE_ATTR="${SOURCE_FILE_ATTR//\./\\\.}"
SOURCE_FILE_ATTR="${SOURCE_FILE_ATTR//\"/\\\"}"
SOURCE_FILE_ATTR="${SOURCE_FILE_ATTR//\//\\\/}"
LOG "- Replacing SourceFile attribute in /system/system/framework/services.jar"
find "$APKTOOL_DIR/system/framework/services.jar" -type f -name "*.smali" -print0 \
    | xargs -0 -I "{}" -P "$(nproc)" sed -i "s/^\.source.*/\.source \"SourceFile\"/g" "{}"
if [[ "$SOURCE_PRODUCT_SHIPPING_API_LEVEL" != "$TARGET_PRODUCT_SHIPPING_API_LEVEL" ]]; then
    SMALI_PATCH "system" "system/framework/services.jar" \
        "smali/com/android/server/knox/dar/ddar/ta/TAProxy.smali" "replace" \
        "updateServiceHolder(Z)V" \
        "$TARGET_PRODUCT_SHIPPING_API_LEVEL" \
        "$SOURCE_PRODUCT_SHIPPING_API_LEVEL" \
        > /dev/null
fi

# SEC_PRODUCT_FEATURE_KNOX_SUPPORT_DUAL_DAR
APPLY_PATCH "system" "system/app/Traceur/Traceur.apk" \
    "$MODPATH/ddar/Traceur.apk/0001-Nuke-Knox-DualDAR.patch"
APPLY_PATCH "system" "system/framework/framework.jar" \
    "$MODPATH/ddar/framework.jar/0001-Nuke-Knox-DualDAR.patch"
APPLY_PATCH "system" "system/framework/framework.jar" \
    "$MODPATH/ddar/framework.jar/0002-Nuke-MDF.patch"
APPLY_PATCH "system" "system/framework/knoxsdk.jar" \
    "$MODPATH/ddar/knoxsdk.jar/0001-Nuke-Knox-DualDAR.patch"
APPLY_PATCH "system" "system/framework/services.jar" \
    "$MODPATH/ddar/services.jar/0001-Nuke-Knox-DualDAR.patch"
APPLY_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    "$MODPATH/ddar/DeviceDiagnostics.apk/0001-Nuke-Knox-DualDAR.patch"
APPLY_PATCH "system" "system/priv-app/KnoxCore/KnoxCore.apk" \
    "$MODPATH/ddar/KnoxCore.apk/0001-Nuke-Knox-DualDAR.patch"
APPLY_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    "$MODPATH/ddar/ManagedProvisioning.apk/0001-Nuke-Knox-DualDAR.patch"
APPLY_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "$MODPATH/ddar/SecSettings.apk/0001-Nuke-Knox-DualDAR.patch"
APPLY_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "$MODPATH/ddar/SecSettingsIntelligence.apk/0001-Nuke-Knox-DualDAR.patch"
APPLY_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    "$MODPATH/ddar/StorageManager.apk/0001-Nuke-Knox-DualDAR.patch"

# SEC_PRODUCT_FEATURE_KNOX_SUPPORT_HDM
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmVersion()Ljava/lang/String;' \
    '    .locals 1\n\n    const/4 v0, 0x0\n\n    return-object v0'
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'generateNonce()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmId(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmIdB64()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmPolicy(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getRevocationInfo()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "isNFCBlockedByHDM()Z" \
    "false"
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "isSwBlockEnabled()Z" \
    "false"
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "removeRevocationInfo()I" \
    "-1"
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'setHdmPolicy(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "setHdmTaCmd(I)I" \
    "-1"
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "setSwBlock(Z)Z" \
    "false"
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'syncRevocationInfo(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "syncSwBlockFromBoot()I" \
    "-1"

APPLY_PATCH "system" "system/framework/knoxsdk.jar" \
    "$MODPATH/hdm/knoxsdk.jar/0001-Nuke-Knox-HDM.patch"
if [[ "$SOURCE_PRODUCT_SHIPPING_API_LEVEL" != "$TARGET_PRODUCT_SHIPPING_API_LEVEL" ]]; then
    SMALI_PATCH "system" "system/framework/services.jar" \
        "smali/com/android/server/enterprise/hdm/HdmSakManager.smali" "replace" \
        "isSupported(Landroid/content/Context;)Z" \
        "$TARGET_PRODUCT_SHIPPING_API_LEVEL" \
        "$SOURCE_PRODUCT_SHIPPING_API_LEVEL" \
        > /dev/null
fi

# TODO nuke HdmVendorController.smali
APPLY_PATCH "system" "system/framework/services.jar" \
    "$MODPATH/hdm/services.jar/0001-Nuke-Knox-HDM.patch"
SMALI_PATCH "system" "system/framework/services.jar" \
    'smali/com/android/server/enterprise/hdm/HdmVendorController.smali' "replacebody" \
    'parseDeviceResponse(ILjava/lang/String;[B)[B' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/framework/services.jar" \
    'smali/com/android/server/enterprise/hdm/HdmVendorController.smali' "replacebody" \
    'getService()Lvendor/samsung/hardware/khdm/ISehKhdm;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/framework/services.jar" \
    'smali/com/android/server/enterprise/hdm/HdmVendorController.smali' "replacebody" \
    'hdmApplyPolicy([B[B[B[B[BZ)[B' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/framework/services.jar" \
    'smali/com/android/server/enterprise/hdm/HdmVendorController.smali' "replacebody" \
    'hdmGenerateNonce(Z)[B' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/framework/services.jar" \
    'smali/com/android/server/enterprise/hdm/HdmVendorController.smali' "replacebody" \
    'hdmGetId(Z[B[B)[B' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/enterprise/hdm/HdmVendorController.smali" "return" \
    "hdmGetKey()I" \
    "-1"
SMALI_PATCH "system" "system/framework/services.jar" \
    'smali/com/android/server/enterprise/hdm/HdmVendorController.smali' "replacebody" \
    'hdmGetPolicy(Z[B[B)[B' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/framework/services.jar" \
    'smali/com/android/server/enterprise/hdm/HdmVendorController.smali' "replacebody" \
    'hdmGetRevocationInfo(Z)[B' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/enterprise/hdm/HdmVendorController.smali" "return" \
    "hdmKgCmd(I)I" \
    "-1"
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/enterprise/hdm/HdmVendorController.smali" "return" \
    "hdmLoad()I" \
    "-1"
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/enterprise/hdm/HdmVendorController.smali" "return" \
    "hdmRemoveRevocationInfo()I" \
    "-1"
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/enterprise/hdm/HdmVendorController.smali" "return" \
    "hdmSetKey([B)I" \
    "-1"
SMALI_PATCH "system" "system/framework/services.jar" \
    'smali/com/android/server/enterprise/hdm/HdmVendorController.smali' "replacebody" \
    'hdmSyncRevocationInfo(Z[B)[B' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/enterprise/hdm/HdmVendorController.smali" "return" \
    "hdmUnload()I" \
    "-1"

SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmVersion()Ljava/lang/String;' \
    '    .locals 1\n\n    const/4 v0, 0x0\n\n    return-object v0'
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'generateNonce()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmId(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmIdB64()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmPolicy(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getRevocationInfo()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "isNFCBlockedByHDM()Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "isSwBlockEnabled()Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "removeRevocationInfo()I" \
    "-1"
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'setHdmPolicy(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'setHdmPolicy(Ljava/lang/String;Z)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "setHdmTaCmd(I)I" \
    "-1"
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "setSwBlock(Z)Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'syncRevocationInfo(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "syncSwBlockFromBoot()I" \
    "-1"

SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmVersion()Ljava/lang/String;' \
    '    .locals 1\n\n    const/4 v0, 0x0\n\n    return-object v0'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'generateNonce()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmId(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmIdB64()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmPolicy(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmPolicy(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getRevocationInfo()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getService()Lcom/samsung/android/knox/hdm/IHdmManager;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "isNFCBlockedByHDM()Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "isSwBlockEnabled()Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "removeRevocationInfo()I" \
    "-1"
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'setHdmPolicy(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'setHdmPolicy(Ljava/lang/String;Z)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "setHdmTaCmd(I)I" \
    "-1"
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "setSwBlock(Z)Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'syncRevocationInfo(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" "return" \
    "syncSwBlockFromBoot()I" \
    "-1"

SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    'smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmVersion()Ljava/lang/String;' \
    '    .locals 1\n\n    const/4 v0, 0x0\n\n    return-object v0'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    'smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'generateNonce()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    'smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmId(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    'smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmIdB64()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    'smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmPolicy(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    'smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmPolicy(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    'smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getRevocationInfo()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    'smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getService()Lcom/samsung/android/knox/hdm/IHdmManager;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "isNFCBlockedByHDM()Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "isSwBlockEnabled()Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "removeRevocationInfo()I" \
    "-1"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    'smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'setHdmPolicy(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    'smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'setHdmPolicy(Ljava/lang/String;Z)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "setHdmTaCmd(I)I" \
    "-1"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "setSwBlock(Z)Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    'smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'syncRevocationInfo(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes3/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "syncSwBlockFromBoot()I" \
    "-1"

SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    'smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmVersion()Ljava/lang/String;' \
    '    .locals 1\n\n    const/4 v0, 0x0\n\n    return-object v0'
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    'smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'generateNonce()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    'smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmId(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    'smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmIdB64()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    'smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmPolicy(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    'smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getRevocationInfo()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "isNFCBlockedByHDM()Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "isSwBlockEnabled()Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "removeRevocationInfo()I" \
    "-1"
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    'smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'setHdmPolicy(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "setHdmTaCmd(I)I" \
    "-1"
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "setSwBlock(Z)Z" \
    "false"
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    'smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'syncRevocationInfo(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "smali_classes2/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "syncSwBlockFromBoot()I" \
    "-1"

SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmVersion()Ljava/lang/String;' \
    '    .locals 1\n\n    const/4 v0, 0x0\n\n    return-object v0'
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'generateNonce()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmId(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmIdB64()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getHdmPolicy(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'getRevocationInfo()Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "isNFCBlockedByHDM()Z" \
    "false"
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "isSwBlockEnabled()Z" \
    "false"
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "removeRevocationInfo()I" \
    "-1"
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'setHdmPolicy(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "setHdmTaCmd(I)I" \
    "-1"
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "setSwBlock(Z)Z" \
    "false"
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    'smali/com/samsung/android/knox/hdm/HdmManager.smali' "replacebody" \
    'syncRevocationInfo(Ljava/lang/String;)Ljava/lang/String;' \
    '    .locals 0\n\n    const/4 p0, 0x0\n\n    return-object p0'
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    "smali/com/samsung/android/knox/hdm/HdmManager.smali" \
    "return" \
    "syncSwBlockFromBoot()I" \
    "-1"

# SEC_PRODUCT_FEATURE_KNOX_SUPPORT_BLDP
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    "smali/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isBldpEventSupported()Z' 'false'
SMALI_PATCH "system" "system/framework/knoxsdk.jar" \
    "smali/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isBldpEventSupported()Z' 'false'
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    "smali/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isBldpEventSupported()Z' 'false'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    "smali/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isBldpEventSupported()Z' 'false'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes3/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isBldpEventSupported()Z' 'false'
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "smali_classes2/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isBldpEventSupported()Z' 'false'
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    "smali/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isBldpEventSupported()Z' 'false'
SMALI_PATCH "system_ext" "priv-app/SystemUI/SystemUI.apk" \
    "smali_classes5/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isBldpEventSupported()Z' 'false'

# SEC_PRODUCT_FEATURE_KNOX_SUPPORT_MPOS
# TODO add services.jar patch
SMALI_PATCH "system" "system/app/Traceur/Traceur.apk" \
    "smali/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isMposSupported()Z' 'false'
SMALI_PATCH "system" "system/framework/knoxsdk.jar" \
    "smali/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isMposSupported()Z' 'false'
SMALI_PATCH "system" "system/priv-app/DeviceDiagnostics/DeviceDiagnostics.apk" \
    "smali/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isMposSupported()Z' 'false'
SMALI_PATCH "system" "system/priv-app/ManagedProvisioning/ManagedProvisioning.apk" \
    "smali/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isMposSupported()Z' 'false'
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes3/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isMposSupported()Z' 'false'
SMALI_PATCH "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "smali_classes2/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isMposSupported()Z' 'false'
SMALI_PATCH "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    "smali/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isMposSupported()Z' 'false'
SMALI_PATCH "system_ext" "priv-app/SystemUI/SystemUI.apk" \
    "smali_classes5/com/samsung/android/knox/integrity/EnhancedAttestationPolicy.smali" "return" \
    'isMposSupported()Z' 'false'

# SEC_PRODUCT_FEATURE_SECURITY_SUPPORT_KNOX_MATRIX_AI_PRIVACY
APPLY_PATCH "system" "system/framework/framework.jar" \
    "$MODPATH/kmxai/framework.jar/0001-Nuke-Knox-Matrix-AI-Privacy.patch"
EVAL "rm -f \"$APKTOOL_DIR/system/framework/framework.jar/smali_classes6/com/samsung/android/kmxservice/ai/privacy/PermissionData\\\$1.smali\""
EVAL "rm -f \"$APKTOOL_DIR/system/framework/framework.jar/smali_classes6/com/samsung/android/kmxservice/ai/privacy/PermissionDataController\\\$1.smali\""
EVAL "rm -f \"$APKTOOL_DIR/system/framework/framework.jar/smali_classes6/com/samsung/android/kmxservice/ai/privacy/PermissionDataController\\\$2.smali\""
EVAL "rm -f \"$APKTOOL_DIR/system/framework/framework.jar/smali_classes6/com/samsung/android/kmxservice/ai/privacy/PermissionData.smali\""

# SEC_PRODUCT_FEATURE_FRAMEWORK_SUPPORT_BLOCKCHAIN_SERVICE
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_SUPPORT_BLOCKCHAIN_SERVICE" --delete
SMALI_PATCH "system" "system/framework/framework.jar" \
    "smali_classes6/com/samsung/android/ProductPackagesRune.smali" "replaceall" \
    "SERVICE_SAMSUNG_BLOCKCHAIN:Z = true" \
    "SERVICE_SAMSUNG_BLOCKCHAIN:Z = false"
APPLY_PATCH "system" "system/framework/services.jar" \
    "$MODPATH/blockchain/services.jar/0001-Nuke-BlockchainTZService.patch"

# TODO get rid of the following features
# SEC_PRODUCT_FEATURE_KNOX_SUPPORT_UCS
# SEC_PRODUCT_FEATURE_FRAMEWORK_SUPPORT_MOBILE_PAYMENT

LOG "- Restoring original SourceFile attribute in /system/system/framework/services.jar"
find "$APKTOOL_DIR/system/framework/services.jar" -type f -name "*.smali" -print0 \
    | xargs -0 -I "{}" -P "$(nproc)" sed -i "s/^\.source.*/$SOURCE_FILE_ATTR/g" "{}"

unset SOURCE_FILE_ATTR
