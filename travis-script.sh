#!/bin/sh -ex

# let's dump some info to debug a bit
echo PSPDEV = $PSPDEV
echo psp-config = `psp-config --psp-prefix`
echo ls = `ls`
echo pwd = `pwd`

# updating versions with the TRAVIS build numbers
cd projects/mtg/
ant update > error.txt
cd ../..

# we're building a PSP binary here
mkdir build_psp
cd build_psp
cmake -DCMAKE_TOOLCHAIN_FILE=../CMakeModules/psp.toolchain.cmake ..
make -j8
cd ..

# we're building an Android binary here
#android-ndk-r9/ndk-build -C projects/mtg/Android -j8
#$ANDROID list targets
#$ANDROID update project -t 1 -p projects/mtg/Android
#ant debug -f projects/mtg/Android/build.xml

#this mimics the first build step of the android-ndk thingy
mkdir build_android
cd build_android
cmake -DCMAKE_TOOLCHAIN_FILE=../CMakeModules/android.toolchain.cmake -DANDROID_NATIVE_API_LEVEL=android-13 .. 
make -j8
cd ..

# let's also try the sdl binary
mkdir build_sdl
cd build_sdl
cmake -Dbackend_sdl=ON -Dbackend_qt_console=OFF ..
make -j8
cd ..

<<<<<<< HEAD
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
cd projects/mtg/bin/Res
python createResourceZip.py
# if we let the zip here, Wagic will use it in the testsuite 
# and we'll get 51 failed test cases
mv core_*.zip ../../../../core.zip
cd ../../../..

# Now we run the testsuite (Res needs to be in the working directory)
cd projects/mtg
../../wagic
cd ../..

=======
# let's try an Intel linux binary
mkdir build_qt_console
cd build_qt_console
cmake -Dbackend_qt_console=ON ..
make -j8
cd ..

# and finish by running the testsuite
./build_qt_console/bin/wagic
>>>>>>> Add a few patches to include travis. This also shows a few failing test suits
