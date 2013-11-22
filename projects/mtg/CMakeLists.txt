#MTGs common sources
set(MTG_generic_src         
        src/AbilityParser.cpp
        src/ActionElement.cpp
        src/ActionLayer.cpp
        src/ActionStack.cpp
        src/AIHints.cpp
        src/AIMomirPlayer.cpp
        src/AIPlayer.cpp
        src/AIPlayerBaka.cpp
        src/AIStats.cpp
        src/AllAbilities.cpp
        src/CardDescriptor.cpp
        src/CardDisplay.cpp
        src/CardGui.cpp
        src/CardPrimitive.cpp
        src/CardSelector.cpp
        src/CardSelectorSingleton.cpp
        src/Closest.cpp
        src/Counters.cpp
        src/Credits.cpp
        src/Damage.cpp
        src/DamagerDamaged.cpp
        src/DeckDataWrapper.cpp
        src/DeckEditorMenu.cpp
        src/DeckManager.cpp
        src/DeckMenu.cpp
        src/DeckMenuItem.cpp
        src/DeckMetaData.cpp
        src/DeckStats.cpp
        src/DuelLayers.cpp
        src/Effects.cpp
        src/ExtraCost.cpp
        src/GameApp.cpp
        src/GameLauncher.cpp
        src/GameObserver.cpp
        src/GameOptions.cpp
        src/GameStateAwards.cpp
        src/GameState.cpp
        src/GameStateDeckViewer.cpp
        src/GameStateDuel.cpp
        src/GameStateMenu.cpp
        src/GameStateOptions.cpp
        src/GameStateShop.cpp
        src/GameStateStory.cpp
        src/GameStateTransitions.cpp
        src/GuiAvatars.cpp
        src/GuiBackground.cpp
        src/GuiCardsController.cpp
        src/GuiCombat.cpp
        src/GuiFrame.cpp
        src/GuiHand.cpp
        src/GuiLayers.cpp
        src/GuiMana.cpp
        src/GuiPhaseBar.cpp
        src/GuiPlay.cpp
        src/GuiStatic.cpp
        src/IconButton.cpp
        src/InteractiveButton.cpp
        src/ManaCost.cpp
        src/ManaCostHybrid.cpp
        src/MenuItem.cpp
        src/ModRules.cpp
        src/MTGAbility.cpp
        src/MTGCard.cpp
        src/MTGCardInstance.cpp
        src/MTGDeck.cpp
        src/MTGDefinitions.cpp
        src/MTGGamePhase.cpp
        src/MTGGameZones.cpp
        src/MTGPack.cpp
        src/MTGRules.cpp
        src/ObjectAnalytics.cpp
        src/OptionItem.cpp
        src/PhaseRing.cpp
        src/Player.cpp
        src/PlayerData.cpp
        src/PlayGuiObject.cpp
        src/PlayGuiObjectController.cpp
        src/PlayRestrictions.cpp
        src/Pos.cpp
        src/PriceList.cpp
        src/ReplacementEffects.cpp
        src/Rules.cpp
        src/SimpleMenu.cpp
        src/SimpleMenuItem.cpp
        src/SimpleButton.cpp
        src/SimplePad.cpp
        src/SimplePopup.cpp
        src/StoryFlow.cpp
        src/Subtypes.cpp
        src/StyleManager.cpp
        src/TargetChooser.cpp
        src/TargetsList.cpp
        src/Tasks.cpp
        src/TextScroller.cpp
        src/ThisDescriptor.cpp
        src/Token.cpp
        src/Translate.cpp
        src/TranslateKeys.cpp
        src/Trash.cpp
        src/utils.cpp
        src/WCachedResource.cpp
        src/WDataSrc.cpp
        src/WEvent.cpp
        src/WFilter.cpp
        src/WFont.cpp
        src/WGui.cpp
        src/WResourceManager.cpp
        src/NetworkPlayer.cpp
        src/TestSuiteAI.cpp
        )

#the sources we need if we compile a graphical qt version
#TODO: add declarative version since this only works with QWidget right now
set(MTG_qt_graphic_src
        src/qt/filedownloader.cpp
        src/qt/corewrapper.cpp
        include/qt/corewrapper.h #so automoc finds it
        include/qt/filedownloader.h
        qml/qmlapplicationviewer/qmlapplicationviewer.cpp
        src/Qtmain.cpp)

#the sources we need to compile the testsuit
set(wagic_qt_console_src
        src/Qtconsole.cpp)

#common settings for all platforms
include_directories(include)
include_directories(../../JGE/include)
include_directories(../../JGE/src/zipFS)
        
