cmake_minimum_required(VERSION 2.8.8)
project (wagic)

SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/CMakeModules)

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(operating_system_linux ON)
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(operating_system_windows ON)
endif()

if(DEFINED ANDROID_NATIVE_API_LEVEL)
    set(operating_system_android ON)
    set(operating_system_linux OFF)
    
    #to allow finding of pathes/headers/libs within the source tree
    set(CMAKE_FIND_ROOT_PATH ${CMAKE_SOURCE_DIR} ${CMAKE_FIND_ROOT_PATH})
    #a few defintions we need to add to all android code
    add_definitions(-D_STLP_USE_SIMPLE_NODE_ALLOC -D__arm__ -D_REENTRANT -D_GLIBCXX__PTHREADS)
endif()

if(operating_system_psp)
    set(platform_psp ON)
elseif(operating_system_linux)
	option(platform_qt_console  "build qt-console version with testsuit" OFF)
	option(platform_qt_widget   "build qt-widget version"                OFF)
	option(platform_sdl         "build sdl version"                      OFF)
elseif(operating_system_windows)
	option(platform_sdl         "build sdl version"                      ON)
elseif(operating_system_android)
    option(platform_sdl         "build sdl version"                      ON)
    
    message("Build on Android using ${ANDROID_NDK} for toolchain ${ANDROID_TOOLCHAIN_NAME}")
endif()

if(platform_qt_console OR platform_qt_widget)
    set(platform_qt ON)
endif()

include(FindOrBuild)

add_subdirectory(JGE)
add_subdirectory(projects/mtg)