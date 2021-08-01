#!/bin/bash
#
# COPYTIGHT (C) 2021 DIMAS YUDHA PRATAMA <dimas.yudha@next-ti.co.id>
#
# ONLY SUPPORT FOR ARM64 DEVICE, ANDROID 11 VERSION, & UBUNTU DISTRO 20.04 LTS ABOVE
# YOU CAN TRY ON OTHERS EXCEPT THAT I MENTIONED ABOVE
# BUT IF EVERYTHING GOES WRONG, REMEMBER THAT I ALREADY WARNED YOU EARLIER

#TODO: 1. SCRIPTS MUST BE PLACED ON HOME DIR INSTEAD. PLUS NEED TO CD TAGET DIR IF SOME COMMANDS NEED TO DO THAT
#TODO: 2. CASE-ESAC MUST BE INCLUDED

#rom_dir=$(pwd)
#krnl_dir=$(pwd)
#ur_rec_dir=$(pwd)
#rom_out=$(pwd/out/target/product/$dvc_nm) #TODO: GREP THE LATEST FILE THAT IS GONNA BE UPLOADED
#krnl_out=$(pwd/out/arch/arm64/boot)
# rec_dir= $()
#log_dir=$()
#rom_nm=$(cut -d'/' -f2 $dvc_nm/AndroidProducts.mk)
#dvc_nm=$(ls $rom_dir/device/xiaomi | awk 'NR==2{print $1}')

pkgs()
{
    if [ $1 -eq 1 ];
        then
            # PPA

            # UPDATES
            sudo apt-get update && sudo apt-get upgrade -y

            # PACKAGES
            sudo apt-get install git zip -y
            clear
    elif [ $1 -eq 2 ];
        then
            # PPA
            sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
            clear

            # UPDATES
            sudo apt-get update && sudo apt-get upgrade -y
            clear

            # PACKAGES
            sudo apt-get install flex bison ncurses-dev texinfo gcc\
            gperf patch libtool automake g++\
            libncurses5-dev gawk subversion expat libexpat1-dev\
            python-all-dev binutils-dev bc libcap-dev autoconf \
            libgmp-dev build-essential pkg-config libmpc-dev libmpfr-dev\
            autopoint gettext txt2man liblzma-dev libssl-dev\
            libz-dev mercurial wget tar gcc-10 \
            g++-10 -y
            clear
    elif [ $1 -eq 3 ];
        then
            clear
    fi
}

envs()
{
    if [ $1 -eq 1 ];
        then
            echo "export USE_CCACHE=1" >> ~/.bashrc
            eval "$(cat ~/.bashrc | tail -n +10)"
            clear
    elif [ $1 -eq 2 ];
        then
            clear
    elif [ $1 -eq 3 ];
        then
            clear
    fi

    git config --global user.name "#USERNAME"
    git config --global user.email "#EMAIL"
}

syncs()
{
    sudo rm -rf .repo
    repo init -u #LINK GIT.git -b #BRANCH
    repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
}

