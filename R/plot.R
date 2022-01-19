#' @name plot_hist
#'
#' @title This function produces plots for all containing tags
#'
#' @param SangeR object from allign function.
#' @param POI file with list of points of interest
#'
#' @return Objekt with plots for the given tags
#'
#' @export
#'



plot_hist <- function(SangeR, POI){

  #global Variables
  position <- Values <- Samples <- NULL


  #chromatogramm

  #get values for chromatogram
  #order of channels
  channel_order <- SangeR$abif@data$FWO_.1

  #build data frome for histogramm
  #pool channels in data frame
  data <- data.frame(1:length(SangeR$abif@data$DATA.9), SangeR$abif@data$DATA.9, SangeR$abif@data$DATA.10, SangeR$abif@data$DATA.11, SangeR$abif@data$DATA.12)
  colnames(data) <- c("position",stringr::str_split(channel_order,"")[[1]])

  #add basecalls
  basecalls <- data.frame(SangeR$abif@data$PLOC.1, unlist(strsplit(SangeR$abif@data$PBAS.1, ""))[1:nchar(SangeR$abif@data$PBAS.1)-1])
  colnames(basecalls) <- c("position", "basecall")
  data[basecalls$position,"basecall"] <- basecalls$basecall

  #points of interest

  if (!missing(POI)){

    POI <- utils::read.table(POI)
    SangeR$tags_POI <- c()

    for(point in unlist(POI)){

      chr <- as.numeric(strsplit(point,":")[[1]][1])
      chr_pos <- as.numeric(strsplit(point,":")[[1]][2])
      pos <- as.numeric(strsplit(point,":")[[1]][2])
      end <- ifelse(SangeR$ref_pos$strand==-1,SangeR$ref_pos$end_position+SangeR$upstream+1,SangeR$ref_pos$end_position-1)
      start <- ifelse(SangeR$ref_pos$strand==1,SangeR$ref_pos$start_position-SangeR$upstream-1,SangeR$ref_pos$start_position+1)
      tags <- c()

      if(chr == SangeR$ref_pos$chromosome_name){ if(any((SangeR$pep_info$exon_chrom_start<chr_pos) == (SangeR$pep_info$exon_chrom_end>chr_pos))) {


        #write tag for protein region
        if(SangeR$strand == "forward"){

          #for forward strand

          if(SangeR$ref_pos$strand == 1){
            boolean <- (SangeR$pep_info$exon_chrom_start<chr_pos)

            AA_pos <- ceiling((sum(SangeR$pep_info$length[boolean],na.rm = TRUE) - (SangeR$pep_info$exon_chrom_end[(SangeR$pep_info$exon_chrom_start<chr_pos) == (SangeR$pep_info$exon_chrom_end>chr_pos)] - as.numeric(chr_pos)))/3)

            Aa <- stringr::str_sub(SangeR$ref_amino$peptide, AA_pos, AA_pos)

            tags <- c(tags, paste0(Aa, sprintf("%03d", AA_pos),"wt"))
            SangeR$mutations_ref <- c(SangeR$mutations_ref, end - pos)


          } else{
            #IDH1

            boolean <- (SangeR$pep_info$exon_chrom_end<chr_pos)
            boolean[which((SangeR$pep_info$exon_chrom_start<chr_pos) == (SangeR$pep_info$exon_chrom_end>chr_pos))] <- FALSE

            AA_pos <- ceiling((sum(SangeR$pep_info$length[!boolean],na.rm = TRUE) - (as.numeric(chr_pos) - SangeR$pep_info$exon_chrom_start[(SangeR$pep_info$exon_chrom_start<chr_pos) == (SangeR$pep_info$exon_chrom_end>chr_pos)]))/3)

            Aa <- stringr::str_sub(SangeR$ref_amino$peptide, AA_pos, AA_pos)

            tags <- c(tags, paste0(Aa[1], sprintf("%03d", AA_pos), "wt"))
            SangeR$mutations_ref <- c(SangeR$mutations_ref, end - pos)

          } } else {

            #for reverse strand

            boolean <- (SangeR$pep_info$exon_chrom_end>chr_pos)
            boolean[which((SangeR$pep_info$exon_chrom_start<chr_pos) == (SangeR$pep_info$exon_chrom_end>chr_pos))] <- FALSE

            AA_pos <- ceiling((sum(SangeR$pep_info$length[boolean]) + (SangeR$pep_info$exon_chrom_end[(SangeR$pep_info$exon_chrom_start<chr_pos) == (SangeR$pep_info$exon_chrom_end>chr_pos)]) - as.numeric(chr_pos))/3)

            Aa <- stringr::str_sub(SangeR$ref_amino$peptide, AA_pos, AA_pos)

            tags <- c(tags, paste0(Aa, sprintf("%03d", AA_pos), "wt"))
            SangeR$mutations_ref <- c(SangeR$mutations_ref, end - pos)

          }

        SangeR$tags <- c(SangeR$tags, tags)
        SangeR$mutations_ref <- unique(c(SangeR$mutations_ref, end - pos))

      } else {

        #write tag for off-region
        tags <- paste0(substr(SangeR$ref_seq$gene_exon_intron,end-pos,end-pos),substr(point,nchar(point)-2,nchar(point)),"wt")
        SangeR$tags_POI <- c(SangeR$tags_POI, tags)
        SangeR$mutations_ref_POI <- c(SangeR$mutations_ref, end - pos)
        SangeR$tags <- unique(c(SangeR$tags, tags))
        SangeR$mutations_ref <- unique(c(SangeR$mutations_ref, end - pos))

      }
    }}
  }

  #region of interest

  if(length(SangeR$mutations_ref) != 0){

    #create counter and create vat for used file paths

    PNG_list <- list()
    cnt <- 1

    for(mut in SangeR$mutations_ref){

      #mutation position in abi1 file
      pos <- mut - SangeR$abi_align@subject@range@start + 1

      #check if position is on the borders of the sequence
      if(pos > 6 && pos < (length(basecalls$position)-5)){

        #Pick region of interest
        ROI <- data[(SangeR$abif@data$PLOC.1[(pos-5)]):SangeR$abif@data$PLOC.1[(pos+5)],]
        ROI_melt <- reshape2::melt(ROI, id.vars=c("position", "basecall"),  variable.name = "Samples", value.name="Values", na.rm = FALSE)

        #print plot
        plot <- ggplot2::ggplot(ROI_melt, ggplot2::aes(position, Values)) +
                  ggplot2::scale_x_continuous(breaks = data$position[!is.na(data$basecall)], labels =  data$basecall[!is.na(data$basecall)]) +
                  ggplot2::geom_line(ggplot2::aes(color=as.factor(Samples)),size = 1) +
                  ggplot2::scale_color_discrete(name = "nucleotide") +
                  ggplot2::labs(title = paste0(SangeR$genename, " ", SangeR$tags[cnt])) +
                  ggplot2::theme_bw() +
                  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5,size = 16))

        #write plot to plot_list
        PNG_list[[cnt]] <- plot
        cnt <- cnt+1

      }
    }
    SangeR$PNG_list <- PNG_list
  }  else{

    print("no mutations")
    SangeR$PNG_list <- NULL

  }


  return(SangeR)
}
