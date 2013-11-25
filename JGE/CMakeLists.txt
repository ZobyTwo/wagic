#the sources, jge will need always
set(JGE_generic_src
        src/Encoding.cpp 
        src/JAnimator.cpp
        src/JApp.cpp
        src/JDistortionMesh.cpp
        src/JFileSystem.cpp
        src/JGameObject.cpp
        src/JGE.cpp
        src/JGui.cpp
        src/JLogger.cpp
        src/JLBFont.cpp
        src/JOBJModel.cpp
        src/JParticle.cpp
        src/JParticleEffect.cpp
        src/JParticleEmitter.cpp
        src/JParticleSystem.cpp
        src/JResourceManager.cpp
        src/JSpline.cpp
        src/JNetwork.cpp
        src/JSprite.cpp
        src/Vector2D.cpp)

set(JGE_hge_src
        src/hge/hgecolor.cpp
        src/hge/hgedistort.cpp
        src/hge/hgefont.cpp
        src/hge/hgeparticle.cpp
        src/hge/hgerect.cpp
        src/hge/hgevector.cpp)

#the sources we need to get graphical output desktops
#used by qt-widget build option
set(JGE_graphics_src
        src/JMD2Model.cpp
        src/pc/JGfx.cpp)

#the sources we need to fake graphical output on desktops
#these are used for the console-only testsuit
set(JGE_console_src
        src/JGfx-fake.cpp)

#the sources we need on linux
set(JGE_linux_src
        src/pc/JSocket.cpp
        src/pc/JSfx.cpp)

#the sources we need if we compile for psp
#note: main.cpp contains the main-function.
#the other main functions reside in projects/mtg to reduce cross-library dependencies.
#there may be a way to get all main-functions into the same project
set(JGE_psp_src
        src/JSocket.cpp 
        src/JGfx.cpp
        src/JSfx.cpp
        src/JAudio.cpp
        src/JMP3.cpp
        src/decoder_prx.cpp
        src/main.cpp
        src/vram.cpp)
        
#get common settings for all platforms done:
include_directories(include)
include_directories(include/hge)

if(platform_qt_console OR platform_qt_widget)
    add_definitions(-DQT_CONFIG)
    
    if(operating_system_linux)
        add_definitions(-DLINUX)
        add_definitions(-DUSERDIR=".wagic")
        
        FindOrBuildTinyXML()
        FindOrBuildZipFS()
        FindOrBuildUNZIP()
        FindOrBuildGIF()
        FindOrBuildPNG()
		FindOrBuildJPEG()
        
        find_package(Qt4 COMPONENTS QtOpenGL QtCore REQUIRED)
        include(${QT_USE_FILE})
           
        include_directories(${TINYXML_INCLUDE_DIR} ${ZIPFS_INCLUDE_DIR} ${UNZIP_INCLUDE_DIR} ${QT_MKSPECS_DIR}/default)
        if(platform_qt_console)
            add_library(jge-qt-console ${JGE_generic_src} ${JGE_console_src} ${JGE_linux_src} ${JGE_hge_src})
            target_link_libraries(jge-qt-console  ${QT_LIBRARIES} ${ZIPFS_LIBRARY} ${UNZIP_LIRARY} 
                                  ${GIF_LIBRARIES} ${JPEG_LIBRARIES} ${PNG_LIBRARIES})
        else()
            add_library(jge-qt-widget ${JGE_generic_src} ${JGE_graphics_src} ${JGE_linux_src} ${JGE_hge_src})
            target_link_libraries(jge-qt-widget  ${QT_LIBRARIES} ${ZIPFS_LIBRARY} ${UNZIP_LIRARY} 
                                  ${GIF_LIBRARIES} ${JPEG_LIBRARIES} ${PNG_LIBRARIES})
        endif()
    elseif(operating_system_windows)
        message(FATAL_ERROR "qt builds of jge on windows are currently not supported")
    endif()    
endif()

