

#
# Script for testing various build configurations
# $1 - clone command -eg "git clone -b static-install https://github.com/drjsanger/Bio-HTS.git"
# $2 - the test to be run
#
export PERL5LIB_ORIG=$PERL5LIB

#
#test the Build.PL with various options
#
if [ "$2" = "BUILD_SYSTEM_INSTALLED_HTSLIB" ]; then
    echo Installs htslib, then runs Build process
    git clone -b master --depth=1 https://github.com/samtools/htslib.git
    cd htslib
    sudo make install
    cd ..
    $1
    cd Bio-HTS
    perl Build.PL
    ./Build
    export PERL5LIB=$PERL5LIB:$(pwd -P)/lib:$(pwd -P)/blib/arch/auto/Bio/DB/HTS/:$(pwd -P)/blib/arch/auto/Bio/DB/HTS/Faidx    
    cd t
    for f in $(ls *.t) ;
    do
        perl $f
    done
    echo "Completed $2"
    export PERL5LIB=$PERL5LIB_ORIG
    exit 0
fi

if [ "$2" = "BUILD_SYSTEM_INSTALL_ALL" ]; then
    echo Installs htslib, then runs Build process
    git clone -b master --depth=1 https://github.com/samtools/htslib.git
    cd htslib
    sudo make install
    cd ..
    $1
    cd Bio-HTS
    perl Build.PL
    ./Build install
    cd t
    for f in $(ls *.t) ;
    do
        perl $f
    done
    echo "Completed $2"
    exit 0
fi


if [ "$2" = "BUILD_LOCAL_INSTALLED_HTSLIB" ]; then
    echo Installs htslib to a local dir, then runs Build process
    git clone -b master --depth=1 https://github.com/samtools/htslib.git
    cd htslib
    make prefix=~/localsw install
    export HTSLIB_DIR=
    cd ..
    $1
    cd Bio-HTS
    perl Build.PL --prefix=~/localsw
    ./Build
    export PERL5LIB=$PERL5LIB:$(pwd -P)/lib:$(pwd -P)/blib/arch/auto/Bio/DB/HTS/:$(pwd -P)/blib/arch/auto/Bio/DB/HTS/Faidx
    cd t    
    for f in $(ls *.t) ;
    do
        perl $f
    done
    echo "Completed $2"
    exit 0
fi



if [ "$2" = "BUILD_HTSLIB_DIR_ENV" ]; then
    echo Installs htslib, then runs Build process
    git clone -b master --depth=1 https://github.com/samtools/htslib.git
    cd htslib
    make install
    export HTSLIB_DIR="$PWD"
    echo $HTSLIB_DIR
    cd ..
    $1
    cd Bio-HTS
    perl Build.PL
    ./Build
    cd t
    for f in $(ls *.t) ;
    do
        perl $f
    done
    echo "Completed $2"
    exit 0
fi

if [ "$2" = "BUILD_HTSLIB_DIR_FLAG" ]; then
    echo Installs htslib, then runs Build process
    git clone -b master --depth=1 https://github.com/samtools/htslib.git
    cd htslib
    make
    export HTSLIB_DIR_FOR_FLAG="$PWD"
    echo $HTSLIB_DIR_FOR_FLAG
    cd ..
    $1
    cd Bio-HTS
    perl Build.PL --htslib=$HTSLIB_DIR_FOR_FLAG
    ./Build
    cd t
    for f in $(ls *.t) ;
    do
        perl $f
    done
    echo "Completed $2"
    exit 0
fi

if [ "$2" = "BUILD_HTSLIB_DIR_WITH_STATIC_FLAG" ]; then
    echo Installs htslib, then runs Build process
    git clone -b master --depth=1 https://github.com/samtools/htslib.git
    cd htslib
    make
    export HTSLIB_DIR_FOR_FLAG="$PWD"
    echo $HTSLIB_DIR_FOR_FLAG
    cd ..
    $1
    cd Bio-HTS
    perl Build.PL --htslib=$HTSLIB_DIR_FOR_FLAG --static
    ./Build
    rm -rf $HTSLIB_DIR_FOR_FLAG
    cd t
    for f in $(ls *.t) ;
    do
        perl $f
    done
    echo "Completed $2"
    exit 0
fi


#TODO Alien::HTSlib dependency resolver
#TODO pkg-config test


#
#test the INSTALL.pl script with various options
#

if [ "$2" = "INSTALL" ]; then
    echo INSTALL.pl on its own
    $1
    cd Bio-HTS
    export STATIC_HTS=
    perl INSTALL.pl
    cd t
    for f in $(ls *.t) ;
    do
        perl $f
    done
    echo "Completed $2"
    exit 0
fi


if [ "$2" = "INSTALL_STATIC_ENV" ]; then
    echo INSTALL.pl with static option as environment variable
    $1
    cd Bio-HTS
    export STATIC_HTS=1
    perl INSTALL.pl
    cd t
    for f in $(ls *.t) ;
    do
        perl $f
    done
    export STATIC_HTS=
    echo "Completed $2"
    exit 0
fi


if [ "$2" = "INSTALL_STATIC_FLAG" ]; then
    echo INSTALL.pl with static option as flag
    export STATIC_HTS=
    $1
    cd Bio-HTS
    perl INSTALL.pl --static
    cd t
    for f in $(ls *.t) ;
    do
        perl $f
    done
    echo "Completed $2"
    exit 0
fi


echo Build test option $2 not found
