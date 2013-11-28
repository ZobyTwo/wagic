set(SOURCES         
    #tinystr.cpp as we use -DTIXML_USE_STL
    tinyxmlerror.cpp
    tinyxmlparser.cpp
    tinyxml.cpp)
    
#if(ANDROID)
#    include_directories(${PSPSDK_PATH}/include)
#endif()
    
add_definitions(-DTIXML_USE_STL)

add_library(tinyxml ${SOURCES})