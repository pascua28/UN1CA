KERNEL_REPO="https://github.com/UN1CA/kernel_samsung_sm7150/releases/latest/download"

LOG "- Downloading Paradigm kernel"
[ -f "$WORK_DIR/kernel/boot.img" ] && rm -f "$WORK_DIR/kernel/boot.img"
[ -f "$WORK_DIR/kernel/dtbo.img" ] && rm -f "$WORK_DIR/kernel/dtbo.img"

DOWNLOAD_FILE "$KERNEL_REPO/boot.img" "$WORK_DIR/kernel/boot.img"
DOWNLOAD_FILE "$KERNEL_REPO/dtbo.img" "$WORK_DIR/kernel/dtbo.img"
