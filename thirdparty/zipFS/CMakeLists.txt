set(SOURCES
    stdafx.cpp
    zfs.cpp
    zfsystem.cpp
    zstream.cpp
    ziphdr.cpp)

include_directories(${CMAKE_SOURCE_DIR}/JGE/include ${EXTRA_INCLUDES})
add_library(zipFS ${SOURCES})