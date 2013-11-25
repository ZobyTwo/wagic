#build unzip

SET(SOURCE
    ioapi.c
    miniunz.c
    unzip.c)

find_package(ZLIB REQUIRED)
include_directories(${ZLIB_INCLUDE_DIR} ${EXTRA_INCLUDES})
    
add_library(unzip ${SOURCE})
target_link_libraries(unzip ${ZLIB_LIBRARY})