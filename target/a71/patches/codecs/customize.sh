LOG "- Removing legacy OMX.qcom.video.decoder.avc"

for CODECF in "$WORK_DIR"/vendor/etc/media_codecs*.xml; do
    [ -f "$CODECF" ] || continue
    EVAL "sed -i '/<MediaCodec name=\"OMX.qcom.video.decoder.avc\(\.secure\)\?\"/,/<\/MediaCodec>/d' \"$CODECF\""
done

unset CODECF
