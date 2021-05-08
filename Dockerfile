FROM ubuntu:20.10

# Tools
RUN apt-get update && apt-get install -y \
    xz-utils \
    zip unzip \
    cmake \
    build-essential \
    iputils-ping \
    curl \
    autoconf \
    automake \
    build-essential \
    cmake \
    git-core \
    libass-dev \
    libfreetype6-dev \
    libgnutls28-dev \
    libsdl2-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    meson \
    ninja-build \
    pkg-config \
    texinfo \
    wget \
    yasm \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && curl -SL https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/clang+llvm-12.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz \
    | tar -xJC . && \
    mv clang+llvm-12.0.0-x86_64-linux-gnu-ubuntu-20.04 clang_12.0.0 && \
    echo 'export PATH=/clang_12.0.0/bin:$PATH' >> ~/.bashrc && \
    echo 'export LD_LIBRARY_PATH=/clang_12.0.0/lib:$LD_LIBRARY_PATH' >> ~/.bashrc && \
    wget https://github.com/google/AFL/archive/refs/heads/master.zip && \
    unzip master.zip -d . && \
    rm -f master.zip && \
    cd AFL-master/ && \
    make install

# Lame libFuzz
RUN curl -SL https://sourceforge.net/projects/lame/files/lame/3.100/lame-3.100.tar.gz/download | \
    tar -xvz -C . && \
    cd /lame-3.100/ && \
    PATH=/clang_12.0.0/bin:$PATH && \
    ./configure CC=clang CFLAGS="-fsanitize=fuzzer-no-link,address" && \
    make && \
    mkdir -p /home/libfuzz_lame_include/ && \
    cp -r /lame-3.100/include /home/libfuzz_lame_include/ && \
    cp -r /lame-3.100/libmp3lame /home/libfuzz_lame_include/ && \
    mkdir -p /home/libfuzz_lame_corpus && \
    cp /lame-3.100/testcase.wav /home/libfuzz_lame_corpus/.

# Lame AFL
RUN PATH=/clang_12.0.0/bin:$PATH && \
    cd AFL-master/llvm_mode/ && \
    make && \
    cd /lame-3.100/ && \
    make clean && \
    ./configure CC=/AFL-master/afl-clang-fast && \
    make && \
    make install && \
    mkdir -p /home/afl_lame_corpus && \
    cp /lame-3.100/testcase.wav /home/afl_lame_corpus/.

# FFmpeg AFL
RUN curl -SL https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 | \
    tar -xjv -C . && \
    cd /ffmpeg/ && \
    PATH=/clang_12.0.0/bin:$PATH && \
    ./configure \
     --cc=/AFL-master/afl-clang-fast \
     --cxx=/AFL-master/afl-clang-fast++ \
     --prefix="/ffmpeg/ffmpeg_build" \
     --pkg-config-flags="--static" \
     --extra-cflags="-I/ffmpeg/ffmpeg_build/include" \
     --extra-ldflags="-L/ffmpeg/ffmpeg_build/lib" \
     --extra-libs="-lpthread -lm" \
     --bindir="/ffmpeg/bin" \
     --enable-gpl \
     --enable-libmp3lame \
     --enable-nonfree && \
   PATH="/ffmpeg/bin:$PATH" make && \
   make install && \
   mkdir -p /home/afl_ffmpeg_corpus && \
   cp /lame-3.100/testcase.wav /home/afl_ffmpeg_corpus/. 