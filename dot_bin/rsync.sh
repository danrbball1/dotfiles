#!/usr/bin/env bash

rsync -rvh --progress --delete movies/ daniel@192.168.1.250:/volume1/media/movies
