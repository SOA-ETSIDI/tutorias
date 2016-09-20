library(shiny)
library(shinyjs)
library(openssl)
library(openxlsx)
library(stringi)

source('init.R')

shinyServer(function(input, output, session) {
    values <- reactiveValues()
    observe(
    {
        dpto <- input$dpto
        if (dpto != "")
        {## Actualiza selector de profesores si se elige un departamento
            profes <- titlecase(profesores[[dpto]]$nombre)
            updateSelectInput(session, "nombre",
                              choices = c("", profes))
        }
        else
        {## Si no se elige ningún departamento, entran todos los profesores.
            updateSelectInput(session, "nombre",
                              choices = c("", titlecase(allProf$nombre)))
        }
    })

    observe(
    {
        ## Leo los ficheros del profesor elegido
        profe <- input$nombre
        ## Elimino caracteres no letras y no ascii para nombre de fichero
        values$profe <- stri_trans_general(
            gsub("[^[:alpha:]]", "_", profe),
            'latin-ascii')
        values$hash <- hash <- md5(toupper(profe))
        path <- '../docencia/pub/'
        ## Docencia
        docFile <- paste0(path, 'docencia_', hash, '.csv')
        if (file.exists(docFile))
        {
            values$docencia <- read.csv2(docFile,
                                         stringsAsFactors = FALSE)
            ## Tutoría (asumo que si existe el fichero de docencia
            ## también existe el de tutoria)
            tutFile <- paste0(path, 'tutoria_', hash, '.csv')
            values$tutoria <- read.csv2(tutFile,
                                        stringsAsFactors = FALSE)
            ## TFG (pero puede que no exista el de TFG)
            TFGFile <- paste0(path, 'TFG_', hash, '.csv')
            if (file.exists(TFGFile))
                values$TFG <- read.csv2(TFGFile,
                                        stringsAsFactors = FALSE)
            else values$TFG <- data.frame()

            ## Muestro la UI de docencia
            show(id = "docencia", anim = TRUE)
            show(id = "tutoria", anim = TRUE)
            show(id = "tfg", anim = TRUE)
            show(id = "result", anim = TRUE)
        } else {
            hide(id = "docencia", anim = TRUE)
            hide(id = "tutoria", anim = TRUE)
            hide(id = "tfg", anim = TRUE)
            hide(id = "result", anim = TRUE)
        }
    })

    ## Muestra actividades registradas del profesor elegido
    output$tablaDocencia <- renderDT(
        values$docencia[, c('Titulacion', 'Asignatura', 'Grupo',
                            'Dia', 'HoraInicio', 'HoraFinal',
                            'Tipo', 'Inicio', 'Final')],
        colnames = c('Titulación',
                     'Asignatura',
                     'Grupo de Matriculación',
                     'Dia', 'Desde', 'Hasta',
                     'Tipo de Docencia',
                     'Semana Inicial',
                     'Semana Final'),
        rownames = FALSE,
        options = list(
            autoWidth = TRUE,
            dom = 'tp',
            language = list(url = '//cdn.datatables.net/plug-ins/1.10.7/i18n/Spanish.json'))
    )

    ## TUTORIAS
    output$tablaTutoria <- renderDT(
        values$tutoria[, c('Despacho', 'Dia', 'Desde', 'Hasta')],
        rownames = FALSE,
        ## filter = 'top',
        options = list(
            autoWidth = TRUE,
            dom = 't',
            language = list(url = '//cdn.datatables.net/plug-ins/1.10.7/i18n/Spanish.json'))
    )
    
    ## TFG
    output$tablaTFG <- renderDT(
        values$TFG[, c('Despacho', 'Dia', 'Desde', 'Hasta')],
        rownames = FALSE,
        options = list(
            autoWidth = TRUE,
            dom = 't',
            language = list(url = '//cdn.datatables.net/plug-ins/1.10.7/i18n/Spanish.json'))
    )
    
    ## Descarga de ficheros: copio de los originales
    output$dDocencia <- downloadHandler(
        filename = function()
        {
            paste0('docencia_', values$profe, '.csv')
        },
        content = function(file)
        {
            file.copy(paste0('../docencia/pub/docencia_',
                             values$hash, '.csv'),
                      file)
        }
    )
    output$dTutoria <- downloadHandler(
        filename = function()
        {
            paste0('tutoria_', values$profe, '.csv')
        },
        content = function(file)
        {
            file.copy(paste0('../docencia/pub/tutoria_',
                             values$hash, '.csv'),
                      file)
        }
    )
    output$dTFG <- downloadHandler(
        filename = function()
        {
            paste0('TFG_', values$profe, '.csv')
        },
        content = function(file)
        {
            file.copy(paste0('../docencia/pub/TFG_',
                             values$hash, '.csv'),
                      file)
        }
    )
    output$dPDF <- downloadHandler(
        filename = function()
        {
            paste0(values$profe, '.pdf')
        },
        content = function(file)
        {
            file.copy(paste0('../docencia/pub/', values$hash, '.pdf'),
                      file)
        }
    )
    output$dExcel <- downloadHandler(
        filename = function()
        {
            paste0(values$profe, '.xls')
        },
        content = function(file)
        {## Genero un libro excel a partir de los csv
            dfs <- list(values$docencia,
                        values$tutoria,
                        values$TFG)
            names(dfs) <- c('Docencia', 'Tutoria', 'TFG')
            xls <- write.xlsx(dfs, file)
        }
    )
})
