#!/bin/bash
# My personal bashrc file.
# Copyright (C) 2013-2015 Scott Weldon

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

# Initialize variables. #
if [ -z "$MY_DATA_DIR" ]
then
  data='/mnt/data'
  echo "MY_DATA_DIR not set, defaulting to $data."
else
  data="$MY_DATA_DIR"
fi
script="$data/code/scripts"

# Env Vars #
PATH="`find "$script" -name '.*' -prune -o -type d -printf '%p:'`$PATH"
PATH="$data/bin:$PATH"

if [ -d "$HOME/.go/bin" ]
then
  PATH="$PATH:$HOME/.go/bin"
fi
if [ -d "$HOME/.rvm/bin" ]
then
  PATH="$PATH:$HOME/.rvm/bin"
fi
if [ -d "$HOME/.composer/vendor/bin" ]
then
  PATH="$PATH:$HOME/.composer/vendor/bin"
fi

export HISTTIMEFORMAT="%F %T  "
# Save entire history.
export HISTSIZE=-1
export HISTFILESIZE=-1

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
  validArgs=("args" "dirlist")
  source loadconf "$HOME/.scott_script/bashrc" "chdir.cfg" validArgs[@] > /dev/null

  i=0
  len=${#args[*]}
  while [ $i -lt $len ]
  do
    if [ ${args[$i]} == "$1" ]
    then
      newdir=${dirlist[$i]}
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

function say {
  echo "$1" | festival --tts;
}

unset cfgdir

function stop {
  sig="STOP"
  if [ "$1" == "soft" ]
  then
    sig="TSTP"
    shift
  fi

  [ -z "$1" ] && echo "Error: missing PID to suspend." && return 1

  kill -$sig "$@"
}

function resume {
  [ -z "$1" ] && echo "Error: missing PID to resume." && return 1

  kill -CONT "$@"
}

function stopWithChildren() {
  [ -z "$1" ] && echo "Error: missing PID to stop." && return 1

  pids=()
  while read line
  do
    pids+=("$line")
  done < <(ps -o pid --pid "$1" --ppid "$1" --no-headers)

  echo "Stopping these pids: ${pids[@]}"

  stop "${pids[@]}"
}

function resumeWithChildren() {
  [ -z "$1" ] && echo "Error: missing PID to resume." && return 1

  pids=()
  while read line
  do
    pids+=("$line")
  done < <(ps -o pid --pid "$1" --ppid "$1" --no-headers)

  echo "Resuming these pids: ${pids[@]}"

  resume "${pids[@]}"
}

# Custom aliases
alias dif="diff --suppress-common-lines --ignore-all-space --side-by-side"
alias ll='ls --all -l --file-type'
alias la='ls --almost-all'
alias l='ls -C --file-type'
#alias emacs="/usr/bin/emacs --no-window-system"
alias semacsd="torify emacs --daemon"
alias e="emacsclient -t"
alias ef="emacsclient -c"
alias psurf="surf -c /dev/null"
alias speedtest="wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip --report-speed=bits"
alias sspeedtest="torify wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip --report-speed=bits"
alias git-repo-authors="git ls-tree -r HEAD --name-only | xargs -I{} git blame --line-porcelain {} | sed -n 's/^author //p' | sort | uniq -c | sort -rn"
alias private-bash="HISTFILE='' torify bash -i"
alias local-private-bash="HISTFILE='' bash -i"
alias whatismyip='curl -s https://api.ipify.org'

function mktmpfs() {
  [ -z "$1" ] && echo "Error: please provide a size for ramdisk." && return 1

  [ -z "$2" ] && mount="/mnt/ramdisk" || mount="$2"

  sudo mount -t tmpfs -o size=$1 tmpfs $mount
}

# Remove unused Docker images, see https://stackoverflow.com/a/32723127/2747593
alias drmi="docker rmi \$(docker images --filter \"dangling=true\" -q --no-trunc)"

CUSTOM_MESSAGE=''
function get-custom-string() {
  [ "$CUSTOM_MESSAGE" == '' ] && return 0

  echo "[$CUSTOM_MESSAGE]"
}

function set-custom-string() {
  CUSTOM_MESSAGE="$1"
}

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
prompt="\n$green$currdir$stats\n$time$user"
prompt="${prompt}\$(get-custom-string)"
PS1="$prompt\$$end "
[ "$TERM" == "dumb" ] && PS1='$ '

# GitHub script
type -t "hub" > /dev/null
if [ $? -eq 0 ]
then
  alias git=hub
fi

current_gopath=$GOPATH
if [ "$current_gopath" != "" ]
then
  current_gopath="$current_gopath:"
fi

export GOPATH="$current_gopath$HOME/.go"

STATEFILE=state.txt
function continue-file() {
  tail --lines=+$(cat $STATEFILE) "$1"
}

function increment-state() {
  new_state=$(expr $(cat $STATEFILE) + 1)
  echo $new_state > $STATEFILE
}

function init-state() {
  echo 1 > $STATEFILE
}
