library(DT)

source('../misc/funciones.R')
source('../misc/defs.R')

dtOutput <- DT::dataTableOutput
renderDT <- DT::renderDataTable

## Profesores de la ETSIDI
old <- setwd('../directorio')
source('leeProfes.R')
setwd(old)

names(dptoCode) <- dptoName
