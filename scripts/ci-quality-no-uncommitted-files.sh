#!/bin/sh

set -o errexit
set -o nounset

if [ -n "$(git status --porcelain)" ]
then
  echo "ERROR: Found uncommitted files in repository:" >&2
  git status --porcelain >&2
  exit 1
fi
