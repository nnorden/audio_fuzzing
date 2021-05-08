## Usage

1. Install docker and docker-compose
    ``` web
    https://docs.docker.com/get-started/
    ```
    
2. Build the container and open an interactive shell:
    ``` sh
    $ cd audio_fuzzing
    $ docker-compose up
    $ docker exec -it $(docker ps -lq) /bin/bash
    ```

3. Running the fuzzing targets:
    ```sh
    # AFL - FFmpeg
    $ cd /home/fuzz/ffmpeg/afl/
    $ chmod u+x start.sh
    $ ./start.sh
    
    # AFL - Lame 3.100
    $ cd /home/fuzz/lame/afl/
    $ chmod u+x start.sh
    $ ./start.sh
    
    # libFuzz - Lame 3.100
    $ cd /home/fuzz/lame/libfuzz/src
    $ make
    $ chmod u+x ../start.sh
    $ ../start.sh
    ```

