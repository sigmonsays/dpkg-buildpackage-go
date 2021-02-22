#!/bin/bash

git fetch --prune --unshallow 2>/dev/null

function _git_ver {
    #git describe --tags --abbrev=0 --match 'v*' --exclude '*-rc*' HEAD~
    git describe --tags | tr -d a-z
}

echo "dpkg-build-package-go started (rev33)"
echo "debian package git version $(_git_ver)"

# Bump version
pkg_name="$(awk '/Package:/ {print $2}' debian/control)"
git_ver="$(_git_ver)"

[[ -z "$git_ver" ]] && git_ver=0.0.1

cat <<EOF > debian/changelog
$pkg_name ($git_ver) UNRELEASED; urgency=medium

  * automated release

 -- bot <bot@example.net>  $(date -R)
EOF

# Set the install command to be used by mk-build-deps (use --yes for non-interactive)
install_tool="apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes"
# Install build dependencies automatically
mk-build-deps --install --tool="${install_tool}" debian/control


# Install go
# https://golang.org/dl/go1.16.linux-amd64.tar.gz
curl -L https://golang.org/dl/go1.16.linux-amd64.tar.gz | tar -C /usr/local -xzf -
export PATH=$PATH:/usr/local/go/bin

# Build the package
dpkg-buildpackage $@
# Output the filename
cd ..

# Trash the build deps
ls -l *.deb
rm -vf *build-deps*.deb

filename=`ls -1 *.deb | grep -v -- -dbgsym | grep -v -- build-deps `
dbgsym=`ls -1 *.deb | grep -- -dbgsym`
echo ::set-output name=filename::$filename
#echo ::set-output name=filename-dbgsym::$dbgsym


exit 0
