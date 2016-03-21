

#
# Script for testing various build configurations
# $1 - clone command -eg "git clone -b static-install https://github.com/drjsanger/Bio-HTS.git"
# $2 - the test to be run
#


#test the Build.PL with various options


#test the INSTALL.pl script with various options


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
    echo "Completed"
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
    echo "Completed"
    exit 0
fi