cmpls()
{
    if [ $1 -eq 1 ];
        then
            export USE_CCACHE=1
            export CCACHE_EXEC=$(command -v ccache)
            .build/envsetup.sh
            lunch #ROMNAME_#DEVICENAME-#BUILDTYPE
            #MAKE/MKA?BACON/ROMSPECIFIC? -j$(nproc --all)
    elif [ $1 -eq 2 ];
        then
            if [ "$krnlsaa" == "1" ];
                then clear ##
            elif [ "$krnlsaa" == "2" ];
                then
                    if [ ! -d "arter32" ];
                        then
                            git clone https://github.com/arter97/arm32-gcc.git -b master arter32 --depth=1
                            clear
                        else
                            clear
                    fi

                    if [ ! -d "arter64" ];
                        then
                            git clone https://github.com/arter97/arm64-gcc.git -b master arter64 --depth=1
                            clear
                        else
                            clear
                    fi

                    #TODO: DEFINE & EXPORT

            elif [ "$krnlsaa" == "3" ];
                then
                    clear
            elif [ "$krnlsab" == "1" ];
                then
                    if [ ! -f "googleclang" ];
                        then
                            wget -t 5 -O googleclangs.tar.gz https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/master/clang-r416183b.tar.gz
                            sudo rm -rf googleclangs.tar.gz
                            tar #FLAGS googleclangs.tar.gz
                            mv googleclangs googleclang
                            clear
                        else
                            clear
                    fi

                    # MODIFY THE EXISTING KERNEL NAME
                    read -p "INSERT YOUR DESIRE KERNEL NAME:" cmplsa
                    clear
                    sed -i -e '/CONFIG_LOCALVERSION=/,/^\s*$/{d}' #YOURKERNELPATH/arch/arm64/configs/#KERNELDEVICE_defconfig #TODO: IT'LL DELETE ALL OR ONLY THE FIRST LINE?
                    sed -i -e 's/CONFIG_LOCALVERSION="-$cmplsa"/g' #YOURKERNELPATH/arch/arm64/configs/#KERNELDEVICE_defconfig


                    make O=out ARCH=arm64 $dvc_nm_defconfig
                    # TODO: WIP BELOW
                    PATH="$HOME/#GCC64/bin:$HOME/#GCC32/bin:${PATH}" \
                    make -j$(nproc --all) O=out \
                    ARCH=arm64 \
                    CC=clang \
                    CLANG_TRIPLE=aarch64-linux-gnu- \
                    # CROSS_COMPILE=aarch64-linux-android- \ #TODO: DEPENDS ON GCC
                    # CROSS_COMPILE_ARM32=arm-linux-androideabi- #TODO: DEPENDS ON GCC
            elif [ "$krnlsab" == "2" ];
                then
                    if [ ! -f "protonclang" ];
                        then
                            git clone https://github.com/kdrag0n/proton-clang.git -b master protonclang --depth=1
                            clear
                        else
                            clear
                    fi

                    make O=out ARCH=arm64 $dvc_nm_defconfig
                    export PATH="$HOME/protonclang/bin:$PATH"
                    make -j$(nproc --all) O=out \
                    ARCH=arm64 \
                    CC=clang \
                    CROSS_COMPILE=aarch64-linux-gnu- \

                    # CONDITION FOR KERNEL 4.19
                    if [];
                        then CROSS_COMPILE_COMPAT=arm-linux-gnueabi-
                        else CROSS_COMPILE_ARM32=arm-linux-gnueabi-
                    fi

                    if []; #TODO: IF COMPILE AIN'T SUCCESS
                        then
                            clnups 2
                            krnls 2
                        else
                            clear
                            krnls 3
                    fi
            fi
    elif [ $1 -eq 3 ];
        then
            clear
    fi
}

zips()
{
    if [ ! -d "anykernel" ];
        then
            git clone https://github.com/osm0sis/AnyKernel3.git -b master anykernel
            clear
        else
            clear
    fi

    mv out/arch/arm64/boot/Image.gz-dtb ~/anykernel #TODO: FIX THIS PATH ACCORDING WHERE THE USER STORES THE DATA
    cd anykernel
    zip -r9 "#KERNELNAMES".zip *
}

uplds()
{
    echo "============================================"
    echo "| NO  |   SCRIPTS BY DIMASYUDHA   | STATUS |"
    echo "============================================"
    echo "| 1.  | GOOGLE DRIVE              | READY  |"
    echo "| 2.  | SOURCEFORGE               | READY  |"
    echo "| 3.  | MEGA                      | READY  |"
    echo "| 4.  | BACK TO MAIN MENU         | READY  |"
    echo "--------------------------------------------"
    echo "********** INSERT THE NUMBER ONLY **********"
    echo "--------------------------------------------"
    read -p "INSERT YOUR ANSWER ~> " upldsa
    clear

    if [ $1 -eq 1 ];
        then
            cd out/target/product/#DEVICENAME

            if [ "$upldsa" == "1" ];
                then
                    if [ ! -d "gdrive" ];
                        then
                            wget https://raw.githubusercontent.com/usmanmughalji/gdriveupload/master/gdrive
                            chmod +x gdrive
                            sudo install gdrive /usr/local/bin/gdrive
                            gdrive list
                        else
                            clear
                    fi

                    gdrive upload ./$rom_out
            elif [ "$upldsa" == "2" ];
                then
                    read -p " INSERT YOUR SOURCEFORGE USERNAME HERE: " upldsaa
                    echo "put $rom_out" | sftp $updsaa@frs.sourceforge.net
            elif [ "$upldsa" "3" ];
                then
                    if [ ! -d "megacloud" ];
                        then
                            sudo apt-get install ruby -y
                            sudo gem install rmega -y
                            read -p "INSERT YOUR MEGA EMAIL HERE:" upldsab
                            rmega-up $rom_out -u $upldsab
                    fi
            elif [ "$upldsa" == "4" ];
                then
                    clear
                    menus
            fi

    elif [ $1 -eq 2 ];
        then
            cd ~/anykernel #TODO: FIX THIS PATH ACCORDING WHERE THE USER STORES THE DATA

            if [ "$upldsa" == "1" ];
                then
                    if [ ! -d "gdrive" ];
                        then
                            wget https://raw.githubusercontent.com/usmanmughalji/gdriveupload/master/gdrive
                            chmod +x gdrive
                            sudo install gdrive /usr/local/bin/gdrive
                            gdrive list
                        else
                            clear
                    fi

                    gdrive upload ./$krnl_out
            elif [ "$upldsa" == "2" ];
                then
                    read -p " INSERT YOUR SOURCEFORGE USERNAME HERE: " upldsab
                    echo "put ($krnl_out)" | sftp $updsab@frs.sourceforge.net
            elif [ "$upldsa" "3" ];
                then
                    if [ ! -d "megacloud" ];
                        then
                            # PACKAGES
                            sudo apt-get install autoconf libtool g++ libcrypto++-dev libz-dev \
                            libsqlite3-dev libssl-dev libcurl4-gnutls-dev libreadline-dev libpcre++-dev \
                            libsodium-dev libc-ares-dev libfreeimage-dev libavcodec-dev libavutil-dev \
                            libavformat-dev libswscale-dev libmediainfo-dev libzen-dev libuv1-dev -y

                            # SCRIPTS
                            git clone https://github.com/meganz/MEGAcmd.git -b master megacloud
                            cd megacloud
                            git submodule update --init --recursive

                            # COMPILE
                            sudo sh autogen.sh
                            ./configure
                            make
                            sudo make install
                    fi
            fi

    elif [ $1 -eq 3 ];
        then
            clear
    fi
}

