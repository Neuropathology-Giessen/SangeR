
<p align="left">
  <img src="sanger_logo.png" alt="SangeR logo"/>
</p>

-----

Welcome to the git repository of `SangeR`, the program that makes sanger sequencing analysis high-throughput.

It provides you different ways to use it.

1. You can use the R package to use it your own way.

2. For high-troughput you can use the [Nextflow](https://www.nextflow.io/) script which utilizes the [Docker](https://www.docker.com/) container.

3. You can use it as a shiny tool: https://gin-sanger.med.uni-giessen.de


## Required Software

  - [R](https://www.r-project.org/) (ist 4.0.1 or newer)

  - [Nextflow](https://www.nextflow.io) (19.10 or newer)

## Required R Packages

  - sangerseqR
  
  - biomaRt
  
  - stringr
  
  - ggplot2
  
  - reshape2

  - CrispRVariants
  
  - Biostrings
  
  - seqinr
  
  - shiny

  - gridExtra
  
## Installation
You can install the SangeR package via R's `devtools` in Ubuntu/Debian by typing:
```
$ sudo apt update && apt install -y build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev r-base

$ R -e 'install.packages(c("BiocManager","stringr","ggplot2","reshape2","seqinr","devtools"))'

$ R -e 'BiocManager::install(c("Biostrings","CrispRVariants","biomaRt","sangerseqR"))'

$ R -e 'library("devtools"); install_github("https://github.com/kaischmid/SangeR")'
```
Hint: `$` assumes a BASH prompt.


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

- In this case you only have to provied the ab1 file which is supposed to be analyzed

- optional you can provide a POI (Point Of Interest) file to investigate every given file for mutations at your desired positions.


#### Offline
The pipeline needs a prepared local reference database for the offline use.

- In this case you only have to provied the ab1 file which is supposed to be analyzed

- Additional you have to provide the needed mart ressources for the genes you want to analyze

- optional you can provide a POI (Point Of Interest) file to investigate every given file for mutations at your desired positions.

### PARAMETERS

The following parameters can be set:

  - filename: location of a ab1 file.
  - delimiter: delimiter in genename/ID of ab1 file
  - ID_pos: position of ID in genename/ID of ab1 file
  - genename_pos: position of genename in genename/ID of ab1 file
  - cutoff: cutoff for Basecall of the fastq. Default: 0.05
  - min_seq_len: minimum sequence length for Basecall of the fastq. Default: 20
  - offset: Offset for Basecall of the fastq. Default: 33
  - upstream: region before gene to be loaded into ref_seq
  - host: Host to connect to. Defaults to grch37.ensembl.or
  - dataset: Dataset you want to use. To see the different datasets available within a biomaRt you can e.g. do: mart = useMart("ensembl"), followed by listDatasets(mart). Default: hsapiens_gene_ensembl
  - biomart: BioMart database name you want to connect to. Possible database names can be retrieved with the function listMarts. Default: ensembl
  - POI: file with list of points of interest




### OUTPUT

The pipeline generates the following output:

  - Histogramm for each mutated position/selected POI

  - .csv with the found mutations for all given files


### Example
#### Testset
Feel free to test the pipeline with our provided test set which you can find under:
https://zenodo.org/record/5465810#.YVcm0HuxXJU

First clone the repository to your machine:
`git clone https://github.com/kaischmid/SangeR.git`

Then run the following command:

`./main.nf `


## CAVEATS
Complete list of open issues is available on [Github-Issues](https://github.com/kaischmid/SangeR/issues).

Please report any new issues ad [new Github-Issue](https://github.com/kaischmid/SangeR/issues/new).

## Changelog
- scheduled for next release

  - The mayor focus for the next version is the implementation of a machine learning-based algorithm to find a fitting threshold. At the moment it is set statistically.

- [v1.0.0] Link (2020-11-01)


## License
This program is released under GPLv3. For further license information, see LICENSE.md shipped with this program.
Copyright(c)2020 Kai Schmid and Daniel Amsel (employees of the Justus Liebig University Giessen - Germany). All rights reserved.

# AUTHORS


# SEE ALSO
[Docker image on DockerHub](https://hub.docker.com/repository/docker/kaischmid/sange_r)
