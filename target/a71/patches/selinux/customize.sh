VER="$(cat "$WORK_DIR/vendor/etc/selinux/plat_sepolicy_vers.txt")"

if [ -n "$VER" ]; then
    SUFFIX="_${VER//./_}"

    for MAPPING in \
        "$WORK_DIR/system/system/system_ext/etc/selinux/mapping/$VER.cil" \
        "$WORK_DIR/system_ext/etc/selinux/mapping/$VER.cil" \
        "$WORK_DIR/product/etc/selinux/mapping/$VER.cil"; do

        [ -f "$MAPPING" ] || continue

        while IFS= read -r ATTR; do
            if ! grep -q -E "^\(typeattribute $ATTR\)" \
                $(find "$WORK_DIR/system/system/etc/selinux" \
                    "$WORK_DIR/system/system/system_ext/etc/selinux" \
                    "$WORK_DIR/system_ext/etc/selinux" \
                    "$WORK_DIR/product/etc/selinux" \
                    "$WORK_DIR/vendor/etc/selinux" \
                    "$WORK_DIR/odm/etc/selinux" \
                    -name "*.cil" 2>/dev/null); then

                LOG "- Removing $ATTR"

                EVAL "sed -i -E '/\\(expandtypeattribute \\($ATTR\\)|\\(typeattributeset $ATTR /d' \"$MAPPING\""
            fi
        done < <(
            grep -oE "\(expandtypeattribute \([a-z0-9_]+$SUFFIX\)" "$MAPPING" |
                sed -E 's/.*\(([a-z0-9_]+)\)$/\1/' |
                sort -u
        )
    done
fi

unset VER SUFFIX MAPPING
