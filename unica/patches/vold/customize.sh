if [ "$TARGET_BOARD_API_LEVEL" -le "30" ]; then
    APPLY_PATCH "system" "system/framework/services.jar" \
        "$MODPATH/services.jar/0001-Do-not-pass-GateKeeperHAT-to-unlockCeStorage.patch"
fi
