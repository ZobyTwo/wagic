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
        )

#the sources we need if we compile a graphical qt version
#TODO: add declarative version since this only works with QWidget right now
set(MTG_qt_graphic_src
        src/qt/filedownloader.cpp
        src/qt/corewrapper.cpp
        include/qt/corewrapper.h #so automoc finds it
        include/qt/filedownloader.h
        src/Qtmain.cpp)

#the sources we need to compile the testsuit
set(MTG_qt_console_src
        src/Qtconsole.cpp
        src/TestSuiteAI.cpp)
        
set(MTG_sdl_src
        src/SDLmain.cpp)

#common settings for all platforms
include_directories(include)
        
#qt builds
if(platform_qt)
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
    set(CMAKE_AUTOMOC TRUE)
    
    add_definitions(-DQT_CONFIG)
    
    if(operating_system_linux)
        add_definitions(-DLINUX)
        add_definitions(-DUSERDIR=".wagic")
    
        FindOrBuildBoost()
        FindOrBuildTinyXML()
        FindOrBuildZipFS()
        FindOrBuildUNZIP()
        
        if(platform_qt_console)
            add_definitions(-DCONSOLE_CONFIG -DTESTSUITE)
            find_package(Qt4 COMPONENTS QtCore QtNetwork REQUIRED)
        elseif(platform_qt_widget)
            add_definitions(-DQT_WIDGET)
            find_package(OpenGL REQUIRED)
            find_package(X11 REQUIRED)
            find_package(Qt4 COMPONENTS QtCore QtGui QtOpenGL QtNetwork REQUIRED)
        endif()
        
        include_directories(../../JGE/include)
        include_directories(../../JGE/include/hge)
        include_directories(include/qt)
        
        include(${QT_USE_FILE})
        include_directories(${ZIPFS_INCLUDE_DIR} ${BOOST_INCLUDE_DIRS} ${UNZIP_INCLUDE_DIR}
                            ${HGE_INCLUDE_DIR} ${TINYXML_INCLUDE_DIR} ${QT_MKSPECS_DIR}/default)
        
        if(platform_qt_console)
            add_executable(wagic ${MTG_generic_src} ${MTG_qt_console_src})
            target_link_libraries(wagic jge-qt-console ${QT_LIBRARIES} ${TINYXML_LIBRARIES} ${Boost_LIBRARIES} ${HGE_LIBRARY})
        elseif(platform_qt_widget)
            add_executable(wagic ${MTG_generic_src} ${MTG_qt_graphic_src})
            target_link_libraries(wagic jge-qt-widget ${QT_LIBRARIES} GL ${TINYXML_LIBRARIES} ${Boost_LIBRARIES} 
                                 ${HGE_LIBRARY} ${X11_LIBRARIES})
        endif()
    else()
        message( FATAL_ERROR "qt-console builds are currently not supported on os != linux")
    endif()
endif()

