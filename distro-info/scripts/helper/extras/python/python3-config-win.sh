#!/usr/bin/env bash

# Windows Python3 configuration script
#
# As per comment regarding --with-python in gdb/configure.ac, this script
# follows the interface of gdb/python/python-config.py but return path
# related to Windows Python3.

set -o errexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if variable not set.

if [ ! -d "${SOURCES_FOLDER_PATH}/${PYTHON3_SRC_FOLDER_NAME}" ]
then
  exit 1
fi

if [ ! -d "${SOURCES_FOLDER_PATH}/${PYTHON3_WIN_SRC_FOLDER_NAME}" ]
then
  exit 1
fi

while [ $# -ge 1 ]
do
  opt="$1"
  case ${opt} in

    --prefix|--exec-prefix)
      # prefix="${SOURCES_FOLDER_PATH}/${PYTHON3_WIN_SRC_FOLDER_NAME}"
      # Must have a common part to force PYTHON_PATH_RELOCATABLE
      prefix="${APP_PREFIX}"
      echo "${opt} -> [${prefix}]" >&2
      echo "${prefix}"
      ;;

    --includes|--cflags)
      cflags="-I${SOURCES_FOLDER_PATH}/${PYTHON3_SRC_FOLDER_NAME}/Include"

      if [ "${opt}" == "--cflags" ]
      then
        cflags+=" ${CFLAGS}"
      fi
      echo "${opt} -> [${cflags}]" >&2
      echo "${cflags}"
      ;;

    --libs|--ldflags)
      # Options to link to static libpython2.7 archive so as to avoid  an
      # external dependency on python
      libs="-L${SOURCES_FOLDER_PATH}/${PYTHON3_WIN_SRC_FOLDER_NAME} -lpython${PYTHON3_VERSION_MAJOR_MINOR}"
      echo "${opt} -> [${libs}]" >&2
      echo "${libs}"
      ;;

    --*)
      echo "Unknown option: ${opt}" >&2
      exit 1
      ;;

    *)
      # Ignore non options since we are called with gdb provided
      # python-config.py as first parameter
      ;;

  esac
  shift
done

exit 0
