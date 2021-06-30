# tac-fed

## About
Helper scripts to assist in the movement of helm charts and container images from Tanzu Application Catalog (TAC) to an offline registry.

## Getting started
Some assumptions are made for the storage of images and charts, but they can be overridden by defining and exporting the following variables.
* `LOCAL_IMAGE_DIRECTORY="some/path/to/images"`
* `LOCAL_CHART_DIRECTORY="some/path/to/charts"`

Credentials are parsed from an authentication file (`tac-config.json`), composed in the dockerconfigjson format.`tac-config.json` is generated on the first execution of this script.

Credentials can also be overridden by defining and exporting the following variables:
* `TAC_REPOSITORY_USER` (username used to authenticate to TAC)
* `TAC_REPOSITORY_PASS` (password used to authenticate to TAC)

Example variable declaration:
```
LOCAL_CHART_DIRECTORY="charts"
LOCAL_IMAGE_DIRECTORY="images"
TAC_IMAGE_REPOSITORY="registry.pivotal.io/foo"
TAC_REPOSITORY_USER="robot\$foo"

export LOCAL_IMAGE_DIRECTORY
export TAC_IMAGE_REPOSITORY
export LOCAL_CHART_DIRECTORY
export TAC_REPOSITORY_USER
```

#

## Requisite tooling
These helper scripts depend on the following tools:
* [Skopeo](https://github.com/containers/skopeo)
* [Helm](https://helm.sh/)
* [jq](https://stedolan.github.io/jq/)
* [oras](https://github.com/oras-project/oras)
