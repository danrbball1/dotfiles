#!/usr/bin/env bash

rsync -rvh --progress --delete --dry-run transfer3/ daniel@192.168.10.252:/home/transfer3
