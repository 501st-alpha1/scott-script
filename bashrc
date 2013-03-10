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

# Env Vars #
PATH="$data/Scripts:$PATH"

# Helper Functions #
function customAlias() {
  cmd="$1"
  
  if [ "$cmd" == "pdf" ]
  then
    possibles=("evince" "atril")
  elif [ "$cmd" == "txt" ]
  then
    possibles=("gedit" "pluma")
  elif [ "$cmd" == "doc" ]
  then
    possibles=("libreoffice" "openoffice")
  else
    return 1
  fi
  
  for exe in ${possibles[*]}
  do
    type -t $exe > /dev/null
    if [ $? -eq 0 ]
    then
      alias $cmd="$exe"
      break
    fi
  done
  
  unset cmd exe possibles
}

customAlias pdf
customAlias txt
customAlias doc
unset customAlias

# Useful functions #
function chdir() {
  validArgs=("args" "dirs")
  source loadconf "$HOME/.scott_script/bashrc" "chdir.cfg" validArgs[@]
  
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
}
