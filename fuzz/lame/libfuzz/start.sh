#!/bin/bash
cd ./src && make
cd /home/fuzz/lame/libfuzz/out
LD_LIBRARY_PATH=/home/libfuzz_lame_include/libmp3lame/.libs
./../fuzzer /home/libfuzz_lame_corpus