#/usr/bin/env bash
set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# Check if name is specified
if [[ $1 == zmq ]] || [[ $1 == zmq:* ]]; then
  if [[ -z $2 ]]; then
    echo "You must specify an app name"
    exit 1
  else
    APP="$2"

    # Check if app exists with the same name
    if [ ! -d "$DOKKU_ROOT/$APP" ]; then
      echo "App $APP does not exist"
      exit 1
    fi
  fi
fi

case "$1" in

  zero)
    echo "Hello from zero"
    ;;

  zero:set)
    echo "hallo"
    ;;

  help)
    cat && cat<<EOF
    zero <app>                                   display the zero info for an app
    zero:set <app>                               set zero on an app
EOF
    ;;
esac
