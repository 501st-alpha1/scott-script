#PATH="/mnt/data/Scripts:$PATH"

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
  
  for exe in $possibles
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
