# tac-fed
```brainfuck
   _|                                          _|_|                  _|
 _|_|_|_|    _|_|_|    _|_|_|                _|        _|_|      _|_|_|
   _|      _|    _|  _|        _|_|_|_|_|  _|_|_|_|  _|_|_|_|  _|    _|
   _|      _|    _|  _|                      _|      _|        _|    _|
     _|_|    _|_|_|    _|_|_|                _|        _|_|_|    _|_|_|
```
## About
Utility to assist in the movement of helm charts and container images from Tanzu Application Catalog (TAC) to an offline registry. This is currently tested on Arch Linux, RHEL 7.X and MacOS Big Sur.
## Getting started
Install all of the tools in the [Requisite tooling](#requisi

te-tooling) section

Credentials are parsed from an authentication file (`tac-auth.json`), composed in the dockerconfigjson format. `tac-config.json` is generated on the first execution of this script and will be used for subsequent executions. You **must** know the robot credentials that were provided to you as part of your TAC license agreement.

**NOTES**:
* A cache directory is persisted to `~/tac-fed`.
* Image transfer is generally slow due to serial requests to transfer images.

## Requisite tooling
`tac-fed` depends on the following tools:
* `base64`
* [helm](https://helm.sh/)
* [jq](https://stedolan.github.io/jq/)
* [oras](https://github.com/oras-project/oras)
* [skopeo](https://github.com/containers/skopeo)

## Usage
This command relies on being run from the directory that you cloned this Git repo into, due to its dependence on helper functions. This will be bundled for easy installation at a later date.

Providing the `--repository` option to the `image_pull` and the `chart_pull` commands is mandatory!

```console
USAGE: ./tac-fed COMMAND [OPTS]

COMMANDS:
* chart_pull: pull all of the latest charts that you are entitled to in TAC
* image_pull: pull all of the latest container images that you are entitled to in TAC
* clean: expunge the charts and images that are created by this tool
* help: print this usage text and exit

OPTS:
* --repository: your tac repository (e.g. 'tac-federal-customer', if using registry.pivotal.io/tac-federal-customer)
* --help: print this usage text and exit

ENV:
* TAC_CACHE_DIR: location to save charts, container images, and TAC authentication file (current: /home/foo/tac-fed)

EXAMPLES:
    ./tac-fed clean
    ./tac-fed image_pull --repository=tac-federal-customer
    ./tac-fed chart_pull --repository=tac-federal-customer
```

### Environment variables
The destination directory can currently be controlled via the `TAC_CACHE_DIR` environment variable prior to executing `tac-fed`. Ensure that the destination directory is adequately sized; `image_pull` operations can exceed 50GiB in size (depending on your entitlements).

```bash
TAC_CACHE_DIR=/tmp/tac-fed
export TAC_CACHE_DIR
```