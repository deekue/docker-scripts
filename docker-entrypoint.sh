#!/bin/bash
#
# set up a user and switch to that user
# deps: gosu

set -euo pipefail

UID="${UID:-1000}"
GID="${GID:-1000}"
export USER=user
export HOME="/home/${USER}"

echo "creating group [${USER}] with id ${GID}"
groupadd -fo -g "${GID}" "${USER}"
if ! id -u "${USER}" ; then
  echo "creating user [${USER}] with id ${UID}"
  useradd --shell /bin/bash \
    -u "${UID}" -g "${GID}" -G video,cdrom \
    -o -c "" "${USER}"
  chown "${USER}.${USER}" "${HOME}"
  chmod ug+rwX "${HOME}"
fi

if [[ "${RUN_AS_USER:-true}" == "true" ]] ; then
  exec /usr/sbin/gosu arm "$@"
else
  exec "$@"
fi
