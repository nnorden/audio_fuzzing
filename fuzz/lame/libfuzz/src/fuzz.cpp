#include <vector>
#include <cstdint>
#include <assert.h>
#include <string.h>

#include "stdio.h"
#include "lame.h"

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Len) {

    int read, write;

    const int PCM_SIZE = 4096;
    const int MP3_SIZE = 4096;

    short int pcm_buffer[PCM_SIZE*2];
    const size_t pcm_buffer_bytes = sizeof(pcm_buffer);

    unsigned char mp3_buffer[MP3_SIZE];

    lame_t lame = lame_init();
    lame_set_in_samplerate(lame, 44100);
    lame_set_VBR(lame, vbr_default);
    lame_init_params(lame);

    while (Len >= pcm_buffer_bytes)
    {
        Len -= pcm_buffer_bytes; 
        memcpy(pcm_buffer, Data, pcm_buffer_bytes);

        if (Len == 0)
        {
            write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
        }
        else
        {
            write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
        }
    };

    lame_close(lame);

    return 0;
}