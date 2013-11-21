# - Try to find PSPSDK
# Once done this will define
#  PSPSDK_FOUND - System has PSPSDK
#  PSPSDK_INCLUDE_DIR - The PSPSDK include directories
#  PSPSDK_LIB - The libraries requested with the components field
#  PSPSDK_REQUIRED_LIB - The libriries the PSPSDK needs always
#  PSPSDK_CFLAGS  - The CFLAGS to use 
# 
# does not but will in future versions:
#  PSPSDK_CXX_COMPILER - The Compiler to use with PSPSDK
#  PSPSDK_CXX_LINKER   - The Linker to use with PSPSDK


#get pspsdk paths
find_program(PSP_CONFIG_PROGRAM psp-config)

if(PSP_CONFIG_PROGRAM) 
    execute_process(COMMAND psp-config --pspsdk-path OUTPUT_VARIABLE PSPSDK OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(COMMAND psp-config --psp-prefix  OUTPUT_VARIABLE PSPDIR OUTPUT_STRIP_TRAILING_WHITESPACE)
    
    set(PSPSDK_INCLUDE_DIR "${PSPSDK}/include")
    
    set(PSPSDK_LIB_PATH "${PSPSDK}/lib" "${PSPSDK}/include/libc")
    foreach(_COMPONENT ${PSPSDK_FIND_COMPONENTS})
        find_library(PSPSDK_${_COMPONENT} NAMES ${_COMPONENT} HINTS ${PSPSDK_LIB_PATH})
        if(NOT PSPSDK_${_COMPONENT})
            message("PSPSDK: ${_COMPONENT} not found")
        else()
            set(PSPSDK_LIB ${PSPSDK_LIB} ${PSPSDK_${_COMPONENT}})
        endif()
    endforeach()
    
    #link with the required pspsdk libs
    foreach(_COMPONENT pspdebug pspdisplay pspge pspctrl pspsdk c pspnet pspnet_inet pspnet_apctl pspnet_resolver psputility pspuser)
        find_library(PSPSDK_${_COMPONENT} NAMES ${_COMPONENT} HINTS ${PSPSDK_LIB_PATH})
        if(NOT PSPSDK_${_COMPONENT})
            message("PSPSDK: ${_COMPONENT} not found")
        else()
            set(PSPSDK_REQUIRED_LIB ${PSPSDK_REQUIRED_LIB} ${PSPSDK_${_COMPONENT}})
        endif()
    endforeach()
    
endif()

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set LIBXML2_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(PSPSDK  DEFAULT_MSG
                                  PSPSDK_LIB PSPSDK_REQUIRED_LIB PSPSDK_INCLUDE_DIR)

mark_as_advanced(PSPSDK_INCLUDE_DIR PSPSDK_LIB)
