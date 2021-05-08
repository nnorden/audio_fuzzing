#!/bin/bash
LD_LIBRARY_PATH=/lame-3.100/libmp3lame/.libs:/usr/lib/x86_64-linux-gnu
afl-fuzz -m 100000000 -i /home/afl_ffmpeg_corpus/ -o /home/fuzz/ffmpeg/afl/out/ /ffmpeg/ffmpeg -i @@ /home/fuzz/ffmpeg/afl/out/encoded.mp3