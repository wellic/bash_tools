#!/usr/bin/env sh

set -u
#set -x

echo $USER
SETUP_DIR=terminator_repo

BR=${1:-master}
PREFIX=${2:-/usr/local}
export PREFIX

#first install
if [ ! -d "$SETUP_DIR" ]; then
    #git clone git@github.com:gnome-terminator/terminator.git "$SETUP_DIR"
    git clone https://github.com/gnome-terminator/terminator.git "$SETUP_DIR"

    sudo apt install -y  python3-gi python3-gi-cairo python3-psutil python3-configobj \
                         gir1.2-keybinder-3.0 gir1.2-vte-2.91 gettext intltool dbus-x11
fi

sudo pkill terminator || echo "Can't close terminator"

cd "$SETUP_DIR"
[ ! -f install-files.txt ] || sudo python3 setup.py uninstall --manifest=install-files.txt

git fetch -pt
git pull
git co "$BR"

sudo find "$PREFIX" -type f -name "terminator*"  || echo "Can't remove terminator"
sudo find "$PREFIX" -type f -name "remotinator*" || echo "Can't remove renominator"

python3 setup.py build

sudo python3 setup.py install --single-version-externally-managed --record=install-files.txt --prefix=$PREFIX

sudo gtk-update-icon-cache -q -f "${PREFIX}/share/icons/hicolor"

echo 'Installed'

