#!/bin/sh -ex

#this does not work currenly as travic has no sdl2 installable
#mkdir build_sdl
#cd build_sdl
#cmake -DCMAKE_TOOLCHAIN_FILE=../CMakeModules/android.toolchain.cmake -DANDROID_NATIVE_API_LEVEL=android-13 .. #android-10 is better but i dont have that api installed atm
#make -j8
#cd ..

# we create resource package
#cd projects/mtg/bin/Res
#python createResourceZip.py
# if we let the zip here, Wagic will use it in the testsuite 
# and we'll get 51 failed test cases
#mv core_*.zip ../../../../core.zip
#cd ../../../..

# psp build
mkdir build_psp
cd build_psp
cmake -DCMAKE_TOOLCHAIN_FILE=../CMakeModules/psp.toolchain.cmake ..
make -j8
cd ..

# let's try an qt-console build
mkdir build_qt_console
cd build_qt_console
cmake -Dbackend_qt_console=ON ..
make -j8
cd ..

#and an qt-widget build
mkdir build_qt_widget
cd build_qt_widget
cmake -Dbackend_qt_widget=ON -Dbackend_qt_console=OFF ..
make -j8
cd ..

# and finish by running the testsuite
cd projects/mtg
./../../build_qt_console/bin/wagic
cd ../..
