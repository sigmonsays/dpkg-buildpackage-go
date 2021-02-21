#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
cat <<EOF | debconf-set-selections
tzdata	tzdata/Areas select	America
tzdata	tzdata/Zones/America	select	Los_Angeles
tzdata	tzdata/Zones/Etc	select	UTC
tzdata	tzdata/Zones/US	select
EOF

set -e
# Set the install command to be used by mk-build-deps (use --yes for non-interactive)
install_tool="apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes"
# Install build dependencies automatically
mk-build-deps --install --tool="${install_tool}" debian/control
# Build the package
dpkg-buildpackage $@
# Output the filename
cd ..
filename=`ls *.deb | grep -v -- -dbgsym`
dbgsym=`ls *.deb | grep -- -dbgsym`
echo ::set-output name=filename::$filename
echo ::set-output name=filename-dbgsym::$dbgsym
# Move the built package into the Docker mounted workspace
mv $filename $dbgsym workspace/
