# Copyright (C) 2022 Patrick Pedersen, TUDO Makerspace

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Author: Patrick Pedersen <ctx.xda@gmail.com>
# Brief Description: Sets up the activity-indicator
# Usage: See sudo ./setup.sh [install|uninstall]

# Get directory of this script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_DIR="$SCRIPT_DIR"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ "$1" = "install" ]; then
        cp -v $PROJECT_DIR/software/switch_monitor.py /usr/local/sbin/switch_monitor

        mkdir -p /usr/share/pyshared/activity-indicator
        mkdir -p /usr/share/pyshared/activity-indicator/telegram
        cp -v $PROJECT_DIR/software/telegram/*.py /usr/share/pyshared/activity-indicator/telegram/

        mkdir -p /var/lib/activity-indicator
        cp -v $PROJECT_DIR/software/switch_monitor.ini /var/lib/activity-indicator/switch_monitor.ini
        cp -v $PROJECT_DIR/software/telegram/telegram.ini /var/lib/activity-indicator/telegram.ini

        echo "Setting up systemd service"
        bash $PROJECT_DIR/software/systemd/setup.sh install

        echo "Installation complete, the activity monitor should be running now!"
elif [ "$1" = "uninstall" ]; then
        echo "Uninstalling..."
        rm -v -rf /usr/local/sbin/switch_monitor
        rm -v -rf /usr/share/pyshared/activity-indicator
        rm -v -rf /var/lib/activity-indicator
        rm -v -rf /etc/systemd/system/activity-indicator.service

        echo "Disabling systemd service"
        bash $PROJECT_DIR/software/systemd/setup.sh uninstall

        echo "Uninstallation complete"
else
        echo "Usage: sudo ./setup.sh [install|uninstall]"
fi
