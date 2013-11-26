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
		message("Going to build it from source")
        Add_Subdirectory_Once(${CMAKE_SOURCE_DIR}/thirdparty/tinyxml ${CMAKE_BINARY_DIR}/thirdparty/tinyxml)
        
        set(TINYXML_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/thirdparty/tinyxml)
        set(TINYXML_LIBRARIES tinyxml)
        add_definitions(-DTIXML_USE_STL) #so that we include headerfiles with the same options
    endif()
endmacro()

macro(FindOrBuildSDL2)
	set(ENV{SDL2DIR} $ENV{SDL2_ROOT})
	find_package(SDL2)
	
    #if(NOT SDL2_FOUND)
		#we 
#		find_path(SDL2_INCLUDE_DIR SDL.h HINTS ${SDL2DIR}/include)
#		find_library(SDL2_LIBRARY NAMES SDL2 HINTS ${SDL2DIR}/lib PATH_SUFFIXES x64 x86)
#		find_library(SDL2_MAIN_LIBRARY NAMES SDL2main HINTS ${SDL2DIR}/lib PATH_SUFFIXES x64 x86)
#		set(SDL2_LIBRARY_DIR ${SDL2DIR}/lib)
		
#		if(SDL2_INCLUDE_DIR AND SDL2_LIBRARY AND SDL2_MAIN_LIBRARY AND SDL2_LIBRARY_DIR)
#			set(SDL2_FOUND ON)
#		endif()
#	endif()
endmacro()

macro(FindOrBuildUNZIP)	
    Add_Subdirectory_Once(${CMAKE_SOURCE_DIR}/thirdparty/unzip ${CMAKE_BINARY_DIR}/thirdparty/unzip)
    
    set(UNZIP_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/thirdparty/unzip)
    set(UNZIP_LIBRARY unzip)
endmacro()

macro(FindOrBuildBoost)
    if(operating_system_psp)
		#the psp build does not need more than a few headers
		set(BOOST_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/thirdparty)    
	elseif(operating_system_windows)
        set(Boost_USE_STATIC_LIBS ON)
        set(Boost_USE_MULTITHREADED ON)
        set(BOOST_ROOT $ENV{BOOST_ROOT})
		
		set(BOOST_LIBRARYDIR ${BOOST_ROOT}/libs)
        set(BOOST_INCLUDEDIR ${BOOST_ROOT})
        
		find_package(Boost COMPONENTS system thread date_time REQUIRED)
    elseif(operating_system_linux)
        find_package(Boost COMPONENTS system thread date_time REQUIRED)
    endif()
endmacro()

macro(FindOrBuildZLIB)
	if(operating_system_windows)
		set(ZLIB_ROOT ${CMAKE_SOURCE_DIR}/thirdparty/binary/win)
		find_package(ZLIB)
	else()
		find_package(ZLIB)
	endif()
endmacro()

macro(FindOrBuildGIF)
	if(operating_system_windows)
		set(ENV{GIF_DIR} ${CMAKE_SOURCE_DIR}/thirdparty/binary/win)
		find_package(GIF)
	else()
		find_package(GIF)
	endif()
endmacro()

macro(FindOrBuildJPEG)
	if(operating_system_windows)
		#findJPEG does currently not provide prefix vars to guide it
		find_path(JPEG_INCLUDE_DIR jpeglib.h HINTS ${CMAKE_SOURCE_DIR}/thirdparty/binary/win/include)
		find_library(JPEG_LIBRARY NAMES libjpeg-static-mt HINTS ${CMAKE_SOURCE_DIR}/thirdparty/binary/win/lib)
		
		if(JPEG_INCLUDE_DIR AND JPEG_LIBRARY)
			set(JPEG_FOUND ON)
			mark_as_advanced(JPEG_INCLUDE_DIR JPEG_LIBRARY)
		else()
			message(FATAL_ERROR "Could not find JPEG on windows")
		endif()
	else()
		find_package(JPEG)
	endif()
endmacro()

macro(FindOrBuildPNG)
	if(operating_system_windows)
		#findPNG does currently not provide prefix vars. so we find
		find_path(PNG_INCLUDE_DIRS png.h HINTS ${CMAKE_SOURCE_DIR}/thirdparty/binary/win/include)
		find_library(PNG_LIBRARIES libpng HINTS ${CMAKE_SOURCE_DIR}/thirdparty/binary/win/lib)
				
		if (PNG_LIBRARIES AND PNG_INCLUDE_DIRS)
			set(PNG_FOUND ON)
			mark_as_advanced(PNG_INCLUDE_DIRS PNG_LIBRARIES)
		else()
			message(FATAL_ERROR "Could not find PNG on windows")
		endif()
	else()
		find_package(PNG)
	endif()
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