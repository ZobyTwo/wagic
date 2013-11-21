cmake_minimum_required(VERSION 2.8.8)
project (wagic)

SET(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/CMakeModules)

option(platform_qt_console "build qt-console version with testsuit" ON)
option(platform_qt_widget  "build qt-widget version" OFF)

add_subdirectory(JGE)
add_subdirectory(projects/mtg)