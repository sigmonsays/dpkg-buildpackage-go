#!/usr/bin/env bash


cat <<EOF | debconf-set-selections
tzdata	tzdata/Areas select	America
tzdata	tzdata/Zones/America	select	Los_Angeles
tzdata	tzdata/Zones/Etc	select	UTC
tzdata	tzdata/Zones/US	select
EOF
