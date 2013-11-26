function (Add_Subdirectory_Once SUBDIRECTORY)
  get_filename_component(FULLPATH ${SUBDIRECTORY} REALPATH)

  GET_PROPERTY(_INCLUDED_DIRS GLOBAL PROPERTY ADD_SUBDIRECTORY_ONCE_INCLUDED)
  LIST(FIND _INCLUDED_DIRS "${FULLPATH}" _USED_INDEX)

  if(_USED_INDEX EQUAL -1)
    SET_PROPERTY(GLOBAL PROPERTY ADD_SUBDIRECTORY_ONCE_INCLUDED
"${_INCLUDED_DIRS}" "${FULLPATH}")
    if(${ARGC} EQUAL 1)
      add_subdirectory(${SUBDIRECTORY})
    else(${ARGC} EQUAL 1)
      add_subdirectory(${SUBDIRECTORY} ${ARGV1})
    endif(${ARGC} EQUAL 1)
  endif(_USED_INDEX EQUAL -1)
endfunction (Add_Subdirectory_Once)

macro(FindOrBuildZipFS)
    Add_Subdirectory_Once(${CMAKE_SOURCE_DIR}/thirdparty/zipFS ${CMAKE_BINARY_DIR}/thirdparty/zipFS)
    
    set(ZIPFS_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/thirdparty/zipFS)
    set(ZIPFS_LIBRARY zipFS)
endmacro()

macro(FindOrBuildTinyXML)
    if(NOT TINYXML_FORCE_BUILD)
        find_package(TinyXML)
    endif()
    
    if(NOT TINYXML_FOUND)
        #build it from src        
        Add_Subdirectory_Once(${CMAKE_SOURCE_DIR}/thirdparty/tinyxml ${CMAKE_BINARY_DIR}/thirdparty/tinyxml)
        
        set(TINYXML_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/thirdparty/tinyxml)
        set(TINYXML_LIBRARIES tinyxml)
        add_definitions(-DTIXML_USE_STL) #so that we include headerfiles with the same options
    endif()
endmacro()

macro(FindOrBuildSDL2)
	set(SDL2DIR $ENV{SDL2_ROOT})
	
	find_package(SDL2)
    
    if(NOT SDL2_FOUND)    
		find_path(SDL2_INCLUDE_DIR SDL.h HINTS ${SDL2DIR}/include)
		find_library(SDL2_LIBRARY NAMES SDL2 HINTS ${SDL2DIR}/lib PATH_SUFFIXES x64 x86)
		find_library(SDL2_MAIN_LIBRARY NAMES SDL2main HINTS ${SDL2DIR}/lib PATH_SUFFIXES x64 x86)
		set(SDL2_LIBRARY_DIR ${SDL2DIR}/lib)
		
		set(SDL2_FOUND ON)
	endif()
endmacro()

macro(FindOrBuildUNZIP)	
    Add_Subdirectory_Once(${CMAKE_SOURCE_DIR}/thirdparty/unzip ${CMAKE_BINARY_DIR}/thirdparty/unzip)
    
    set(UNZIP_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/thirdparty/unzip)
    set(UNZIP_LIBRARY unzip)
endmacro()

macro(FindOrBuildBoost)
	set(Boost_USE_STATIC_LIBS ON)
	set(Boost_USE_MULTITHREADED ON)

	#set(Boost_USE_STATIC_LIBS OFF) 
	#set(Boost_USE_MULTITHREADED ON)  
	#set(Boost_USE_STATIC_RUNTIME OFF)
	#set(Boost_DEBUG 1)
    
	set(BOOST_ROOT $ENV{BOOST_ROOT})
	set(BOOST_LIBRARYDIR ${BOOST_ROOT}/libs)
	set(BOOST_INCLUDEDIR ${BOOST_ROOT})
	find_package(Boost COMPONENTS system thread date_time REQUIRED)
endmacro()

macro(FindOrBuildZLIB)	
	find_package(ZLIB)
endmacro()

macro(FindOrBuildGIF)	
	find_package(GIF)
endmacro()

macro(FindOrBuildJPEG)	
	find_package(JPEG)
endmacro()

macro(FindOrBuildPNG)
	find_package(PNG)
endmacro()

macro(FindOrBuildFreetype)
	#if(operating_system_psp)
#		set(ENV{FREETYPE_DIR} ${CMAKE_SOURCE_DIR}/thirdparty/binary/psp)
#	endif()
	find_package(Freetype)
endmacro()

macro(FindOrBuildHgeTools)
	if(platform_psp)
		find_library(PSP_HGETOOLS_LIB NAMES hgetools HINTS "${CMAKE_SOURCE_DIR}/thirdparty/binary/psp/lib")
	else()
		message(SEND_ERROR "where to find hgetools if platform != psp?")
	endif()
endmacro()

macro(FindOrBuildMikMod)
	if(platform_psp)
		find_library(PSP_MIKMOD NAMES mikmod HINTS "${CMAKE_SOURCE_DIR}/thirdparty/binary/psp/lib")
	else()
		message(SEND_ERROR "where to find mikmod if platform != psp?")
	endif()
endmacro()