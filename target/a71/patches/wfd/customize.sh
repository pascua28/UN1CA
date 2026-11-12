LOG_STEP_IN "- Adding 32-bit WFD blobs"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/bin/insthk" 0 2000 755 "u:object_r:insthk_exec:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/bin/remotedisplay" 0 2000 755 "u:object_r:remotedisplay_exec:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib/libhdcp2.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib/libremotedisplay_wfd.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib/libremotedisplayservice.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib/libsecuibc.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib/libstagefright_hdcp.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib/wfd_log.so" 0 0 644 "u:object_r:system_lib_file:s0"
DELETE_FROM_WORK_DIR "system" "system/lib64/libhdcp_client_aidl.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libhdcp2.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libremotedisplay_wfd.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libremotedisplayservice.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libsecuibc.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libstagefright_hdcp.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.hdcp.wifidisplay-V2-ndk.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/wfd_log.so"
LOG_STEP_OUT

# One UI 9 libgui added IGraphicBufferProducer methods, so the old vtable
# slot (0x7c) in PlaybackSession::addConsumerUsageBits() now hits
# getFrameTimestamps() instead of getConsumerUsage() (0x84), and the encoder
# surface ends up with garbage usage bits (black screen on the sink).
# Drop the CFI check in front of the call and use its slot to move the
# vtable pointer forward by 8, so [r4, #0x7c] lands on getConsumerUsage().
if [ -f "$WORK_DIR/system/system/lib/libremotedisplay_wfd.so" ]; then
    HEX_PATCH "$WORK_DIR/system/system/lib/libremotedisplay_wfd.so" \
        "224643f0c2e8e26f" \
        "2246083400bfe26f"
fi

patchelf --replace-needed \
    libclang_rt.ubsan_standalone-arm-android.so \
    libwfd_audiotrack_shim.so \
    "$WORK_DIR/system/system/lib/libremotedisplay_wfd.so"
