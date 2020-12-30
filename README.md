# SangeR

Welcome to the git repository of the `SangeR`, the program that makes sanger sequencing analysis high-throughput.

It provides you different ways to use it.

1. You can use the R package to use it your own way.

2. For high-troughput you can use the Nextflow script which utilizes the docker container.


## Required Software

  - [Nextflow](https://www.nextflow.io) (19.10 or newer)

## Required R Packages


## Installation
Please install the dependencies and run
```
git clone -b v1.0.0 https://github.com/kaischmid/SangeR.git
```
or download the latest release as `*.tar.gz` or `*.zip` file:
```
curl -L -o .tar.gz
# or
curl -L -o .zip
```

## Docker
We also provide `SangeR` as [DOCKER image](https://hub.docker.com/r/kaischmid/sange_r). We tested the image on Ubuntu and MacOS. 

'''
docker pull kaischmid/sange_r
'''


## Usage

### Input data

The pipeline needs the following files as input.
We divided the pipeline into an online and an offline mode.

#### Online
The pipeline gathers the necessary reference data on demand from online resources, but needs a stable internet connection.

-
-
-

#### Offline
The pipeline needs a prepared local reference database for the offline use.

-
-
-

### PARAMETERS

The following parameters can be set:


### OUTPUT

The pipeline generates the following output:


### Example
#### Testset
Feel free to test the pipeline with our provided test set.
Zenodo?

First clone the repository to your machine:
`git clone https://github.com/kaischmid/SangeR.git`

Then run the following command:


## CAVEATS
Complete list of open issues is available on [Github-Issues](https://github.com/kaischmid/SangeR/issues).

Please report any new issues ad [new Github-Issue](https://github.com/kaischmid/SangeR/issues/new).

## Changelog
- scheduled for next release

    No features planned

- [v1.0.0] Link (2020-11-01)


## License
This program is released under GPLv3. For further license information, see LICENSE.md shipped with this program.
Copyright(c)2020 Kai Schmid and Daniel Amsel (employees of the Justus Liebig University Giessen - Germany). All rights reserved.

# AUTHORS


# SEE ALSO
[Docker image on DockerHub]