clnups()
{
    if [ $1 -eq 1 ];
        then
            sudo rm -rf out
            make clobber
            make clean
            clear
    elif [ $1 -eq 2 ];
        then
            sudo rm -rf out
            clear
    elif [ $1 -eq 3 ];
        then
            clear
    fi
}

menus()
{
    echo "============================================"
    echo "| NO  |   SCRIPTS BY DIMASYUDHA   | STATUS |"
    echo "============================================"
    echo "| 1.  | COOKING A ROM             | WIP    |"
    echo "| 2.  | COOKING A KERNEL          | WIP    |"
    echo "| 3.  | COOKING A RECOVERY        | WIP    |"
    echo "| 4.  | UPDATE THE SCRIPTS        | READY  |"
    echo "| 5.  | QUIT                      | READY  |"
    echo "--------------------------------------------"
    echo "********** INSERT THE NUMBER ONLY **********"
    echo "--------------------------------------------"
    read -p "INSERT YOUR ANSWER ~> " menusa
    clear

    if [ "$menusa" == "1" ];
        then
            roms
            clear
    elif [ "$menusa" == "2" ];
        then
            krnls 1
            krnls 2
            clear
    elif [ "$menusa" == "3" ];
        then
            recs
            clear
            menus
    elif [ "$menusa" == "4" ];
        then
            git fetch https://github.com/dimasyudhaproject/android-scripts.git master && git pull origin master
            clear
    elif [ "$menusa" == "5" ];
        then
            clear
            quits
            exit 1
    fi
}

roms()
{
    echo "============================================"
    echo "| NO  |   SCRIPTS BY DIMASYUDHA   | STATUS |"
    echo "============================================"
    echo "| 1.  | INSTALL NEEDED PACKAGES   | WIP    |"
    echo "| 2.  | SET UP ENVIRONMENT        | WIP    |"
    echo "| 3.  | SYNC TO LATEST ROM SOURCE | WIP    |"
    echo "| 4.  | LET'S COOKING             | WIP    |"
    echo "| 5.  | UPLOAD THE OUTPUT         | WIP    |"
    echo "| 6.  | CLEAN UP THE OUTPUT       | READY  |"
    echo "| 7.  | BACK TO MAIN MENU         | READY  |"
    echo "--------------------------------------------"
    echo "********** INSERT THE NUMBER ONLY **********"
    echo "--------------------------------------------"
    read -p " INSERT YOUR ANSWER ~> " romsa

    if [ "$romsa" == "1" ];
        then
            pkgs 1
            clear
            roms
    elif [ "$romsa" == "2" ];
        then
            envs 1
            clear
            roms
    elif [ "$romsa" == "3" ];
        then
            syncs
            clear
            roms
    elif [ "$romsa" == "4" ];
        then
            cmpls 1
            clear
            roms
    elif [ "$romsa" == "5" ];
        then
            uplds 1
            clear
            roms
    elif [ "$romsa" == "6" ];
        then
            clnups 1
            clear
            roms
    elif [ "$romsa" == "7" ];
        then
            clear
            menus
    fi


}

