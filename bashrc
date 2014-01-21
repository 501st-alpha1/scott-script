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
script="$data/scripts"

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
alias dif="diff --suppress-common-lines --ignore-all-space --side-by-side"
alias ll='ls --all -l --file-type'
alias la='ls --almost-all'
alias l='ls -C --file-type'
#alias emacs="/usr/bin/emacs --no-window-system"
alias emacsd="emacs --daemon"
alias e="emacsclient -t"
alias psurf="surf -c /dev/null"

# Prompt customisation
# Default Ubuntu: \[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\$
green="\[\033[0;32m\]"
blue="\[\033[0;34m\]"
red="\[\033[0;31m\]"
end="\[\033[0m\]"
returncode="\$?"
currdir="[\w]"
time="[\t]"
user="[\u@\h]"
stats="[\!:$returncode]"
PS1="$green$currdir$stats\n$time$user\$$end "

# GitHub script
type -t "hub" > /dev/null
if [ $? -eq 0 ]
then
  alias git=hub
fi