if( platform_psp)
    add_definitions(-DPSP)
    add_definitions(-D_PSP_FW_VERSION=371)
    add_definitions(-DDEVHOOK -DPSPFW3XX)
    
    if(operating_system_linux)
        #this is a cross-compile. we do not specify -DLINUX
        find_package(PSPSDK COMPONENTS psppower pspmpeg pspaudiocodec pspaudiolib pspaudio pspmp3 pspgum pspgu psprtc pspfpu REQUIRED)
    
        set(CMAKE_CXX_COMPILER ${PSPSDK_CXX_COMPILER})
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -G0")
    
        set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
        set(CMAKE_CXX_LINK_EXECUTABLE "${PSPSDK_CXX_LINKER} <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")
    
        set(EXTRA_INCLUDES ${PSPSDK_PATH}/include)
        
        set(TINYXML_FORCE_BUILD ON)
        set(BOOST_FORCE_BUILD ON)
        
        FindOrBuildTinyXML()
        FindOrBuildZipFS()
        FindOrBuildUNZIP()
        FindOrBuildBoost()
        
        include_directories(${CMAKE_SOURCE_DIR}/JGE/include)
        include_directories(${CMAKE_SOURCE_DIR}/JGE/include/hge)
        include_directories(${PSPSDK_PATH}/include ${TINYXML_INCLUDE_DIR} ${ZIPFS_INCLUDE_DIR} ${UNZIP_INCLUDE_DIR} ${BOOST_INCLUDE_DIRS})

        #search for binary libaries, which are prebuild.
        #TODO: put in FIndPSPLIBS.cmake -script
        #we may even build them from src
        include_directories(${CMAKE_SOURCE_DIR}/thirdparty/psp/include)
        find_library(PSP_HGETOOLS_LIB NAMES hgetools HINTS "${CMAKE_SOURCE_DIR}/thirdparty/psp/lib")
        find_library(PSP_FREETYPE_LIB NAMES freetype HINTS "${CMAKE_SOURCE_DIR}/thirdparty/psp/lib")
        find_library(PSP_PNG_LIB NAMES png HINTS "${CMAKE_SOURCE_DIR}/thirdparty/psp/lib")
        find_library(PSP_JPEG_LIB NAMES jpeg HINTS "${CMAKE_SOURCE_DIR}/thirdparty/psp/lib")
        find_library(PSP_GIF_LIB NAMES gif HINTS "${CMAKE_SOURCE_DIR}/thirdparty/psp/lib")
        find_library(PSP_MIKMOD NAMES mikmod HINTS "${CMAKE_SOURCE_DIR}/thirdparty/psp/lib")
    
        add_executable(wagic ${MTG_generic_src})
    
        target_link_libraries(wagic jge-psp ${HGETOOLS_LIB} ${FREETYPE_LIB} ${PSP_JPEG_LIB} 
                                ${PSP_GIF_LIB} ${PSP_PNG_LIB} z m ${PSP_MIKMOD} ${PSPSDK_LIB} 
                                ${TINYXML_LIBRARIES} stdc++ ${PSPSDK_REQUIRED_LIB})
    
        set(PRXSPECS_FILE "${PSPSDK_PATH}/lib/prxspecs")
        set(LINKFILE_FILE "${PSPSDK_PATH}/lib/linkfile.prx")
    
        get_property(wagic_elf_location TARGET wagic PROPERTY LOCATION)
        get_filename_component(wagic_elf_directory ${wagic_elf_location} PATH)
    
        set_target_properties(wagic PROPERTIES LINK_FLAGS "-specs=${PRXSPECS_FILE} -Wl,-q,-T${LINKFILE_FILE}")
        add_custom_command(TARGET wagic POST_BUILD
            COMMAND ${PSPSDK_MKSFO_COMMAND} ARGS "'Wagic, the Homebrew?!'" "${wagic_elf_directory}/PARAM.SFO"
            COMMAND ${PSPSDK_FIXUP_IMPORTS_COMMAND} ARGS ${wagic_elf_location}
            COMMAND ${PSPSDK_PRXGEN_COMMAND} ARGS ${wagic_elf_location} "${wagic_elf_directory}/wagic.prx"
            COMMAND ${PSPSDK_PACK_PBP_COMMAND} ARGS ${wagic_elf_directory}/EBOOT.PBP ${wagic_elf_directory}/PARAM.SFO ${CMAKE_CURRENT_SOURCE_DIR}/icon.png NULL ${CMAKE_CURRENT_SOURCE_DIR}/pic0.png ${CMAKE_CURRENT_SOURCE_DIR}/pic1.png NULL "${wagic_elf_directory}/wagic.prx" NULL)
    else()
        message(FATAL_ERROR "psp builds are not supported on platforms other than linux")
    endif()
endif()

if(platform_sdl)
    add_definitions(-DSDL_CONFIG)
    
	if(operating_system_linux)
        add_definitions(-DLINUX)
		
		FindOrBuildSDL2()
        FindOrBuildBoost()
        FindOrBuildTinyXML()
        FindOrBuildZipFS()
        FindOrBuildUNZIP()
        
		find_package(OpenGL REQUIRED)
		
        include_directories(../../JGE/include)
        include_directories(../../JGE/include/hge)
        
		include_directories(${SDL2_INCLUDE_DIR} ${ZIPFS_INCLUDE_DIR} ${BOOST_INCLUDE_DIRS} ${UNZIP_INCLUDE_DIR}
                            ${HGE_INCLUDE_DIR} ${TINYXML_INCLUDE_DIR})
		add_executable(wagic ${MTG_generic_src} ${MTG_sdl_src})
		
		#GL GLU glut... what is needed?
		target_link_libraries(wagic jge-sdl ${SDL2_LIBRARY} GL GLU glut ${TINYXML_LIBRARIES} ${Boost_LIBRARIES} ${HGE_LIBRARY})
	elseif(operating_system_windows)
		set(SDL2_INCLUDE_DIR ../../JGE/Dependencies/SDL/include)
		include_directories(../../JGE/Dependencies/include)
		include_directories(../../Boost)
		include_directories(../../JGE/src/tinyxml)
		include_directories(${SDL2_INCLUDE_DIR} ${BOOST_INCLUDE_DIRS})
		add_executable(wagic ${MTG_generic_src} ${MTG_sdl_src})
		include_directories(extra) #dirent.h
		find_library(SDL2_LIBRARY NAMES SDL2 HINTS "../../JGE/Dependencies/SDL2/lib")
		set_property(TARGET wagic PROPERTY COMPILE_DEFINITIONS_DEBUG _CRT_SECURE_NO_WARNINGS)
		target_link_libraries(wagic jge ${SDL2_LIBRARY} GL GLU glut ${X11_LIBRARIES} ${Boost_LIBRARIES} ${GIF_LIBRARIES})
    endif()
endif()

