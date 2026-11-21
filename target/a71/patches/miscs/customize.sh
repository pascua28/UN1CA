# Use TEE SPI in setCosNameProp()
HEX_PATCH "$WORK_DIR/system/system/lib64/libsec_sem.so" \
    "e0031f2a52000014" \
    "2000805252000014"

if [ -d "$WORK_DIR/product/overlay/SoftapOverlay" ] && [ -f "$WORK_DIR/vendor/overlay/SoftapOverlay/SoftapOverlay.apk" ]; then
    DELETE_FROM_WORK_DIR "product" "overlay/SoftapOverlay"
fi

PLAT_SE="$WORK_DIR/system/system/etc/selinux"
if [ -f "$PLAT_SE/plat_sepolicy.cil" ] && grep -q "^(type ion_device)" "$PLAT_SE/plat_sepolicy.cil"; then
    LOG_STEP_IN "- Restoring ION SELinux label and rules"
    if ! grep -q "^/dev/ion[[:space:]]" "$PLAT_SE/plat_file_contexts"; then
        printf '/dev/ion\t\tu:object_r:ion_device:s0\n' >> "$PLAT_SE/plat_file_contexts"
    fi
    if ! grep -q "unica_ion_" "$PLAT_SE/plat_sepolicy.cil"; then
        ION_R=""
        ION_RW=""
        for ION_DOM in hal_gatekeeper gatekeeperd hal_keymaster hal_keymint_server hal_authgraph_server \
                hal_audio hal_fingerprint fingerprintd hal_face hal_neuralnetworks_server \
                hal_codec2_server hal_codec2_client hal_graphics_allocator hal_graphics_composer \
                gpuservice surfaceflinger system_server zygote mediaserver dumpstate rs \
                bufferhubd fwk_bufferhub; do
            grep -qE "^\((type|typeattribute) $ION_DOM\)" "$PLAT_SE/plat_sepolicy.cil" && ION_R+="$ION_DOM "
        done
        for ION_DOM in hal_camera cameraserver hal_drm hal_cas hal_omx_server bootanim adbd shell; do
            grep -qE "^\((type|typeattribute) $ION_DOM\)" "$PLAT_SE/plat_sepolicy.cil" && ION_RW+="$ION_DOM "
        done
        ION_APP=false
        if grep -q "^(typeattribute appdomain)" "$PLAT_SE/plat_sepolicy.cil" && \
                grep -q "^(typeattribute isolated_app_all)" "$PLAT_SE/plat_sepolicy.cil"; then
            ION_APP=true
        fi
        ION_CIL=""
        if [ -n "$ION_R" ]; then
            ION_CIL+="(typeattribute unica_ion_r)"$'\n'
            ION_CIL+="(typeattributeset unica_ion_r ($ION_R))"$'\n'
            ION_CIL+="(allow unica_ion_r ion_device (chr_file (getattr open read ioctl lock map watch watch_reads)))"$'\n'
        fi
        if [ -n "$ION_RW" ]; then
            ION_CIL+="(typeattribute unica_ion_rw)"$'\n'
            ION_CIL+="(typeattributeset unica_ion_rw ($ION_RW))"$'\n'
            ION_CIL+="(allow unica_ion_rw ion_device (chr_file (getattr open read write append ioctl lock map watch watch_reads)))"$'\n'
        fi
        if $ION_APP; then
            ION_CIL+="(typeattribute unica_ion_app)"$'\n'
            ION_CIL+="(typeattributeset unica_ion_app (and (appdomain) (not (isolated_app_all))))"$'\n'
            ION_CIL+="(allow unica_ion_app ion_device (chr_file (getattr open read ioctl lock map watch watch_reads)))"$'\n'
        fi
        printf '%s' "$ION_CIL" >> "$PLAT_SE/plat_sepolicy.cil"
        LOG "- ION read: $ION_R"
        LOG "- ION read/write: $ION_RW"
    fi
    LOG_STEP_OUT
else
    LOGW "ion_device is not declared in plat_sepolicy.cil, skipping ION policy restore"
fi
unset PLAT_SE ION_R ION_RW ION_DOM ION_APP ION_CIL

SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_GAME_SERVER_POLICY_QUERIES" --delete
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_GRAPHICS_CONFIG_GAME_DEFAULT_FRAMERATE" "60"
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_GRAPHICS_CONFIG_GAMEBOOSTER_MORE_HEAT" --delete
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_GAMEBOOSTER_MANUAL_ROUTINE" --delete
