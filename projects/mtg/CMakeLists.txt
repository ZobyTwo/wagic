set(SOURCES         
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
        
set(wagic_qt_graphic_src
        src/qt/filedownloader.cpp
        src/qt/corewrapper.cpp
        include/qt/corewrapper.h #so automoc finds it
        include/qt/filedownloader.h
        qml/qmlapplicationviewer/qmlapplicationviewer.cpp
        src/Qtmain.cpp)
        
set(wagic_qt_console_src
        src/Qtconsole.cpp)
        
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC TRUE)

add_definitions(-DLINUX -DUSERDIR=".wagic") #dirty hacks

#build the graphical module
if( platform_qt_widget)
    message("build with qt-widget")
    add_definitions(-DQT_WIDGET)
    set(SOURCES "${SOURCES}" ${wagic_qt_graphic_src})
    set(Qt_required_modules QtCore QtGui QtOpenGL QtNetwork QtDeclarative)
endif()

#or build the console module
if( platform_qt_console)
    message("build with qt-console")
    add_definitions(-DCONSOLE_CONFIG -DTESTSUITE)
    set(SOURCES "${SOURCES}" ${wagic_qt_console_src})
    set(Qt_required_modules QtCore QtOpenGL)
endif()

add_executable(wagic ${SOURCES})
include_directories(include)
include_directories(include/qt)

#jge
include_directories(../../JGE/include)
include_directories(../../JGE/src/zipFS)

#3rd party stuff
set(Boost_USE_STATIC_LIBS OFF) 
set(Boost_USE_MULTITHREADED ON)  
set(Boost_USE_STATIC_RUNTIME OFF)
find_package(Boost COMPONENTS system thread)
find_package(TinyXML REQUIRED)
find_package(Qt4 REQUIRED QtCore QtGui QtOpenGL QtNetwork QtDeclarative)
find_package(X11 REQUIRED)
find_package(Qt4 REQUIRED ${Qt_required_modules})
include(${QT_USE_FILE})

include(${QT_USE_FILE})
include_directories(${Boost_INCLUDE_DIRS} ${TINYXML_INCLUDE_DIR} ${QT_MKSPECS_DIR}/default)

target_link_libraries(wagic jge ${QT_LIBRARIES} GL GLU glut ${X11_LIBRARIES} ${TINYXML_LIBRARIES} ${Boost_LIBRARIES} ${GIF_LIBRARIES})