library(shiny)
library(shinyjs)

## ACTIVO MODO VERANO
semestre <- 3

source('init.R')


logoUPM <- "http://www.upm.es/sfs/Rectorado/Gabinete%20del%20Rector/Logos/UPM/EscPolitecnica/EscUpmPolit_p.gif"
logoETSIDI <- "http://www.upm.es/sfs/Rectorado/Gabinete%20del%20Rector/Logos/EUIT_Industrial/ETSI%20DISEN%C2%A6%C3%A2O%20INDUSTRIAL%20pqn%C2%A6%C3%A2.png"


## Cabecera con logos
header <- fluidRow(
    column(4, align = 'center', img(src = logoUPM)),
    column(4, align = 'center',
           h2("Tutorías del profesorado"),
           h4(paste0("Curso 2015-2016 (",
                     c('Septiembre - Enero',
                       'Febrero - Junio',
                       'Verano')[semestre],
                     ")")),
           h5("Subdirección de Ordenación Académica")),
    column(4, align = 'center', img(src = logoETSIDI))
)

selector <- wellPanel(
    fluidRow(
        column(6,
               selectInput('nombre', label = 'Nombre del profesor:',
                           choices = c("", titlecase(allProf$nombre)))
               ),
        column(6,
               h3(""),
               p('Elige un profesor desplazándote por la lista desplegable, o teclea algunas letras de su nombre para delimitar las opciones.'))
        ),
    fluidRow(
        column(6,
               selectInput('dpto', label = 'Departamento:',
                           choices = c("", dptoCode))
               ),
        column(6,
               h3(""),
               p('Si quieres, puedes filtrar por el Departamento al que pertenece.')
               )
    ),
    fluidRow(
        column(6),
        column(6,
               p('Puedes consultar los datos de contacto del profesorado en el ',
               a(href = "http://www.etsidi.upm.es/ETSIDI/Escuela/Directorio", target="_blank", 'directorio'),
               '.')
               )
    ))


result <- wellPanel(
    fluidRow(
        column(12,
               uiOutput('tutoria'))
    ),
    fluidRow(
        column(12,
               div(id = 'botonPDF',
                   downloadButton2('dPDF', 'PDF', 'file-pdf-o'))
               )
    )
)

## UI completa
shinyUI(
    fluidPage(
        useShinyjs(),
        includeCSS("styles.css"),
        header,
        selector,
        result
    )
)

