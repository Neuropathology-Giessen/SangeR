#' @name plot_hist
#'
#' @title This function prints plots for all plots given by plot_hist()
#'
#' @param SangeR object from plot_hist function.
#'
#' @return no return, prints PNGs with histograms in working directory
#'
#' @export
#'


print_plots <-  function(SangeR){

  ####print mosaic

  mosaic <- gridExtra::grid.arrange(grobs = SangeR$PNG_list[!duplicated(substr(SangeR$tags,1,4))], ncol = 1)

  ggplot2::ggsave(filename = paste0(SangeR$Bnummer, "_", SangeR$genename, "_mosaic.png"), plot = mosaic)

  ###print mutated

  if(any(!SangeR$tags %in% SangeR$tags_POI)){
    mutated<- gridExtra::grid.arrange(grobs = SangeR$PNG_list[!SangeR$tags %in% SangeR$tags_POI], ncol = 1)

    ggplot2::ggsave(filename = paste0(SangeR$Bnummer, "_", SangeR$genename, "_mutated.png"), plot = mutated)
  }

  ###file for gene, block, mutation

  utils::write.csv2(quote = FALSE, row.names =  FALSE, x = c(SangeR$Bnummer, SangeR$genename, SangeR$tags[!SangeR$tags %in% SangeR$tags_POI]), file = paste0(SangeR$Bnummer, "_", SangeR$genename, ".txt"))

}
