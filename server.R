library(shiny)
library(shinyjs)
library(openssl)

source('init.R')

shinyServer(function(input, output, session) {
    values <- reactiveValues()
    observe({
        dpto <- input$dpto
        if (dpto != "")
        {
            profes <- titlecase(profesores[[dpto]]$nombre)
            updateSelectInput(session, "nombre",
                              choices = c("", profes))
        }
        else
        {
            updateSelectInput(session, "nombre",
                              choices = c("",
                                          titlecase(allProf$nombre)))
        }
    })
    observe(
    {
        profe <- input$nombre
        values$hash <- hash <- md5(toupper(profe))
        fDocencia <- paste0('../docencia/pub/docencia_',
                            hash, '.csv')
        if (file.exists(fDocencia))
            values$docencia <- read.csv2(fDocencia,
                                         stringsAsFactors = FALSE)
        else values$docencia <- data.frame()

        fTutoria <- paste0('../docencia/pub/tutoria_',
                           hash, '.csv')
        if (file.exists(fTutoria))
            values$tutoria <- read.csv2(fTutoria,
                                        stringsAsFactors = FALSE)
        else values$tutoria <- data.frame()

        fTFG <- paste0('../docencia/pub/TFG_',
                       hash, '.csv')
        if (file.exists(fTFG))
            values$TFG <- read.csv2(fTFG,
                                    stringsAsFactors = FALSE)
        else values$TFG <- data.frame()
    })
    
    output$tutoria <- renderUI(
    {
        if (nrow(values$tutoria) > 0)
        {
            show("botonPDF")
            if (nrow(values$TFG) > 0)
            {
                values$tutoria$Tipo <- ''
                values$TFG$Tipo <- 'TFG'
                tutoria <- rbind(values$tutoria, values$TFG)
            }
            else
            {
                values$tutoria$Tipo <- ""
                tutoria <- values$tutoria
            }
            tutDia <- split(tutoria[, c("Despacho", "Desde", "Hasta", "Tipo")],
                             tutoria$Dia)
            tutDia <- tutDia[order(factor(names(tutDia),
                                            levels = dias))]

            tutStr <- lapply(seq_along(tutDia), function(i)
            {
                dia <- h4(names(tutDia)[i])
                item <- tutDia[[i]]
                item <- item[order(item$Desde),]
                item <- with(item,
                             paste0(
                                 Desde, ' a ', Hasta,
                                 ifelse(Tipo == "TFG", " <strong>[TFG/TFM]</strong> ", ""),
                                 ' (Despacho ', Despacho, ')'))
                item <- tags$ul(lapply(item, function(x)tags$li(HTML(x))))
                list(dia, item, br())
            })
            tags$div(tutStr)
        } else
        {
            hide('botonPDF')
            if (input$nombre =="") HTML("Elija un profesor para mostrar sus horarios de tutorías.")
            else HTML("No existe información sobre los horarios de tutoría de este profesor.")
        }
    })
    output$dPDF <- downloadHandler(
        filename = function()
        {
            paste0(values$hash, '.pdf')
        },
        content = function(file)
        {
            file.copy(paste0('../docencia/pub/', values$hash, '.pdf'),
                      file)
        }
    )
})
