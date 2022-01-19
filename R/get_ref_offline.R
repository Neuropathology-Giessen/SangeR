#' @name get_ref_routine
#'
#' @title This function loads the reference for a given SangeR object from a given mart file
#'
#' @param SangeR object from read.ab1() function.
#' @param mart mart file from directory
#'
#'
#' @return Objekt with all information of the reference.
#'
#' @export


#global Variables
globalVariables(c("exit"))

get_ref_routine <- function(SangeR, mart = "default"){

  #load mart file
  if(mart == "default"){
    load(paste0("./data/", SangeR$genename, ".mart"))
  } else{
    load(mart)
  }

  #write upstream to SangeR object
  SangeR$upstream <- mart$upstream

  #get reference sequence
  SangeR$ref_seq <- mart$ref_seq

  #ref aminoacid sequence
  SangeR$ref_amino <- mart$ref_amino

  #reference position
  SangeR$ref_pos <- mart$ref_pos

  #pepitde informations
  SangeR$pep_info <- mart$pep_info
  SangeR$pep_info$length <- mart$pep_info$length

  #controll if gene could be found

  if(length(SangeR$ref_seq$gene_exon_intron) == 0) {
    print("Gene could not been found, please verify that the gene name is correct")
    exit()
  }

  #return
  return(SangeR)

}

#' @name make_mart
#'
#' @title This function generates a mart which can be saved and later loaded by get_ref_routine
#'
#' @param genename genename of the disired region
#' @param upstream Region before gene to be loaded into ref_seq
#' @param host Host to connect to. Defaults to grch37.ensembl.or
#' @param dataset Dataset you want to use. To see the different datasets available within a biomaRt you can e.g. do: mart = useMart("ensembl"), followed by listDatasets(mart). Default: hsapiens_gene_ensembl
#' @param biomart BioMart database name you want to connect to. Possible database names can be retrieved with the function listMarts. Default: ensembl
#'
#' @return Objekt with all information of the reference.
#'
#' @export

make_mart <- function(genename, upstream = 500, host = "grch37.ensembl.org", dataset = "hsapiens_gene_ensembl", biomart = "ensembl"){

  #define mart
  mart = biomaRt::useMart(biomart = biomart, dataset = dataset, host = host)

  mart_save <- c()

  mart_save$upstream <- upstream

  #get reference sequence
  mart_save$ref_seq <- biomaRt::getSequence(id = genename, mart = mart, type = "hgnc_symbol", seqType = "gene_exon_intron", upstream = upstream)

  #ref aminoacid sequence
  temp_aminoacid <- biomaRt::getSequence(id = genename, mart = mart, type = "hgnc_symbol", seqType = c("peptide","refseq_peptide","end_position","start_position"))
  temp_aminoacid$refseq_peptide[temp_aminoacid$refseq_peptide==""] <- NA
  mart_save$ref_amino <- temp_aminoacid[!is.na(temp_aminoacid$refseq_peptide),]

  #reference position
  mart_save$ref_pos <- biomaRt::getBM(c("hgnc_symbol","chromosome_name","start_position","end_position","strand"), "hgnc_symbol", genename, mart)

  #pepitde informations
  pep_info <- biomaRt::getBM(values = strsplit(mart_save$ref_amino$refseq_peptide,split = ";")[[1]][1], "refseq_peptide", attributes = c("chromosome_name","cdna_coding_start","cdna_coding_end","exon_chrom_start","exon_chrom_end"), mart = mart)
  mart_save$pep_info <- pep_info[order(pep_info$cdna_coding_start),]
  mart_save$pep_info$length <- (mart_save$pep_info$cdna_coding_end - mart_save$pep_info$cdna_coding_start) + 1

  #controll if gene could be found

  if(length(mart_save$ref_seq$gene_exon_intron) == 0) {
    print("Gene could not been found, please verify that the gene name is correct")
    exit()
  }

  #return
  return(mart_save)

}
