# Import R packages needed for the UI
library(shiny)
library(dplyr)
library(tidyverse)

# ------------------ App virtualenv setup (Do not edit) ------------------- #

virtualenv_dir = Sys.getenv('VIRTUALENV_NAME')
python_path = Sys.getenv('PYTHON_PATH')

# Define any Python packages needed for the app here:
PYTHON_DEPENDENCIES = c('pip', 'biopython', 'Cython', 'primer3-py')

# Create virtual env and install dependencies
reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
reticulate::virtualenv_install(virtualenv_dir, packages = PYTHON_DEPENDENCIES, ignore_installed=TRUE)
reticulate::use_virtualenv(virtualenv_dir, required = T)

# --------------------------------- End ----------------------------------- #

# Source Python code
reticulate::source_python('Shiny_SLA_function.py')

# Begin UI for the R
ui <- fluidPage(
  
  titlePanel('SLA Primer Designer Tool'),
  
  sidebarLayout(
    
    # Sidebar with a text input
    sidebarPanel(
      helpText(paste('The following tool was implemented and edited by Aaron Yu (2022) using code originally written by Sam Beppler (2020).', 
                     'This tool picks the primers which yield the highest number of probes and the overall longest in 50 iterations or optimization.', 
                     'The Stem-Loop Assay is a qPCR method designed to detect the Guide Strand from the 3\' end.')
               ), 
      br(), 
      helpText(paste('Please enter the full Guide Strand (GS; Antisense Strand) sequence including the \'U\' overhangs.', 
                     'For example, an siRNA with a target antisense of \'AATTGTGCATTCCCGTGCA\' will have a final GS sequence of \'UAUUGUGCAUUCCCGUGCAUU\'.')
      ),
      br(), 
      helpText(paste('Please note, it is possible to get different primers using the same sequence.',
                     'This is due to to a pseudo-random generator for GC content and melting temperature.')
      ),
      hr(), 
      textAreaInput('GS', 
                    'Enter full GS sequences in the area below:', 
                    placeholder = 'Enter each GS on a separate line...', 
                    cols = 30, 
                    rows = 20
                    ),
      actionButton('getPrimers', 
                   'Calculate Primers!'
                   ), 
      hr(), 
      verbatimTextOutput('inputText')
    ),
    
    # Show primer output
    mainPanel(
      verbatimTextOutput('primerTable')
    )
  )
)

# Begin app server
server <- function(input, output) {
  
  # ------------------ App server logic (Edit anything below) --------------- #
  
  # Add reactive event to action button
  primers <- eventReactive(input$getPrimers, {
    in.in <- input$GS
    while(endsWith(in.in, '\n')) {
      in.in <- substring(in.in, 0, nchar(in.in) - length('\n')) %>% str_trim()
    }
    while(startsWith(in.in, '\n')) {
      in.in <- substring(in.in, length('\n'), nchar(in.in)) %>% str_trim()
    }
    sequences <- str_split(in.in, pattern = '\n') %>% unlist
    sequences.trimmed <- sequences[!is.na(sequences) & (sequences != '' | sequences != '\n' | sequences != ' ')]
    
    output$inputText <- renderText({
      paste('Your Input Text:', paste(sequences.trimmed, collapse = '\n'), sep = '\n')
    })
    
    primers.output <- lapply(sequences.trimmed, cross_check_sla)
    sequences.numbered <- paste(1:length(sequences.trimmed), sequences.trimmed, sep = '. ')
    table <- paste(sequences.numbered, lapply(primers.output, function (x) {
      spacer <- rep('\t', times = length(x))
      paste(spacer, x, sep = '', collapse = '\n')
    }), sep = '\n', collapse = '\n\n')
    return(table)
  })
  
  # Assign output text
  output$primerTable <- renderText({
    primers()
  })
  
}

shinyApp(ui, server)