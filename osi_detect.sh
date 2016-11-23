#!/bin/bash
#################################################
# osi_detect file
#
Debug=0

if [ $# -ne 0 ]
then
  Debug=1
fi

lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

OS=`lowercase \`uname\``
KERNEL=`uname -r`
MACH=`uname -m`

if [ "{$OS}" == "windowsnt" ]; then
    OS=windows
elif [ "{$OS}" == "darwin" ]; then
    OS=mac
else
    OS=`uname`
    if [ "${OS}" = "SunOS" ] ; then
        OS=Solaris
        ARCH=`uname -p`
        OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
    elif [ "${OS}" = "AIX" ] ; then
        OSSTR="${OS} `oslevel` (`oslevel -r`)"
    elif [ "${OS}" = "Linux" ] ; then
        if [ -f /etc/redhat-release ] ; then
            DistroBasedOn='RedHat'
            DIST=`cat /etc/redhat-release |sed s/\ release.*//`
            PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
            REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
        elif [ -f /etc/slackware-version ]; then
		read -r DIST < /etc/slackware-version
		DistroBasedOn='Slackware'
		PSUEDONAME=$(cat /etc/os-release | sed -n /PRETTY_NAME=/p | sed s/PRETTY_NAME=// | tr -d '"')
		REV=$(cat /etc/os-release | sed -n /VERSION=/p | sed s/[^0-9.]//g)  
        elif [ -f /etc/SuSE-release ] ; then
            DistroBasedOn='SuSe'
            PSUEDONAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
            REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
        elif [ -f /etc/mandrake-release ] ; then
            DistroBasedOn='Mandrake'
            PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
            REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
        elif [ -f /etc/debian_version ] ; then
            DistroBasedOn='Debian'
            DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
            PSUEDONAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
            REV=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
        fi
        if [ -f /etc/UnitedLinux-release ] ; then
            DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
        fi
        OSI_OS="$OS"
        OSI_DIST="$DIST"
        OSI_DistroBasedOn=`lowercase $DistroBasedOn`
        OSI_PSUEDONAME="$PSUEDONAME"
        OSI_REV="$REV"
        OSI_KERNEL="$KERNEL"
        OSI_MACH="$MACH"

        readonly OSI_OS
        readonly OSI_DIST
        readonly OSI_DistroBasedOn
        readonly OSI_PSUEDONAME
        readonly OSI_REV
        readonly OSI_KERNEL
        readonly OSI_MACH
    fi
fi

export OSI_OS
export OSI_DIST
export OSI_DistroBasedOn
export OSI_PSUEDONAME
export OSI_REV
export OSI_KERNEL
export OSI_MACH

if [ $Debug -ne 0 ]
then
  echo "OSI_OS="$OSI_OS
  echo "OSI_DistroBasedOn="$OSI_DistroBasedOn
  echo "OSI_DIST="$OSI_DIST
  echo "OSI_PSUEDONAME="$OSI_PSUEDONAME
  echo "OSI_REV="$OSI_REV
  echo "OSI_KERNEL="$OSI_KERNEL
  echo "OSI_MACH="$OSI_MACH
fi

