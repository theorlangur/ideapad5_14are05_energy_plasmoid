# Lenovo IdeaPad 5 14ARE05 Energy Management Plasmoid

### About

this is a (unofficial) plasmoid for energy management on Lenovo IdeaPad 5 14ARE05.

## Pre-requisites

* for the correct functioning the plasmoid requires a ideapad5\_14are05 energy management script that can be obtained [here](https://github.com/theorlangur/ideapad5_14are05_energy_mgmt)
* `extra-cmake-modules` package is required in order to be able to configure/install the plasmoid with cmake

## Install

* download a repository archive or clone the repo
* cd into cloned/unpacked directory
* Configuring for:
   * default install (into /usr/share/...)
     ```
     cmake -H. -Bbuild
     ```
   * install only for the current user (in $HOME/.local/...)
     ```
     cmake -H. -Bbuild -DCMAKE_INSTALL_PREFIX=~/.local
     ```
* Installing
   * default configured
     ```
     cd build
     sudo make install
     ```
   * configured for current user only
     ```
     cd build
     make install
     ```

## Usage

Can be added either on the desktop in expanded form or on the panel in form of an icon.
In the expanded form the plasmoid constantly polls (every 800ms) the script. Which among other things results
in numerous entries in logs. In order to avoid this it's advised to have this plasmoid in the iconified mode
on the panel because in this case the script will be run only when plasmoid is expanded (clicked on), not bothering
the system otherwise.
