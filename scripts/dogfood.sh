#!/usr/bin/env bash

set -ue

SCRIPTDIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VS=/Applications/Visual\ Studio.app/
SLN=$(realpath $SCRIPTDIR/../samples/samples.sln)

usage()
{
  echo "Settings:"
  echo "  --vs     Path to Visual Studio for Mac, defaults to '$VS'."
  echo "  --sln    Path to a project or solution to open, defaults to '$SLN'."
}

firstArgumentChecked=0

while [[ $# > 0 ]]; do
  opt="$(echo "${1/#--/-}" | tr "[:upper:]" "[:lower:]")"

  if [[ $firstArgumentChecked -eq 0 && $opt =~ ^[a-zA-Z.+]+$ ]]; then
    if [ $opt == "help" ]; then
      usage
      exit 0
    fi

    shift 1
    continue
  fi

  firstArgumentChecked=1

  case "$opt" in
     -help|-h|-\?|/?)
      usage
      exit 0
      ;;

     -vs)
      VS=$2
      shift 2
      ;;

     -sln)
      SLN=$2
      shift 2
      ;;

      *)
      shift 1
      ;;
  esac
done

echo "Opening $SLN..."

DOTNET_INSTALL_DIR=$SCRIPTDIR/bin/dotnet/ \
    DOTNET_ROOT=$DOTNET_INSTALL_DIR \
    DOTNET_MULTILEVEL_LOOKUP=0 \
    PATH=DOTNET_ROOT:$PATH \
    open -n "$VS" "$SLN"
