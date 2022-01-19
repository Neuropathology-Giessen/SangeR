![sangeR](./vignettes/sanger_logo.png "sangeR")

-----


Welcome to the git repository of `SangeR`, the program that makes sanger sequencing analysis high-throughput.

It provides you different ways to use it.

1. You can use the R package to use it your own way.

2. For high-troughput you can use the [Nextflow](https://www.nextflow.io/) script which utilizes the [Docker](https://www.docker.com/) container.

3. You can get the shiny tool running or use the one provided: https://gin-sanger.med.uni-giessen.de


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

### Please keep in mind that the following commands are supposed to install SangeR on a blank system.If you have libaries like R already installed it might update system level libraries. If you have r-base and the 3 libraries already installed you can probably skip the following comment. In case you do not have the permissions or are not willing to install please have a look at the docker container.

You can install the SangeR package via R's `devtools` in Ubuntu/Debian by typing:


First you need to update your 'apt' followed by the install of libcurl4-gnutls-dev libxml2-dev libssl-dev and r-base buy using this command:
```
$ sudo apt-get update 
 
$ sudo apt-get install -y build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev r-base
```

You can install the SangeR package via R's `devtools` in Ubuntu/Debian by typing:

```
$ R -e 'install.packages(c("BiocManager","stringr","ggplot2","reshape2","seqinr","devtools"))'

$ R -e 'BiocManager::install(c("Biostrings","CrispRVariants","biomaRt","sangerseqR"))'

$ R -e 'library("devtools"); install_github("https://github.com/kaischmid/SangeR")'
```
Hint: `$` assumes a BASH prompt.

Or you start R/Rstudio and enter the following lines:
```
install.packages(c("BiocManager","stringr","ggplot2","reshape2","seqinr","devtools"))
BiocManager::install(c("Biostrings","CrispRVariants","biomaRt","sangerseqR"))
library("devtools")
install_github("https://github.com/kaischmid/SangeR")
```

If you are struggeling with installing xml2 you may try these commands in R/RStudio:
```
install.packages("xml2", dependencies=TRUE, INSTALL_opts = c("--no-lock"))
install.packages(c("BiocManager","stringr","ggplot2","reshape2","seqinr","devtools"), dependencies=TRUE, INSTALL_opts = c("--no-lock"))
```


## Docker
We also provide `SangeR` as [DOCKER image](https://hub.docker.com/r/kaischmid/sange_r). We tested the image on Ubuntu and MacOS. 

'''
docker pull kaischmid/sange_r
'''


## Usage

You can use SangeR in different ways:
1. shiny
2. R 
  In container
  without 
4. nextflow

###shiny

The easiest way to get in touch with SangeR is to have a look at the provide shiny app:

It can be found under:

https://gin-sanger.med.uni-giessen.de

or by pulling the Git repository and run the app.R in R/Rstudio

'''R
shiny::runApp('<dowbload_directory>/SangeR-master/R')
'''

In the GUI you can now select a .ab1 file from the provide test data: https://zenodo.org/record/5865470#.YeiFfC9XZpQ

The files from the .zip named ab1_with_mutation.zip contain examples with mutation.

Also you can upload the POI file from the git repository you can find under "/data/".

All positions in the POI will be plottet, so that the user can have a look at the chromatogramm.

The need for this function can be recognized by looking at Patient 1. 
By the default threshold SangeR only can find the silent mutation G105G. By including the POI the user can have a look at 132 position and is able to decied on his own if the signal is too strong.

Also you can download the plot at the bottom of the menu.

### R/Rstudio


### Input data

The pipeline needs the following files as input.
We divided the pipeline into an online and an offline mode.

#### Online
The pipeline gathers the necessary reference data on demand from online resources, but needs a stable internet connection.

- In this case you only have to provied the ab1 file which is supposed to be analyzed

- optional you can provide a POI (Point Of Interest) file to investigate every given file for mutations at your desired positions.
- The format of this file shall be a .csv file containing the positions like follows:
- "Points of interest"
- "1" "5:1295228"
- "2" "5:1295250"
- "`<count>`" "`<chromsome>`":"`<position on chromosome>`" 


#### Offline
The pipeline needs a prepared local reference database for the offline use.

- In this case you have to provied the ab1 file which is supposed to be analyzed

- Additional you have to provide the needed mart ressources for the genes you want to analyze

- optional you can provide a POI (Point Of Interest) file to investigate every given file for mutations at your desired positions.
- The format of this file shall be a .csv file containing the positions like follows:
- "Points of interest"
- "1" "5:1295228"
- "2" "5:1295250"
- "`<count>`" "`<chromsome>`":"`<position on chromosome>`" 

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
https://zenodo.org/record/5865470#.YeXufi9XZpQ

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
