library(DT)

source('../misc/funciones.R')
source('../misc/defs.R')

cursoActual <- '2017-2018'
semestreActual <- 1

dtOutput <- DT::dataTableOutput
renderDT <- DT::renderDataTable

## Profesores de la ETSIDI
old <- setwd('../directorio')
source('leeProfes.R')
setwd(old)

names(dptoCode) <- dptoName
