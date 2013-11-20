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
        src/pc/JSocket.cpp
        src/pc/JSfx.cpp
        src/JSprite.cpp
        src/Vector2D.cpp
        src/hge/hgecolor.cpp
        src/hge/hgedistort.cpp
        src/hge/hgefont.cpp
        src/hge/hgeparticle.cpp
        src/hge/hgerect.cpp
        src/hge/hgevector.cpp
        src/zipFS/zfsystem.cpp
        src/zipFS/ziphdr.cpp
        src/zipFS/zstream.cpp
#if
        src/JMD2Model.cpp
        src/pc/JGfx.cpp
        src/qt/filedownloader.cpp
        src/qt/corewrapper.cpp
        src/Qtmain.cpp)

#turn automoc for filedownloader on
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC TRUE)
add_definitions(-DLINUX -DQT_WIDGET -DUSERDIR=".wagic") #dirty hacks

add_library(jge ${JGE_SOURCES})

include_directories(include)
include_directories(include/qt) #corewrapper & filedownloader
include_directories(src/zipFS) #zipFS
include_directories(../projects/mtg/qml/qmlapplicationviewer) #Qtmain
include_directories(../projects/mtg/include) #precompiled header

#3rd party stuff
find_package(TinyXML REQUIRED)
find_package(Qt4 REQUIRED QtCore QtGui QtOpenGL QtNetwork QtDeclarative)
include(${QT_USE_FILE})
find_package(PNG REQUIRED)
find_package(JPEG REQUIRED)
find_package(ZLIB REQUIRED)
find_package(GIF REQUIRED)

include_directories(${TINYXML_INCLUDE_DIR} ${QT_MKSPECS_DIR}/default)
target_link_libraries(jge ${QT_LIBRARIES} GL GLU glut ${TINYXML_LIBRARIES} ${GIF_LIBRARIES} ${ZLIB_LIBRARIES} ${JPEG_LIBRARIES} ${PNG_LIBRARIES})