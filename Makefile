CC=turbo cc
CFLAGS="-D_WASI_EMULATED_SIGNAL -D_WASI_EMULATED_PROCESS_CLOCKS -DBZ_UNIX"
LDFLAGS="-lwasi-emulated-signal -lwasi-emulated-process-clocks"

all: patch build

.PHONY: patch
patch:
	cd bzip2 && git apply ../patches/001-remove-fchown

.PHONY: build
build:
	mkdir -p bzip2/build
	cd bzip2/build && \
		CC="$(CC)" CFLAGS=${CFLAGS} LDFLAGS=${LDFLAGS} cmake .. -DCMAKE_BUILD_TYPE="Release" -DCMAKE_INSTALL_PREFIX=$(PWD)/build -DENABLE_LIB_ONLY=ON -DENABLE_SHARED_LIB=ON && \
		cmake --build . && \
		cmake --build . --target install

.PHONY: clean
clean:
	rm -rf ./bzip2/build
	rm -rf ./build
