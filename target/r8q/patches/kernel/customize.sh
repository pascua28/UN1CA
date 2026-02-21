LOG "- Replacing kernel"

cp -a "$MODPATH/boot.img" "$WORK_DIR/kernel"
cp -a "$MODPATH/dtbo.img" "$WORK_DIR/kernel"