krnls()
{
    if [ $1 -eq 1 ];
        then
            echo "============================================"
            echo "| NO  |   SCRIPTS BY DIMASYUDHA   | STATUS |"
            echo "============================================"
            echo "| 1.  | INSTALL NEEDED PACKAGES   | WIP    |"
            echo "| 2.  | SET UP ENVIRONMENT        | WIP    |"
            echo "| 3.  | LET'S COOKING             | WIP    |"
            echo "| 4.  | MAKE A FLASHABLE ZIP      | WIP    |"
            echo "| 5.  | UPLOAD THE OUTPUT         | WIP    |"
            echo "| 6.  | CLEAN UP THE OUTPUT       | READY  |"
            echo "| 7.  | BACK TO MAIN MENU         | READY  |"
            echo "--------------------------------------------"
            echo "********** INSERT THE NUMBER ONLY **********"
            echo "--------------------------------------------"
            read -p " INSERT YOUR ANSWER ~> " krnlsb
            clear

            if [ "$krnlsb" == "1" ];
                then
                    pkgs 2
                    clear
                    krnls 1
            elif [ "$krnlsb" == "2" ];
                then
                    envs 2
                    clear
                    krnls 1
            elif [ "$krnlsb" == "3" ];
                then
                    krnls 2
                    clear
                    krnls 1
            elif [ "$krnlsb" == "4" ];
                then
                    zips
                    clear
                    krnls 1
            elif [ "$krnlsb" == "5" ];
                then
                    uplds 2
                    clear
                    krnls 1
            elif [ "$krnlsb" == "6" ];
                then
                    clnups 2
                    clear
                    krnls 1
            elif [ "$krnlsb" == "7" ];
                then
                    clear
                    menus
            fi
    elif [ $1 -eq 2 ];
        then
            echo "============================================"
            echo "| NO  |   SCRIPTS BY DIMASYUDHA   | STATUS |"
            echo "============================================"
            echo "| 1.  | GCC TOOLCHAIN             | WIP    |"
            echo "| 2.  | CLANG TOOLCHAIN           | WIP    |"
            echo "| 3.  | BACK TO MAIN MENU         | READY  |"
            echo "--------------------------------------------"
            echo "********** INSERT THE NUMBER ONLY **********"
            echo "--------------------------------------------"
            read -p " INSERT YOUR ANSWER ~> " krnlsa
            clear

            if [ "$krnlsa" == "1" ];
                then
                    echo "============================================"
                    echo "| NO  |   SCRIPTS BY DIMASYUDHA   | STATUS |"
                    echo "============================================"
                    echo "| 1.  | GOOGLE GCC                | WIP    |"
                    echo "| 2.  | ARTER GCC                 | WIP    |"
                    echo "| 3.  | LINARO GCC                | WIP    |"
                    echo "| 4.  | EVA GCC                   | WIP    |"
                    echo "| 5.  | BACK TO MAIN MENU         | READY  |"
                    echo "--------------------------------------------"
                    echo "********** INSERT THE NUMBER ONLY **********"
                    echo "--------------------------------------------"
                    read -p " INSERT YOUR ANSWER ~> " krnlsaa
                    clear
                    cmpls 2

                    if [ "$krnlsaa" == "5" ];
                        then
                            clear
                            krnls 2
                    fi
            elif [ "$krnlsa" == "2" ];
                then
                    echo "============================================"
                    echo "| NO  |   SCRIPTS BY DIMASYUDHA   | STATUS |"
                    echo "============================================"
                    echo "| 1.  | GOOGLE CLANG              | WIP    |"
                    echo "| 2.  | PROTON CLANG              | WIP    |"
                    echo "| 3.  | BACK TO MAIN MENU         | READY  |"
                    echo "--------------------------------------------"
                    echo "********** INSERT THE NUMBER ONLY **********"
                    echo "--------------------------------------------"
                    read -p " INSERT YOUR ANSWER ~> " krnlsab
                    clear
                    cmpls 2

                    if [ "$krnlsab" == "3" ];
                        then
                            clear
                            krnls 2
                    fi
            elif [ "$krnlsa" == "3" ];
                then
                    clear
                    menus
            fi
    elif [ $1 -eq 3 ];
        then
            echo "========================================================="
            echo " CONGRATULATION, YOU HAVE SUCCESSFULLY COOKED THE KERNEL "
            echo "========================================================="
            sleep 5
            clear
            krnls 1
    fi
}

recs()
{
    echo "======================================================================"
    echo " THIS FEATURE IS UNDER MAINTAINANCE WHICH WILL BE AVAILABLE VERY SOON "
    echo "======================================================================"
    sleep 3
}

wrongs()
{
    echo "=================================================================="
    echo " YOU INSERT THE WRONG ANSWER! PLEASE READ THE QUESTION CAREFULLY! "
    echo "=================================================================="
    sleep 3

}

quits()
{
    echo "================================"
    echo " THANK YOU FOR USING MY SCRIPTS "
    echo "================================"
    sleep 3
}

# RUN THE SCRIPTS
menus