if(platform_psp)
    add_definitions(-DPSP)
    add_definitions(-D_PSP_FW_VERSION=371)
    add_definitions(-DDEVHOOK -DPSPFW3XX)
    
    if(operating_system_linux)
        #this is a cross-compile. we do not specify -DLINUX
        find_package(PSPSDK COMPONENTS psppower pspmpeg pspaudiocodec pspaudiolib pspaudio pspmp3 pspgum pspgu psprtc pspfpu REQUIRED)
    
        #setup PSPSDK:
        set(CMAKE_CXX_COMPILER ${PSPSDK_CXX_COMPILER})
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -G0")
        
        set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
        set(CMAKE_CXX_LINK_EXECUTABLE "${PSPSDK_CXX_LINKER} <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")
    
        #TODO: move them into PSPSDK_DEFINES_DEBUG and ...RELEASE-vars to FindPSPSDK.cmake
    
        set(EXTRA_INCLUDES ${PSPSDK_PATH}/include)
        set(TINYXML_FORCE_BUILD ON)
        set(BOOST_FORCE_BUILD ON)
        
        FindOrBuildTinyXML()
        FindOrBuildZipFS()
        FindOrBuildUNZIP()
        FindOrBuildBoost()
        
        #TODO: put in FIndPSPLIBS.cmake -script
        include_directories(${CMAKE_SOURCE_DIR}/thirdparty/psp/include)
        include_directories(${PSPSDK_PATH}/include)
        include_directories(${TINYXML_INCLUDE_DIR} ${ZIPFS_INCLUDE_DIR} ${UNZIP_INCLUDE_DIR} ${BOOST_INCLUDE_DIRS})
    
        add_library(jge-psp ${JGE_generic_src} ${JGE_psp_src} ${JGE_hge_src})
        target_link_libraries(jge-psp ${TINYXML_LIBRARIES} ${ZIPFS_LIBRARY} ${UNZIP_LIRARY})
    else()
        message(FATAL_ERROR "psp builds currently not supported on platforms other than linux")
    endif()
endif()

if(platform_sdl)	
	add_definitions(-DSDL_CONFIG)

	if(operating_system_linux)
        add_definitions(-DLINUX)
		
        FindOrBuildTinyXML()
        FindOrBuildZipFS()
        FindOrBuildSDL2()
        FindOrBuildUNZIP()
		FindOrBuildGIF()
		
		find_package(PNG REQUIRED)
		find_package(JPEG REQUIRED)
		
        include_directories(${TINYXML_INCLUDE_DIR} ${ZIPFS_INCLUDE_DIR} ${SDL2_INCLUDE_DIR} ${UNZIP_INCLUDE_DIR})
		add_library(jge-sdl ${JGE_generic_src} ${JGE_graphics_src} ${JGE_linux_src} ${JGE_hge_src})
		target_link_libraries(jge-sdl ${ZIPFS_LIBRARY} ${UNZIP_LIRARY} ${GIF_LIBRARIES} ${JPEG_LIBRARIES} ${PNG_LIBRARIES})
		
	elseif(operating_system_windows)
        add_definitions(-DWIN32)
		
        FindOrBuildZipFS()
		FindOrBuildTinyXML()
		FindOrBuildSDL2()
        FindOrBuildUNZIP()
		FindOrBuildGIF()
		FindOrBuildPNG()
		FindOrBuildJPEG()
		FindOrBuildBoost()
		
		link_directories(${Boost_LIBRARY_DIR} ${SDL2_LIBRARY_DIR})
		include_directories(${TINYXML_INCLUDE_DIR} ${ZIPFS_INCLUDE_DIR} ${SDL2_INCLUDE_DIR} ${UNZIP_INCLUDE_DIR}
							${GIF_INCLUDE_DIR} ${Boost_INCLUDE_DIR})
		add_library(jge-sdl ${JGE_generic_src} ${JGE_graphics_src} ${JGE_linux_src} ${JGE_hge_src})
		set_property(TARGET jge-sdl PROPERTY COMPILE_DEFINITIONS_DEBUG _CRT_SECURE_NO_WARNINGS)
		target_link_libraries(jge-sdl ${ZIPFS_LIBRARY} ${UNZIP_LIRARY} ${GIF_LIBRARIES} ${JPEG_LIBRARIES} ${PNG_LIBRARIES})
    endif()
endif()



