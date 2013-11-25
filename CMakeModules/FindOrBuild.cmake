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
    #no way to find it currently
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
    find_package(SDL2)
    
    if(NOT SDL2_FOUND)
        #build SDL2 from source
    endif()
endmacro()

macro(FindOrBuildUNZIP)
    Add_Subdirectory_Once(${CMAKE_SOURCE_DIR}/thirdparty/unzip ${CMAKE_BINARY_DIR}/thirdparty/unzip)
    
    set(UNZIP_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/thirdparty/unzip)
    set(UNZIP_LIBRARY unzip)
endmacro()

macro(FindOrBuildBoost)
    if(NOT BOOST_FORCE_BUILD)
        set(Boost_USE_STATIC_LIBS OFF) 
        set(Boost_USE_MULTITHREADED ON)  
        set(Boost_USE_STATIC_RUNTIME OFF)
        find_package(Boost COMPONENTS system thread REQUIRED)
    else()
        set(BOOST_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/thirdparty/Boost)
    endif()
    #if not found...
endmacro()