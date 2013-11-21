set(JGE_SOURCES
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
        
set(JGE_hge_src
        src/hge/hgecolor.cpp
        src/hge/hgedistort.cpp
        src/hge/hgefont.cpp
        src/hge/hgeparticle.cpp
        src/hge/hgerect.cpp
        src/hge/hgevector.cpp)
        
set(JGE_linux_src
        src/pc/JSocket.cpp
        src/pc/JSfx.cpp)
        
set(JGE_graphics_src
        src/JMD2Model.cpp
        src/pc/JGfx.cpp)
        
set(JGE_console_src
        src/JGfx-fake.cpp)

set(JGE_psp_src
        src/JSocket.cpp 
        src/JGfx.cpp
        src/JSfx.cpp
        src/JAudio.cpp
        src/JMP3.cpp
        src/decoder_prx.cpp
        src/main.cpp
        src/vram.cpp)

if(platform_qt_console)
    set(JGE_SOURCES "${JGE_SOURCES}" ${JGE_console_src}  ${JGE_linux_src} ${JGE_hge_src})
endif()

if(platform_qt_widget)
    set(JGE_SOURCES "${JGE_SOURCES}" ${JGE_graphics_src} ${JGE_linux_src} ${JGE_hge_src})
endif()

#turn automoc for filedownloader and corewrapper on
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC TRUE)

add_definitions(-DLINUX -DUSERDIR=".wagic") #dirty hacks

#project options

add_library(jge ${JGE_SOURCES} ${JGE_console_src})

include_directories(include)
include_directories(include/qt) #corewrapper & filedownloader
include_directories(src/zipFS) #zipFS
include_directories(../projects/mtg/qml/qmlapplicationviewer) #Qtmain
include_directories(../projects/mtg/include) #precompiled header

#3rd party stuff
find_package(TinyXML REQUIRED)
find_package(PNG REQUIRED)
find_package(JPEG REQUIRED)
find_package(ZLIB REQUIRED)
find_package(GIF REQUIRED)
find_package(GLUT REQUIRED)

include_directories(${TINYXML_INCLUDE_DIR} ${QT_MKSPECS_DIR}/default)
target_link_libraries(jge GL GLU glut ${TINYXML_LIBRARIES} ${GIF_LIBRARIES} ${ZLIB_LIBRARIES} ${JPEG_LIBRARIES} ${PNG_LIBRARIES})