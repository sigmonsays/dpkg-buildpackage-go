# Build Debian Package: Buster

This is a [GitHub Action](https://github.com/features/actions) that will

## Usage

```yaml
on:
  push:
    branches:
      - master

jobs:
  build-deb:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - uses: sigmonsays/dpkg-buildpackage@v1
        id: build
        with:
          args: --unsigned-source --unsigned-changes

      - uses: actions/upload-artifact@v1
        with:
          name: ${{ steps.build.outputs.filename }}
          path: ${{ steps.build.outputs.filename }}
```

This Action wraps the [`dpkg-buildpackage`](https://manpages.debian.org/buster/dpkg-dev/dpkg-buildpackage.1.en.html)
command. To use it, you must have a `debian` directory at the top of
your repository, with all the files that `dpkg-buildpackage` expects.

This Action does the following things inside a Docker container:

1. Call [`mk-build-deps`](http://manpages.ubuntu.com/manpages/buster/man1/mk-build-deps.1.html)
   to ensure that the build dependencies defined the `debian/control` file
   are installed in the Docker image.
2. Call [`dpkg-buildpackage`](https://manpages.debian.org/buster/dpkg-dev/dpkg-buildpackage.1.en.html)
   with whatever arguments are passed to the
   [`args` input](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepswithargs) in the step definition.
3. Move the resulting `*.deb` files into the top level of your repository,
   so that other GitHub Actions steps can process them futher.
4. Set the `filename` and `filename-dbgsym`
   [outputs](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjobs_idoutputs),
   so that other GitHub Actions steps can easily reference
   the resulting files.

