source('../aux/funciones.R')
source('../aux/defs.R')

## Profesores, obtenidos mediante scrapping con directorio.R
profesores <- readRDS('../data/profesores.Rds')

allProf <- lapply(seq_len(nrow(dptos)), function(i){
    codDpto <- dptos[i, "codigo"]
    data.frame(codDpto = codDpto,
               dpto = dptos[i, "nombre"],
               nombre = profesores[[codDpto]]["nombre"],
               stringsAsFactors = FALSE)
})
allProf <- do.call(rbind, allProf)

names(dptoCode) <- dptoName
