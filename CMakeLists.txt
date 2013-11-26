cmake_minimum_required(VERSION 2.8.8)
project (wagic)

SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/CMakeModules)

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(operating_system_linux ON)
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(operating_system_windows ON)
endif()

if(operating_system_psp)
	set(platform_psp ON)
elseif(operating_system_linux)
	option(platform_qt_console  "build qt-console version with testsuit" OFF)
	option(platform_qt_widget   "build qt-widget version"                OFF)
	option(platform_sdl         "build sdl version"                      OFF)
elseif(operating_system_windows)
	option(platform_sdl         "build sdl version"                      OFF)
endif()

if(platform_qt_console OR platform_qt_widget)
    set(platform_qt ON)
endif()

include(FindOrBuild)

add_subdirectory(JGE)
add_subdirectory(projects/mtg)