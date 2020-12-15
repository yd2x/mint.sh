#!/bin/bash

MINT_PATH_AT_INSTALL="../lib"
MINT_LINK_PATH_AT_INSTALL="../bin"
MINT_PATH_FROM_MINT_LINK_PATH="../lib"
MINT_PATH_AT_RUN="mint/lib"
MINT_LINK_PATH_AT_RUN="mint/bin"

ARGUMENTS="$@"

function usage() {
    cat <<EOM
    This script run or install Mint in project directory.
    
    Usage: sh ${0} [options]
    
    Options:
        -h,--help       Display this help
        -i,--install    Install Mint in project directory
EOM
    exit 2;
}

function install() {
    mkdir mint
    cd mint
    git clone https://github.com/yonaskolb/Mint.git
    cd Mint
    MINT_PATH=$MINT_PATH_AT_INSTALL MINT_LINK_PATH=$MINT_LINK_PATH_AT_INSTALL swift run mint install yonaskolb/mint
    cd $MINT_LINK_PATH_AT_INSTALL
    mint_bin_path=$(find ${MINT_PATH_FROM_MINT_LINK_PATH}/packages/github.com_yonaskolb_mint/build/*/mint)
    ln -sf $mint_bin_path mint
    cd ../..
    exit 0;
}

function run() {
    MINT_PATH=$MINT_PATH_AT_RUN MINT_LINK_PATH=$MINT_LINK_PATH_AT_RUN mint/bin/mint $ARGUMENTS
    exit 0;
}

if [ ${#@} -eq 1 ]; then
    if [ "${@#"-h"}" = "" ] || [ "${@#"--help"}" = "" ]; then
        usage
    fi

    if [ "${@#"-i"}" = "" ] || [ "${@#"--install"}" = "" ]; then
        install
    fi
fi

run
