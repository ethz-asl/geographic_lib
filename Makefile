all: geographic_lib

TARBALL = build/GeographicLib-1.34.tar.gz
TARBALL_URL = http://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.34.tar.gz
SOURCE_DIR = build/GeographicLib-1.34
UNPACK_CMD = tar xzf
include $(shell rospack find mk)/download_unpack_build.mk

geographic_lib: $(SOURCE_DIR)/unpacked
	mkdir -p data
	cd $(SOURCE_DIR) && mkdir -p build && cd build && cmake -D CMAKE_INSTALL_PREFIX=../../../ -D GEOGRAPHICLIB_DATA=../../../data .. && make install
	./$(SOURCE_DIR)/build/tools/geographiclib-get-geoids -p data best
	./$(SOURCE_DIR)/build/tools/geographiclib-get-gravity -p data all
	./$(SOURCE_DIR)/build/tools/geographiclib-get-magnetic -p data all
clean:
	-rm -rf src $(SOURCE_DIR) geographic_lib
wipe: clean
	-rm -rf build data bin sbin include lib libexec share
