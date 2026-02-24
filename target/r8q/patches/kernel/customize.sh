KERNEL_REPO="https://github.com/pascua28/kernel_samsung_r8q/releases/latest/download"

LOG "- Downloading Paradigm kernel"
[ -f "$WORK_DIR/kernel/boot.img" ] && rm -f "$WORK_DIR/kernel/boot.img"
[ -f "$WORK_DIR/kernel/dtbo.img" ] && rm -f "$WORK_DIR/kernel/dtbo.img"

DOWNLOAD_FILE "$KERNEL_REPO/boot.img" "$WORK_DIR/kernel/boot.img"
DOWNLOAD_FILE "$KERNEL_REPO/dtbo.img" "$WORK_DIR/kernel/dtbo.img"
