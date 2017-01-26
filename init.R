library(DT)

source('../misc/funciones.R')
source('../misc/defs.R')

cursoActual <- '2016-2017'
semestreActual <- 2

dtOutput <- DT::dataTableOutput
renderDT <- DT::renderDataTable

## Profesores, obtenidos mediante scrapping con directorio.R
profesores <- readRDS('../docencia/profesores.Rds')

allProf <- lapply(seq_len(nrow(dptos)), function(i){
    codDpto <- dptos[i, "codigo"]
    data.frame(codDpto = codDpto,
               dpto = dptos[i, "nombre"],
               nombre = profesores[[codDpto]]["nombre"],
               stringsAsFactors = FALSE)
})
allProf <- do.call(rbind, allProf)

names(dptoCode) <- dptoName
