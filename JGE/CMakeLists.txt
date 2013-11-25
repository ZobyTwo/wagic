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
        src/Vector2D.cpp
        src/zipFS/zfsystem.cpp
        src/zipFS/ziphdr.cpp
        src/zipFS/zstream.cpp)

#the sources we need to compile libhge
#NOTE: we do not build an extra lib but compile it directly into jge
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
        
#these sources are needed if we want to cross-compile tinyxml
set(JGE_TinyXML_src
        src/tinyxml/tinystr.cpp
        src/tinyxml/tinyxmlerror.cpp
        src/tinyxml/tinyxmlparser.cpp
        src/tinyxml/tinyxml.cpp)
        
#get common settings for all platforms done:
include_directories(include)
include_directories(src/zipFS)

#get common settings for all qt-builds done:
if(platform_qt)
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
    set(CMAKE_AUTOMOC TRUE)
    
    find_package(Qt4 COMPONENTS QtOpenGL QtCore REQUIRED)
    include(${QT_USE_FILE})
    
    #take the systems libs
	if(operating_system_linux)
		find_package(TinyXML REQUIRED)
	elseif(operating_system_windows)
		set(TINYXML_INCLUDE_DIR src/tinyxml)
	endif()
	
    find_package(PNG REQUIRED)
    find_package(JPEG REQUIRED)
    find_package(ZLIB REQUIRED)
    find_package(GIF REQUIRED)
    find_package(GLUT REQUIRED)
    set(Boost_USE_STATIC_LIBS OFF) 
    set(Boost_USE_MULTITHREADED ON)  
    set(Boost_USE_STATIC_RUNTIME OFF)
    find_package(Boost COMPONENTS system thread REQUIRED)
    
    add_definitions(-DQT_CONFIG)
    #there may be better ways to get those dirs
    #we could even use the header-generator to avoid defines
    #and use xdg if it is available
    add_definitions(-DUSERDIR=".wagic")
    
endif()


if(platform_qt_widget)
    if(operating_system_linux)
        add_library(jge ${JGE_generic_src} ${JGE_graphics_src} ${JGE_linux_src} ${JGE_hge_src})
        add_definitions(-DLINUX)
	elseif(operating_system_windows)
        add_library(jge ${JGE_generic_src} ${JGE_TinyXML_src} ${JGE_graphics_src} ${JGE_linux_src} ${JGE_hge_src})
        add_definitions(-DWIN32)
    endif()

    include_directories(../projects/mtg/qml/qmlapplicationviewer) #Qtmain
    include_directories(../projects/mtg/include)  #precompiled header
    
    include_directories(${Boost_INCLUDE_DIRS} ${TINYXML_INCLUDE_DIR} ${QT_MKSPECS_DIR}/default)
    target_link_libraries(jge ${QT_LIBRARIES} GL GLU glut ${TINYXML_LIBRARIES} ${GIF_LIBRARIES} ${ZLIB_LIBRARIES} ${JPEG_LIBRARIES} ${PNG_LIBRARIES})
endif()

if(platform_qt_console)    
    if(operating_system_linux)
        add_library(jge ${JGE_generic_src} ${JGE_console_src} ${JGE_linux_src} ${JGE_hge_src})
        add_definitions(-DLINUX)
	elseif(operating_system_windows)
        add_library(jge ${JGE_generic_src} ${JGE_TinyXML_src} ${JGE_console_src} ${JGE_linux_src} ${JGE_hge_src})
        add_definitions(-DWIN32)
    endif()
    
    include_directories(../projects/mtg/qml/qmlapplicationviewer) #Qtmain
    include_directories(../projects/mtg/include) #precompiled header
    
    include_directories(${Boost_INCLUDE_DIRS} ${TINYXML_INCLUDE_DIR} ${QT_MKSPECS_DIR}/default)
    target_link_libraries(jge ${QT_LIBRARIES} GL GLU glut ${TINYXML_LIBRARIES} ${GIF_LIBRARIES} ${ZLIB_LIBRARIES} ${JPEG_LIBRARIES} ${PNG_LIBRARIES})
endif()

if(platform_psp)
    #setup PSPSDK:
    find_package(PSPSDK COMPONENTS psppower pspmpeg pspaudiocodec pspaudiolib pspaudio pspmp3 pspgum pspgu psprtc pspfpu REQUIRED)
    set(CMAKE_CXX_COMPILER ${PSPSDK_CXX_COMPILER})
    
    add_library(jge ${JGE_generic_src} ${JGE_psp_src} ${JGE_hge_src} ${JGE_TinyXML_src})
    
    #use the local headers.
    #TODO: Check if that is realy necessary in every case
    include_directories(.)
    include_directories(include/psp)
    include_directories(include/psp/freetype2) 
    include_directories(src/tinyxml)
    include_directories(../Boost)
    include_directories("${PSPSDK_PATH}/include")
    
    #some PSPSDK definitions
    #TODO: move them into PSPSDK_DEFINES_DEBUG and ...RELEASE-vars to FindPSPSDK.cmake
    add_definitions(-DDEVHOOK -DPSPFW3XX)
    add_definitions(-G0 -DPSP -D_PSP_FW_VERSION=371)
    
    #TODO: check if we can link pspsdk right here 
    #target_link_libraries(jge)
endif()

if(platform_sdl)
	add_definitions(-DSDL_CONFIG)

	if(operating_system_linux)
        add_definitions(-DLINUX)
		
		find_package(PNG REQUIRED)
		find_package(JPEG REQUIRED)
		find_package(ZLIB REQUIRED)
		find_package(GIF REQUIRED)
		find_package(GLUT REQUIRED)
		set(Boost_USE_STATIC_LIBS OFF) 
		set(Boost_USE_MULTITHREADED ON)  
		set(Boost_USE_STATIC_RUNTIME OFF)
		find_package(Boost COMPONENTS system thread REQUIRED)
		find_package(SDL2 REQUIRED)
		find_package(TinyXML REQUIRED)
		
		include_directories(../projects/mtg/include) #precompiled header
		include_directories(${BOOST_INCLUDE_DIRS} ${SDL2_INCLUDE_DIR})
		add_library(jge ${JGE_generic_src} ${JGE_hge_src} ${JGE_graphics_src} ${JGE_linux_src})
		target_link_libraries(jge ${SDL2_LIBRARY} GL GLU glut ${GIF_LIBRARIES} ${ZLIB_LIBRARIES} ${JPEG_LIBRARIES} ${PNG_LIBRARIES})
	elseif(operating_system_windows)
        add_definitions(-DWIN32)
		
		include_directories(../projects/mtg/include) #precompiled header
		include_directories(Dependencies/include)
		include_directories(Dependencies/SDL2/include)
		include_directories(../Boost)
		include_directories(src/zipFS)
		include_directories(src/tinyxml)
		include_directories(../projects/mtg/extra) #dirent.h
		add_library(jge ${JGE_generic_src} ${JGE_TinyXML_src} ${JGE_hge_src} ${JGE_graphics_src} ${JGE_linux_src}) 
		set_property(TARGET jge PROPERTY COMPILE_DEFINITIONS_DEBUG _CRT_SECURE_NO_WARNINGS)
        #                                        GL GLU glut ${GIF_LIBRARIES} ${ZLIB_LIBRARIES} ${JPEG_LIBRARIES} ${PNG_LIBRARIES}
		target_link_libraries(jge ${SDL2_LIBRARY})
    endif()
endif()

if(operating_system_windows)
    add_definitions(-DWIN32)
endif()



