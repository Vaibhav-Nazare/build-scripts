#!/bin/bash -e
# -----------------------------------------------------------------------------
#
# Package          : python-semver
# Version          : 3.0.2
# Source repo      : https://github.com/python-semver/python-semver.git
# Tested on        : UBI:9.3
# Language         : Python
# Travis-Check     : True
# Script License   : Apache License, Version 2 or later
# Maintainer       : Vipul Ajmera <Vipul.Ajmera@ibm.com>
#
# Disclaimer       : This script has been tested in root mode on given
# ==========         platform using the mentioned version of the package.
#                    It may not work as expected with newer versions of the
#                    package and/or distribution. In such case, please
#                    contact "Maintainer" of this script.
#
# ---------------------------------------------------------------------------

#variables
PACKAGE_NAME=python-semver
PACKAGE_VERSION=${1:-3.0.2}
PACKAGE_URL=https://github.com/python-semver/python-semver.git

#install dependencies
yum install -y yum-utils git gcc gcc-c++ make python3.11 python3.11-pip python3.11-devel

python3.11 -m venv semver-venv
source semver-venv/bin/activate

# clone repository
git clone $PACKAGE_URL 
cd $PACKAGE_NAME
git checkout $PACKAGE_VERSION

python3.11 -m pip install --upgrade pip
python3.11 -m pip install tox tox-gh-actions
python3.11 -m pip install build
python3.11 -m pip install -r docs/requirements.txt

#install
if ! pyproject-build; then
    echo "------------------$PACKAGE_NAME:Install_fails-------------------------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub | Fail |  Install_Fails"
    exit 1
fi

if ! tox -e py311; then
    echo "------------------$PACKAGE_NAME:Install_success_but_test_fails---------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub | Fail |  Install_success_but_test_Fails"
    exit 2
else
    echo "------------------$PACKAGE_NAME:Install_&_test_both_success-------------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub  | Pass |  Both_Install_and_Test_Success"
    exit 0
fi
