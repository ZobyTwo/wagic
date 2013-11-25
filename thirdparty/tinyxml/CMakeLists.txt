set(SOURCES         
    #tinystr.cpp as we use -DTIXML_USE_STL
    tinyxmlerror.cpp
    tinyxmlparser.cpp
    tinyxml.cpp)
    
add_definitions(-DTIXML_USE_STL)
include_directories(${EXTRA_INCLUDES})

add_library(tinyxml ${SOURCES})