#!/usr/bin/env bash

# set -x

progname=$(basename "$0")

VERSION="[$progname] v0.1"

OPT_SILENT=false
OPT_NO_COLORS=false

ENVFILE=.env

# Colors
RED='\033[1;31m'
NC='\033[0m'
GREY='\033[1;30m'
ACCENT='\033[1;34m'

function error() {
  if [[ "$OPT_NO_COLORS" == "true" ]]; then
    printf "${1}\n"
  else
    printf "${RED}${1}${NC}\n"
  fi
}

function msg() {
  if [[ "$OPT_SILENT" == "false" ]]; then
    if [[ "$OPT_NO_COLORS" == "true" ]]; then
      printf "${1}\n"
    else
      printf "${GREY}${1}${NC}\n"
    fi
  fi
}

function print_running_command() {
  if [[ "$OPT_SILENT" == "false" ]]; then
    command=$1
    envpath=$2
    if [[ "$OPT_NO_COLORS" == "true" ]]; then
      printf "[$progname] running command '${command}' with env from $envpath..\n"
    else
      printf "${GREY}[$progname] running command '${ACCENT}${command}${GREY}' with env from $envpath..${NC}\n"
    fi
  fi
}

function usage() {
  echo "usage: $progname [-v] [-h] [-nc] [-s] [-e KEY=VALUE] [-f infile] command"
  echo "  "
  echo "  example: $progname -f ~/my/secret/env/file.env -e CONCURRENCY=12 node ./app.js"
  echo "  WARNING: $progname requires .env file in $PWD. You can use another location with -f opt."
  echo "  "
  echo "  Options:"
  echo "  -v  | -V | --version         print $progname version"
  echo "  -h  | --help                 display help"
  echo "  -nc | --no-colors           print outputs without colors"
  echo "  -s  | --silent               silent mode - omit displaying info logs"
  echo "  -f  | --env-file infile      use other file than .env to load env vars"
  echo "  -e  | --env-var KEY=VALUE    override a single env var after loading env file, can be stacked"
}

if [[ -z "$1" ]]; then
  usage
  exit 1
fi

# Initializes overrides string to allow using -e KEY=VALUE overrides
OVERRIDES=""

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
  case $1 in
  -V | -v | --version)
    msg "$VERSION"
    exit 0
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  -s | --silent)
    OPT_SILENT=true
    ;;
  -nc | --no-colors)
    OPT_NO_COLORS=true
    ;;
  -f | --env-file)
    shift
    msg "[$progname] use env from non-standard path: $1"
    ENVFILE=$1
    ;;
  -e | --env-var)
    shift
    msg "[$progname] override $1"
    OVERRIDES="$OVERRIDES $1"
    ;;
  esac
  shift
done
if [[ "$1" == '--' ]]; then shift; fi

if [[ ! -e $ENVFILE ]]; then
  error "[$progname] ERROR: env file $ENVFILE doesn't exist (you can specify another file with --env-file | -f flag"
  exit 1
fi

if [[ -z "${@}" ]]; then
  usage
  exit 1
fi

# Load env vars from file
ENV_VARS_FROM_FILE=$(cat $ENVFILE | xargs)
if [[ -n "$ENV_VARS_FROM_FILE" ]]; then
  export $ENV_VARS_FROM_FILE
fi

# Load overrides if present
if [[ -n "$OVERRIDES" ]]; then
  export $OVERRIDES
fi

print_running_command ${@} $ENVFILE

which $1 >>/dev/null
if [[ "$?" != "0" ]]; then
  error "[$progname] ERROR: command not found"
  error "[$progname] ERROR: '$1' not found, using 'which $1'"
  exit 1
fi

${@}
