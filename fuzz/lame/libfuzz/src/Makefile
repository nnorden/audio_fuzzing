all: fuzz.cpp
	clang++ -std=c++11 -O1 -g -fsanitize=address,fuzzer -I/home/libfuzz_lame_include/include fuzz.cpp -L/home/libfuzz_lame_include/libmp3lame/.libs -lmp3lame -o ../fuzzer
