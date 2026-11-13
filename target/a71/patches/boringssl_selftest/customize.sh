# [PATCH] init: refine boringssl self-test handling
#
# Vendor init scripts currently declare boringssl self-tests with
# "reboot_on_failure reboot,boringssl-self-check-failed". On 64‑bit‑only
# Android 16 builds, one of these tests cannot execute on legacy SM8250
# vendors, resulting in an immediate reboot before any diagnostic output.
#
# This change removes the forced reboot directive while retaining the
# self-tests. Each service is logged with its associated binary, including
# type information when present, and warnings are issued if binaries are
# missing. This ensures observability without premature system restart.
#
# Summary of changes:
# - Strip "reboot_on_failure reboot,boringssl-self-check-failed" from init rc files
# - Log service names and binary details for all boringssl self-tests
# - Emit warnings for missing binaries
SYSTEM_EXT_ROOT="$WORK_DIR/system/system/system_ext"
[ -d "$WORK_DIR/system_ext" ] && SYSTEM_EXT_ROOT="$WORK_DIR/system_ext"

RC_DIRS=()
for D in "$WORK_DIR/system/system/etc/init" "$SYSTEM_EXT_ROOT/etc/init" \
    "$WORK_DIR/product/etc/init" "$WORK_DIR/vendor/etc/init" "$WORK_DIR/odm/etc/init"; do
    [ -d "$D" ] && RC_DIRS+=("$D")
done
# grep exits 1 (no match) / 2 (error); neither may abort the build under set -e
RC_FILES="$(grep -rlE "reboot_on_failure[[:space:]]+reboot,boringssl-self-check-failed" "${RC_DIRS[@]}" 2> /dev/null || true)"
[ -n "$RC_FILES" ] || LOG "- No boringssl reboot_on_failure entries found"

while read -r RC; do
    [ "$RC" ] || continue
    while read -r SVC BIN; do
        case "$BIN" in
            /system_ext/*) CHECK="$SYSTEM_EXT_ROOT/${BIN#/system_ext/}" ;;
            /system/*) CHECK="$WORK_DIR/system$BIN" ;;
            /vendor/*|/product/*|/odm/*) CHECK="$WORK_DIR$BIN" ;;
            *) CHECK="" ;;
        esac
        if [ -z "$CHECK" ]; then
            LOG "- $SVC: $BIN (inside APEX, not checked)"
        elif [ -f "$CHECK" ]; then
            LOG "- $SVC: $BIN ($(file -b "$CHECK" | cut -d, -f1-2))"
        else
            LOGW "- $SVC: $BIN is MISSING"
        fi
    done < <(grep -E "^service[[:space:]]+[^[:space:]]*boringssl[^[:space:]]*[[:space:]]" "$RC" | awk '{print $2, $3}' || true)
    LOG "- Dropping boringssl reboot_on_failure from ${RC//$WORK_DIR/}"
    sed -i -E '/reboot_on_failure[[:space:]]+reboot,boringssl-self-check-failed/d' "$RC"
done <<< "$RC_FILES"

unset SYSTEM_EXT_ROOT RC_DIRS D RC_FILES RC SVC BIN CHECK
