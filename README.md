# Lenovo IdeaPad 5 14ARE05 Energy Management Plasmoid

### About

this is a (unofficial) plasmoid for energy management on Lenovo IdeaPad 5 14ARE05.

## Pre-requisites

for the correct functioning the plasmoid requires a ideapad5\_14are05 energy management script that can be obtained [here](https://github.com/theorlangur/ideapad5_14are05_energy_mgmt)

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
     cmake -H. -Bbuild -DCMAKE\_INSTALL\_PREFIX=~/.local
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
