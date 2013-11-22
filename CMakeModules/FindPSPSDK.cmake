# - Try to find PSPSDK
# Once done this will define
#  PSPSDK_FOUND - System has PSPSDK
#  PSPSDK_INCLUDE_DIR - The PSPSDK include directories
#  PSPSDK_LIB - The libraries requested with the components field
#  PSPSDK_REQUIRED_LIB - The libriries the PSPSDK needs always
#  PSPSDK_CFLAGS  - The CFLAGS to use
#  PSPSDK_PATH - The output of psp-config --pspsdk-path
#  PSPSDK_PREFIX - The output of psp-config --psp-prefix
#  PSPSDK_CXX_COMPILER - The PSPSDK CXX Compilers path
#  PSPSDK_CXX_LINKER - The PSPSDK CXX Linker command

#find the psp-config progams absolute path
#psp-config needs to be reachable via the system shell (PATH)
find_program(PSP_CONFIG_PROGRAM psp-config)

#TODO: check if something is REQUIRED and throw errors instead of messages
if(PSP_CONFIG_PROGRAM)
    find_program(PSPSDK_CXX_COMPILER psp-g++)
    find_program(PSPSDK_CXX_LINKER psp-gcc)
    
    #ask psp-config for the 
    execute_process(COMMAND psp-config --pspsdk-path OUTPUT_VARIABLE PSPSDK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(COMMAND psp-config --psp-prefix  OUTPUT_VARIABLE PSPSDK_PREFIX OUTPUT_STRIP_TRAILING_WHITESPACE)
    
    set(PSPSDK_INCLUDE_DIR "${PSPSDK_PATH}/include")
    
    #find libs which the user specified via the COMPONENTS parameter
    set(PSPSDK_LIB_PATH "${PSPSDK_PATH}/lib" "${PSPSDK_PATH}/include/libc")
    foreach(_COMPONENT ${PSPSDK_FIND_COMPONENTS})
        find_library(PSPSDK_${_COMPONENT} NAMES ${_COMPONENT} HINTS ${PSPSDK_LIB_PATH})
        if(NOT PSPSDK_${_COMPONENT})
            message("PSPSDK: ${_COMPONENT} not found")
        else()
            set(PSPSDK_LIB ${PSPSDK_LIB} ${PSPSDK_${_COMPONENT}})
        endif()
    endforeach()
    
    #find libs which pspsdk does require to link even if the programs does not need one of them directly
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
                                  PSPSDK_CXX_LINKER PSPSDK_CXX_COMPILER PSPSDK_PATH PSPSDK_PREFIX PSPSDK_LIB PSPSDK_REQUIRED_LIB PSPSDK_INCLUDE_DIR)

mark_as_advanced(PSPSDK_INCLUDE_DIR PSPSDK_LIB)
