#build unzip

SET(SOURCE
    ioapi.c
    miniunz.c
    unzip.c)

FindOrBuildZLIB()
include_directories(${ZLIB_INCLUDE_DIR} ${EXTRA_INCLUDES} ${ZLIB_INCLUDE_DIR})
    
add_library(unzip ${SOURCE})
target_link_libraries(unzip ${ZLIB_LIBRARY})