# My personal bashrc file.
# Copyright (C) 2013 Scott Weldon

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Hard-coded Vars #
data="/mnt/data"
script="$data/Scripts"

# Env Vars #
PATH="`find "$script" -name '.*' -prune -o -type d -printf '%p:'`$PATH"

# Helper Functions #
function customAlias() {
  cmd="$1"
  needsRoot=""
  
  case "$cmd" in
    "pdf")
      possibles=("evince" "atril")
      ;;
    "txt")
      possibles=("gedit" "pluma")
      ;;
    "doc")
      possibles=("libreoffice" "openoffice")
      ;;
    "web")
      possibles=("surf" "links" "lynx")
      ;;
    "fm")
      possibles=("nautilus" "caja" "dolphin")
      ;;
    "pkg")
      possibles=("apt-get" "yum" "pacman")
      needsRoot="sudo "
      ;;
    *)
      return 1
      ;;
  esac
  
  for exe in ${possibles[*]}
  do
    type -t $exe > /dev/null
    if [ $? -eq 0 ]
    then
      alias $cmd="$needsRoot$exe"
      break
    fi
  done
  
  unset cmd exe possibles
}

for cmd in pdf txt doc web fm pkg
do
  customAlias "$cmd"
done

unset customAlias

# Useful functions #
function chdir() {
  validArgs=("args" "dirs")
  source loadconf "$HOME/.scott_script/bashrc" "chdir.cfg" validArgs[@] > /dev/null
  
  i=0
  len=${#args[*]}
  while [ $i -lt $len ]
  do
    if [ ${args[$i]} == "$1" ]
    then
      newdir=${dirs[$i]}
      break
    fi
    i=`expr $i + 1`
  done
  
  if [ "$newdir" == "" ]
  then
    newdir="$1"
  fi
  
  cd $newdir
  
  unset validArgs newdir i len args dirs
}

unset cfgdir

# Custom aliases
alias dif="diff --suppress-common-lines -wy"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

