library(gridExtra)

#' @name ui
#' @title User Interface
#' @export
#'



# Define UI for SangeR app
ui <- shiny::fluidPage(

  shiny::shinyUI(shiny::navbarPage('SangeR', id="page",

    #tool tab
    shiny::tabPanel("tool",

      # App title
      shiny::titlePanel(shiny::tags$a(shiny::tags$img(src = "https://github.com/kaischmid/SangeR/raw/master/data/logo.png"))),

      # Sidebar layout with input and output definitions
      shiny::sidebarLayout(


        # Sidebar panel for inputs
        shiny::sidebarPanel(

          # Input: Select a file
          shiny::fileInput("file1", "Choose ab1 File",
                    multiple = FALSE),

          #Input: delimiter
          shiny::textInput(inputId = "delimiter",
                           label = "delimiter in ab1 file", value = "_", placeholder = "_"),


          # Input for genename
          shiny::selectizeInput(inputId = "genename",
                             label = "genename",
                             multiple =  FALSE,
                             choices = NULL),

          # Input: Select a POI
          shiny::fileInput("file2", "Choose POI File",
                    multiple = FALSE),

          # Horizontal line
          shiny::tags$hr(),
          shiny::tags$label("Read in parameter"),

          # Input for offset
          shiny::sliderInput(inputId = "offset",
                      label = "offset:",
                      min = 1,
                      max = 50,
                      value = 33),

          # Input for minimal sequence length
          shiny::sliderInput(inputId = "min_seq_len",
                      label = "minimum sequence length:",
                      min = 1,
                      max = 50,
                      value = 20),

          # Input for cutoff
          shiny::sliderInput(inputId = "cutoff",
                      label = "cutoff:",
                      min = 0.001,
                      max = 0.3,
                      value = 0.05),

          # Input for upstram region
          shiny::sliderInput(inputId = "upstream",
                      label = "upstream:",
                      min = 0,
                      max = 2000,
                      value = 500),

          # Horizontal line ----
          shiny::tags$hr(),
          shiny::tags$label("Host parameter"),

          #Input for host
          shiny::selectInput(
            inputId = "host",
            label = "host",
            choices = c("grch37.ensembl.org","www.ensembl.org"),
          ),

          #download button
          shiny::downloadButton(outputId = "down", label = "Download Chromatogramm")

        ),

        # Main panel for displaying outputs
        shiny::mainPanel(

          # Output: Histogram ----
          shiny::plotOutput(outputId = "distPlot")

        )
      )
    ),shiny::tabPanel("Impressum",
      shiny::mainPanel(
        shiny::htmlOutput("text")

      )
    )
  ))
)

#' @name server
#' @title Server
#' @param input input for shiny ui
#' @param output output from shiny ui
#' @export
#'

# Define server logic required to draw a histogram
server <- function(input, output, session) {



  # Histogram

  plotInput <- shiny::reactive({

    if(!is.null(input$file1)){
      if(!is.null(input$file2)){
        histograms <- sangeR::plot_hist(sangeR::allign(sangeR::get_ref(sangeR::read.ab1(filename = input$file1$datapath, delimiter = input$delimiter, genename = input$genename, cutoff = input$cutoff, min_seq_len = input$min_seq_len, offset = input$offset),upstream = input$upstream, host = input$host)), POI = input$file2$datapath)
      } else {
        histograms <- sangeR::plot_hist(sangeR::allign(sangeR::get_ref(sangeR::read.ab1(filename = input$file1$datapath, delimiter = input$delimiter, genename = input$genename, cutoff = input$cutoff, min_seq_len = input$min_seq_len, offset = input$offset),upstream = input$upstream, host = input$host)))
      }
      if(!length(histograms$PNG_list) == 0){
        print(histograms$tags)
        do.call("grid.arrange", c(histograms$PNG_list, ncol=1))
      } else {stop(paste0("Could not find any mutations. Check in for a POI or less strict parameters."))}
    }
  })




  output$distPlot <- shiny::renderPlot({

    if(!is.null(input$file1)){
      gg <- print(plotInput())
      print(gg)
    }
  })

  shiny::observeEvent(eventExpr = "file1",{shinyjs::reset("genename")})

  #genename select

  shiny::updateSelectizeInput(session, "genename", choices = readRDS(system.file("data","genenames.rds",package = "sangeR")), server = TRUE, selected = "hgnc_symbol")
  shiny::observeEvent(input$buttonid,
               {
                 shiny::updateSelectizeInput(session, "genename",
                                      server = TRUE,
                                      choices = readRDS(system.file("data","genenames.rds",package = "sangeR")))
               })



  #download of png
  output$down <- shiny::downloadHandler(
    filename = "test.png",
    content = function(file){

      ggplot2::ggsave(file, plot = plotInput(),device = "png",width = 20)
    })


  output$text <- shiny::renderText({
        "<font color=\"#FF0000\">Dieses Impressum befindet sich derzeit noch in der rechtlichen Pruefung!<br/><br/></font>

        <h1>Impressum</h1><br/><br/>
        Erstellt durch:\n<br/><br/>
        Dr. rer. nat. Daniel Amsel\n<br/><br/>
        Institut fuer Neuropathologie, Fachbereich Medizin Justus-Liebig-Universitaet Giessen\n<br/>
        Institut fuer Neuropathologie Giessen<br/>
        Fachbereich Medizin der Justus-Liebig-Universitaet Giessen, Rudolf-Buchheim-Str. 6, 35392 Giessen<br/>
        Tel. +49 (0) 641 99 41181<br/>
        E-Mail: Till.Acker@patho.med.uni-giessen.de<br/><br/>
        <b>Vertreten durch:</b><br/>
        Prof. Dr. med. Till Acker\n<br/>
        <b>Inhaltlich verantwortlich:</b><br/>
        Prof. Dr. med. Till Acker"})
}

# Create Shiny app ----
shiny::shinyApp(ui = ui, server = server)
