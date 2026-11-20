# Add Polarr libs
ADD_TO_WORK_DIR "a73xqxx" "system" "system/etc/public.libraries-polarr.txt" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libBestComposition.polarr.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libFeature.polarr.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libPolarrSnap.polarr.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libTracking.polarr.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libYuv.polarr.so" 0 0 644 "u:object_r:system_lib_file:s0"

BLOBS_LIST="
system/etc/public.libraries-camera.samsung.txt
system/lib64/libFaceRestoration.camera.samsung.so
system/lib64/libFacialStickerEngine.arcsoft.so
system/lib64/libImageCropper.camera.samsung.so
system/lib64/libPortraitDistortionCorrection.arcsoft.so
system/lib64/libSlowShutter_jni.media.samsung.so
system/lib64/lib_nativeJni.dk.samsung.so
system/lib64/libhigh_dynamic_range.arcsoft.so
system/lib64/libhumantracking_util.camera.samsung.so
system/lib64/libhumantracking.arcsoft.so
system/lib64/liblow_light_hdr.arcsoft.so
system/lib64/libmidas_DNNInterface.camera.samsung.so
system/lib64/libmidas_core.camera.samsung.so
system/lib64/libsamsung_videoengine_9_0.so
system/lib64/libsurfaceutil.camera.samsung.so
system/lib64/libtensorflowlite_inference_api.camera.samsung.so
system/lib64/libtensorflowLite.camera.samsung.so
system/lib64/libtensorflowLite.myfilter.camera.samsung.so
system/lib64/libtensorflowlite_inference_api.myfilter.camera.samsung.so
system/lib64/libMyFilter.camera.samsung.so
system/lib64/libtflite2.myfilters.camera.samsung.so"
for i in $BLOBS_LIST; do
    ADD_TO_WORK_DIR "a73xqxx" "system" "$i" 0 0 644 "u:object_r:system_lib_file:s0"
done
LOG_STEP_OUT

ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib64/libSceneDetector_v1.camera.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"
EVAL "echo \"libSceneDetector_v1.camera.samsung.so\" >> \"$WORK_DIR/system/system/etc/public.libraries-camera.samsung.txt\""

LOG "- Patching /vendor/ueventd.rc"
EVAL "cat \"$MODPATH/ueventd.rc.diff\" >> \"$WORK_DIR/vendor/ueventd.rc\""
