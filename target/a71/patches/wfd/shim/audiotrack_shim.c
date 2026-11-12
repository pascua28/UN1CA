// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2026 ssch71
//
// One UI 9 added a trailing `const std::string&` to the AudioTrack
// constructor. The One UI 8.5 libremotedisplay_wfd.so still calls the old
// one, so forward it with an empty string.

#define OLD_C1 "_ZN7android10AudioTrackC1E19audio_stream_type_tj14audio_format_t20audio_channel_mask_tj20audio_output_flags_tRKNS_2wpINS0_19IAudioTrackCallbackEEEi15audio_session_tNS0_13transfer_typeEPK20audio_offload_info_tRKNS_7content22AttributionSourceStateEPK18audio_attributes_tbfi"
#define NEW_C1 OLD_C1 "RKNSt3__112basic_stringIcNSM_11char_traitsIcEENSM_9allocatorIcEEEE"

// An empty libc++ std::string (short mode, size 0) is all zero bytes.
static const unsigned int empty_string[3] = { 0, 0, 0 };

extern void *new_ctor(void *self, int stream, unsigned int sampleRate,
                      int format, unsigned int channelMask,
                      unsigned int frameCount, int flags, const void *callback,
                      int notificationFrames, int sessionId, int transferType,
                      const void *offloadInfo, const void *attributionSource,
                      const void *attributes, _Bool doNotReconnect,
                      float maxRequiredSpeed, int selectedDeviceId,
                      const void *tag) __asm__(NEW_C1);

__attribute__((visibility("default")))
void *old_ctor(void *self, int stream, unsigned int sampleRate, int format,
               unsigned int channelMask, unsigned int frameCount, int flags,
               const void *callback, int notificationFrames, int sessionId,
               int transferType, const void *offloadInfo,
               const void *attributionSource, const void *attributes,
               _Bool doNotReconnect, float maxRequiredSpeed,
               int selectedDeviceId) __asm__(OLD_C1);

void *old_ctor(void *self, int stream, unsigned int sampleRate, int format,
               unsigned int channelMask, unsigned int frameCount, int flags,
               const void *callback, int notificationFrames, int sessionId,
               int transferType, const void *offloadInfo,
               const void *attributionSource, const void *attributes,
               _Bool doNotReconnect, float maxRequiredSpeed,
               int selectedDeviceId)
{
    return new_ctor(self, stream, sampleRate, format, channelMask, frameCount,
                    flags, callback, notificationFrames, sessionId,
                    transferType, offloadInfo, attributionSource, attributes,
                    doNotReconnect, maxRequiredSpeed, selectedDeviceId,
                    empty_string);
}
