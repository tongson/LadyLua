#!/bin/sh
unset IFS
set -o errexit -o nounset -o noglob
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
export LC_ALL=C

__mark()
{
  printf >&2 "► “%s”\\n" "$*"
  printf "► “%s”\\n" "$*"
}