#setup common qt stuff
if( platform_qt)
    set(Boost_USE_STATIC_LIBS OFF) 
    set(Boost_USE_MULTITHREADED ON)  
    set(Boost_USE_STATIC_RUNTIME OFF)
    find_package(Boost COMPONENTS system thread)
    find_package(TinyXML REQUIRED)
    find_package(X11 REQUIRED)

    set(CMAKE_INCLUDE_CURRENT_DIR ON)
    set(CMAKE_AUTOMOC TRUE)
    
    #see JGE/CMakeLists.txt
    add_definitions(-DQT_CONFIG)
    add_definitions(-DUSERDIR=".wagic")
endif()

#build the graphical module
if( platform_qt_widget)
    if(operating_system_linux)
        add_definitions(-DLINUX)
    endif()

    find_package(Qt4 COMPONENTS QtCore QtGui QtOpenGL QtNetwork REQUIRED)
    include(${QT_USE_FILE})
    add_definitions(-DQT_WIDGET)

    include_directories(include/qt)
    include_directories(${QT_MKSPECS_DIR}/default)
    add_executable(wagic ${MTG_generic_src}  ${wagic_qt_graphic_src})
    
    target_link_libraries(wagic jge ${QT_LIBRARIES} GL GLU glut ${X11_LIBRARIES} ${TINYXML_LIBRARIES} ${Boost_LIBRARIES} ${GIF_LIBRARIES})
endif()

#or build the console module
if( platform_qt_console)
    if(operating_system_linux)
        add_definitions(-DLINUX)
    endif()

    find_package(Qt4 COMPONENTS QtCore QtNetwork REQUIRED )
    include(${QT_USE_FILE})
    add_definitions(-DCONSOLE_CONFIG -DTESTSUITE)
    
    include_directories(include/qt)
    include_directories(${QT_MKSPECS_DIR}/default)
    add_executable(wagic ${MTG_generic_src} ${wagic_qt_console_src})
    
    target_link_libraries(wagic jge ${QT_LIBRARIES} GL GLU glut ${X11_LIBRARIES} ${TINYXML_LIBRARIES} ${Boost_LIBRARIES} ${GIF_LIBRARIES})
endif()

if( platform_psp)
    #setup PSPSDK
    find_package(PSPSDK COMPONENTS psppower pspmpeg pspaudiocodec pspaudiolib pspaudio pspmp3 pspgum pspgu psprtc pspfpu REQUIRED)
    
    set(CMAKE_CXX_COMPILER ${PSPSDK_CXX_COMPILER})
    
    set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
    #now this is a somewhat dirty hack:
    #CMAKE_CXX_LINK_EXECUTABLE is not exactly meant to be overwritten. but this seems to be the most easiest way 
    #to change the linker command
    set(CMAKE_CXX_LINK_EXECUTABLE "${PSPSDK_CXX_LINKER} <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")
    
    add_executable(wagic ${MTG_generic_src})

    #we might not need some of these...
    include_directories("${PSPSDK_PATH}/include")
    include_directories("../../JGE/include")
    include_directories("../../JGE/src")
    include_directories("../../JGE/src/zipFS")
    include_directories("../../JGE/src/tinyxml")
    include_directories("../../JGE/include/psp")
    include_directories("../../JGE/include/psp/freetype2")
    include_directories("../../projects/mtg/include")
    include_directories("../../Boost")

    #search for binary libaries, which are provided by JGE
    #we may want to add targets to compile them
    find_library(PSP_HGETOOLS_LIB NAMES hgetools HINTS "../../JGE/lib/psp")
    find_library(PSP_FREETYPE_LIB NAMES freetype HINTS "../../JGE/lib/psp")
    find_library(PSP_PNG_LIB NAMES png HINTS "../../JGE/lib/psp")
    find_library(PSP_JPEG_LIB NAMES jpeg HINTS "../../JGE/lib/psp")
    find_library(PSP_GIF_LIB NAMES gif HINTS "../../JGE/lib/psp")
    find_library(PSP_MIKMOD NAMES mikmod HINTS "../../JGE/lib/psp")
    
    #some pspsdk definitions we might want to put into FindPSPSDK
    add_definitions(-DDEVHOOK -DPSPFW3XX)
    add_definitions(-G0 -DPSP -D_PSP_FW_VERSION=371)
    
    #Note: I tried to preserve the same link-order as in the original makefile
    target_link_libraries(wagic jge ${HGETOOLS_LIB} ${FREETYPE_LIB} ${PSP_JPEG_LIB} ${PSP_GIF_LIB} ${PSP_PNG_LIB} z m ${PSP_MIKMOD} ${PSPSDK_LIB} stdc++ ${PSPSDK_REQUIRED_LIB})    
endif()
