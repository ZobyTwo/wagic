#!/bin/sh -ex

# let's also try the sdl binary
#mkdir build_sdl
#cd build_sdl
#cmake -Dbackend_sdl=ON -Dbackend_qt_console=OFF ..
#make -j8
#cd ..

# we're building a Qt version with GUI here
mkdir qt-gui-build
cd qt-gui-build
qmake ../projects/mtg/wagic-qt.pro CONFIG+=release CONFIG+=graphics
make -j 8
cd ..

# let's try an Intel linux binary in debug text-mode-only
qmake projects/mtg/wagic-qt.pro CONFIG+=console CONFIG+=debug DEFINES+=CAPTURE_STDERR
make -j 8

# we create resource package
#cd projects/mtg/bin/Res
#python createResourceZip.py
# if we let the zip here, Wagic will use it in the testsuite 
# and we'll get 51 failed test cases
#mv core_*.zip ../../../../core.zip
#cd ../../../..

# let's try an qt-console build
mkdir build_qt_console
cd build_qt_console
cmake -Dbackend_qt_console=ON ..
make -j8
cd ..

# and finish by running the testsuite
cd projects/mtg
./../../build_qt_console/bin/wagic
cd ../..
