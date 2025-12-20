#
# Copyright (C) 2025 Salvo Giangreco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Debloat list for Galaxy A71 (a71)
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# Overlays
SYSTEM_DEBLOAT+="
system/app/WifiRROverlayAppLls
"

# mAFPC
SYSTEM_DEBLOAT+="
system/bin/mafpc_write
"

# HDCP
SYSTEM_DEBLOAT+="
system/bin/dhkprov
system/bin/qchdcpkprov
system/etc/init/dhkprov.rc
system/lib64/vendor.samsung.hardware.security.hdcp.keyprovisioning@1.0.so
"

# Gallery AI Semantic Search
SYSTEM_DEBLOAT+="
system/etc/default-permissions/default-permissions-com.samsung.mediasearch.xml
system/etc/mediasearch
system/etc/permissions/privapp-permissions-com.samsung.mediasearch.xml
system/priv-app/MediaSearch
"

# Apps debloat
SYSTEM_DEBLOAT+="
system/etc/default-permissions/default-permissions-com.sec.android.mimage.avatarstickers.xml
system/etc/permissions/privapp-permissions-com.samsung.android.app.earphonetypec.xml
system/etc/permissions/privapp-permissions-com.samsung.android.aremojieditor.xml
system/etc/permissions/privapp-permissions-com.sec.android.mimage.avatarstickers.xml
system/priv-app/AREmojiEditor
system/priv-app/AvatarEmojiSticker
system/priv-app/EarphoneTypeC
system/priv-app/IntelligentDynamicFpsService
system/priv-app/SohService
"
PRODUCT_DEBLOAT+="
priv-app/HotwordEnrollmentOKGoogleEx4HEXAGON
priv-app/HotwordEnrollmentXGoogleEx4HEXAGON
"

# system_ext clean-up
SYSTEM_EXT_DEBLOAT+="
etc/permissions/com.android.hotwordenrollment.common.util.xml
etc/permissions/com.qti.location.sdk.xml
etc/permissions/com.qualcomm.location.xml
etc/permissions/privapp-permissions-com.qualcomm.location.xml
framework/com.android.hotwordenrollment.common.util.jar
framework/com.qti.location.sdk.jar
priv-app/com.qualcomm.location
priv-app/com.qualcomm.qti.services.systemhelper
"
