# https://github.com/marehr/docker-gcc-git

This is a fork of https://github.com/docker-library/gcc which uses the latest git source of any active major gcc release (including trunk).

This version will download the latest available source from https://github.com/gcc-mirror/gcc/ and builds it.

For example gcc-10 would be build from the release branch
[releases/gcc-10](https://github.com/gcc-mirror/gcc/tree/releases/gcc-10).

How to build and push to the registry?

```bash
# Update all the Docker sources
# calls ./versions.sh and ./apply-templates.sh
./update.sh

version="trunk" # e.g. "trunk", "8", "9", "10", "11", etc... (basically any folder in this repo)

# Note that --no-cache is important as otherwise Docker would think that it doesn't need to build
# anything since the  Dockerfile is unchanged. But of course the internally used git source might
# have changed.
sudo docker build $version --tag ghcr.io/marehr/gcc-git:$version-latest --no-cache

sudo docker push ghcr.io/marehr/gcc-git:$version-latest
```

Follow the [instruction](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry) how to login into the registry.

Original Description:

-----

# https://github.com/docker-library/gcc

## Maintained by: [the Docker Community](https://github.com/docker-library/gcc)

This is the Git repo of the [Docker "Official Image"](https://github.com/docker-library/official-images#what-are-official-images) for [`gcc`](https://hub.docker.com/_/gcc/) (not to be confused with any official `gcc` image provided by `gcc` upstream). See [the Docker Hub page](https://hub.docker.com/_/gcc/) for the full readme on how to use this Docker image and for information regarding contributing and issues.

The [full image description on Docker Hub](https://hub.docker.com/_/gcc/) is generated/maintained over in [the docker-library/docs repository](https://github.com/docker-library/docs), specifically in [the `gcc` directory](https://github.com/docker-library/docs/tree/master/gcc).

## See a change merged here that doesn't show up on Docker Hub yet?

For more information about the full official images change lifecycle, see [the "An image's source changed in Git, now what?" FAQ entry](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what).

For outstanding `gcc` image PRs, check [PRs with the "library/gcc" label on the official-images repository](https://github.com/docker-library/official-images/labels/library%2Fgcc). For the current "source of truth" for [`gcc`](https://hub.docker.com/_/gcc/), see [the `library/gcc` file in the official-images repository](https://github.com/docker-library/official-images/blob/master/library/gcc).

---

-	[![build status badge](https://img.shields.io/github/workflow/status/docker-library/gcc/GitHub%20CI/master?label=GitHub%20CI)](https://github.com/docker-library/gcc/actions?query=workflow%3A%22GitHub+CI%22+branch%3Amaster)
-	[![build status badge](https://img.shields.io/jenkins/s/https/doi-janky.infosiftr.net/job/update.sh/job/gcc.svg?label=Automated%20update.sh)](https://doi-janky.infosiftr.net/job/update.sh/job/gcc/)

| Build | Status | Badges | (per-arch) |
|:-:|:-:|:-:|:-:|
| [![amd64 build status badge](https://img.shields.io/jenkins/s/https/doi-janky.infosiftr.net/job/multiarch/job/amd64/job/gcc.svg?label=amd64)](https://doi-janky.infosiftr.net/job/multiarch/job/amd64/job/gcc/) | [![arm32v5 build status badge](https://img.shields.io/jenkins/s/https/doi-janky.infosiftr.net/job/multiarch/job/arm32v5/job/gcc.svg?label=arm32v5)](https://doi-janky.infosiftr.net/job/multiarch/job/arm32v5/job/gcc/) | [![arm32v7 build status badge](https://img.shields.io/jenkins/s/https/doi-janky.infosiftr.net/job/multiarch/job/arm32v7/job/gcc.svg?label=arm32v7)](https://doi-janky.infosiftr.net/job/multiarch/job/arm32v7/job/gcc/) | [![arm64v8 build status badge](https://img.shields.io/jenkins/s/https/doi-janky.infosiftr.net/job/multiarch/job/arm64v8/job/gcc.svg?label=arm64v8)](https://doi-janky.infosiftr.net/job/multiarch/job/arm64v8/job/gcc/) |
| [![ppc64le build status badge](https://img.shields.io/jenkins/s/https/doi-janky.infosiftr.net/job/multiarch/job/ppc64le/job/gcc.svg?label=ppc64le)](https://doi-janky.infosiftr.net/job/multiarch/job/ppc64le/job/gcc/) | [![s390x build status badge](https://img.shields.io/jenkins/s/https/doi-janky.infosiftr.net/job/multiarch/job/s390x/job/gcc.svg?label=s390x)](https://doi-janky.infosiftr.net/job/multiarch/job/s390x/job/gcc/) | [![put-shared build status badge](https://img.shields.io/jenkins/s/https/doi-janky.infosiftr.net/job/put-shared/job/light/job/gcc.svg?label=put-shared)](https://doi-janky.infosiftr.net/job/put-shared/job/light/job/gcc/) |

<!-- THIS FILE IS GENERATED BY https://github.com/docker-library/docs/blob/master/generate-repo-stub-readme.sh -->
