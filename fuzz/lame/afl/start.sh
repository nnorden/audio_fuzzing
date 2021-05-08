#!/bin/bash
afl-fuzz -i /home/afl_lame_corpus/ -o /home/fuzz/lame/afl/out/ lame -f @@