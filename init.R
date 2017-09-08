library(DT)

source('../misc/funciones.R')
source('../misc/defs.R')

cursoActual <- '2017-2018'
semestreActual <- 1

dtOutput <- DT::dataTableOutput
renderDT <- DT::renderDataTable

## Profesores de la ETSIDI
old <- setwd('../directorio')
profesores <- lapply(dptoCode,
                 FUN = function(dpto)
                     read.csv2(paste0(dpto, ".csv")))
names(profesores) <- dptoCode
setwd(old)

allProf <- lapply(seq_len(nrow(dptos)), function(i){
    codDpto <- dptos[i, "codigo"]
    data.frame(codDpto = codDpto,
               dpto = dptos[i, "nombre"],
               nombre = profesores[[codDpto]]["nombre"],
               stringsAsFactors = FALSE)
})
allProf <- do.call(rbind, allProf)

names(dptoCode) <- dptoName
