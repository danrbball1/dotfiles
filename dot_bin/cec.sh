#!/usr/bin/env bash

# Required Package: cec-utils
# echo 'scan' | cec-client -s -d 1
# echo 'on <DEVICE #>' | cec-client -s -d 1
# echo 'as' | cec-client -s -d 1
# echo 'standby <DEVICE #>' | cec-client -s -d 1
# echo 'pow <DEVICE #>' | cec-client -s -d 1

iso8601_date () {
  date +%Y-%m-%dT%H:%M:%S%z
}

turn_on () {
  echo "on 0" | cec-client -s -d 1
  echo "as" | cec-client -s -d 1
}

turn_off () {
  echo "as" | cec-client -s -d 1
  echo "standby 0" | cec-client -s -d 1
}

args="$1"

case $args in
  on)
#  echo "[$(iso8601_date)]: Turning the TV on"
  turn_on
  ;;

  off)
 # echo "[$(iso8601_date)]: Turning the TV off"
  turn_off
  ;;

  auto)
  echo "[$(iso8601_date)]: Checking the TV power state"
  if [[ $(echo 'pow 0' | cec-client -s -d 1 RPI) =~ "power status: standby" ]]; then
    echo "[$(iso8601_date)]: The TV appears to be off, turning it on now"
    turn_on
  else
    echo "[$(iso8601_date)]: The TV appears to be on, turning it off now"
    turn_off
  fi
  ;;

  *)
  echo "Usage:"
  echo "  toggle-tv-power on|off|auto"
  exit 1
esac

echo "---"
