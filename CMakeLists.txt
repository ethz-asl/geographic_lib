cmake_minimum_required(VERSION 2.8.3)
project(geographic_lib)

find_package(catkin_simple REQUIRED)
catkin_simple()

include(ExternalProject)

# The configure step fails at catkin_package() if this directory
# doesn't exist yet. Create it at configure time!
file(MAKE_DIRECTORY ${CATKIN_DEVEL_PREFIX}/include)

ExternalProject_Add(
    GeographicLib
    URL http://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.34.tar.gz
    PATCH_COMMAND mkdir -p ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/data && cd ${CATKIN_DEVEL_PREFIX}/../build/geographic_lib && patch -p0 < ${CMAKE_CURRENT_SOURCE_DIR}/mktemp.patch
    CONFIGURE_COMMAND cd ${CATKIN_DEVEL_PREFIX}/../build/geographic_lib/GeographicLib-prefix/src/GeographicLib && cmake -D CMAKE_INSTALL_PREFIX=${CATKIN_DEVEL_PREFIX} -D GEOGRAPHICLIB_DATA=${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/data .
    BUILD_COMMAND cd ${CATKIN_DEVEL_PREFIX}/../build/geographic_lib/GeographicLib-prefix/src/GeographicLib && make -j1
    INSTALL_COMMAND cd ${CATKIN_DEVEL_PREFIX}/../build/geographic_lib/GeographicLib-prefix/src/GeographicLib && make install && 
        ./tools/geographiclib-get-geoids -p ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/data best &&
        ./tools/geographiclib-get-gravity -p ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/data all &&
        ./tools/geographiclib-get-magnetic -p ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/data all
)

cs_add_library(${PROJECT_NAME} src/dependency_tracker.cpp)
target_link_libraries(${PROJECT_NAME}
  ${CATKIN_DEVEL_PREFIX}/lib/libGeographic${CMAKE_SHARED_LIBRARY_SUFFIX})

cs_install()

cs_export(INCLUDE_DIRS ${CATKIN_DEVEL_PREFIX}/include
          CFG_EXTRAS ceres-extras.cmake)
