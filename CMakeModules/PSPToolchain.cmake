# this one is important
SET(CMAKE_SYSTEM_NAME "Generic")
#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)

set(operating_system_psp ON)

find_program(PSP_CONFIG_PROGRAM psp-config)

execute_process(COMMAND psp-config --pspsdk-path OUTPUT_VARIABLE PSPSDK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND psp-config --psp-prefix  OUTPUT_VARIABLE PSPSDK_PREFIX OUTPUT_STRIP_TRAILING_WHITESPACE)
	
# specify compiler and linker:
find_program(CMAKE_CXX_COMPILER psp-g++)
find_program(CMAKE_C_COMPILER   psp-gcc)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -G0")

set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
set(CMAKE_CXX_LINK_EXECUTABLE "${PSPSDK_CXX_LINKER} <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")

#how libraries look
SET(CMAKE_FIND_LIBRARY_PREFIXES "lib")
SET(CMAKE_FIND_LIBRARY_SUFFIXES ".so" ".a")

# where is the target environment 
SET(CMAKE_SYSTEM_INCLUDE_PATH 
	${PSPSDK_PATH}/include 
	${PSPSDK_PATH}/../include 
	${CMAKE_SOURCE_DIR}/thirdparty/binary/psp/include 
	${CMAKE_INSTALL_PREFIX}/include)
	
SET(CMAKE_SYSTEM_LIBRARY_PATH 
	${PSPSDK_PATH}/lib 
	${PSPSDK_PATH}/../lib
	${CMAKE_SOURCE_DIR}/thirdparty/binary/psp/lib 
	${CMAKE_INSTALL_PREFIX}/lib)

SET(CMAKE_FIND_ROOT_PATH  
	${PSPSDK_PATH}
	${PSPSDK_PATH}/lib
	${PSPSDK_PATH}/include
	${PSPSDK_PATH}/..
	${PSPSDK_PATH}/../lib
	${PSPSDK_PATH}/../include
	${CMAKE_SOURCE_DIR}/thirdparty/binary/psp
	${CMAKE_SOURCE_DIR}/thirdparty/binary/psp/lib
	${CMAKE_SOURCE_DIR}/thirdparty/binary/psp/include
	)

# search for programs in the build host directories
# for libraries and headers in the target directories and then in the host
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY FIRST)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE FIRST)