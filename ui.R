library(shiny)
library(shinyjs)

source('init.R')


## Cabecera con logos
header <- fluidRow(
    column(4, align = 'center', img(src = logoUPM, width = 72)),
    column(4, align = 'center',
           h2("Actividad Docente y Tutorías"),
           h4(paste0("Curso ", cursoActual, " (",
                     c('Septiembre - Enero',
                       'Febrero - Julio',
                       'Verano')[semestreActual],
                     ")")),
           h5("Subdirección de Ordenación Académica")),
    column(4, align = 'center', img(src = logoETSIDI, width = 72))
)

## UI de profesor
profesorUI <- wellPanel(
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


## UI de actividad docente
docenciaUI <- div(
    id = 'docencia',
    h3("Actividad Docente"),
    fluidRow(
        column(12,
               dtOutput("tablaDocencia")
               )),
    hr()
)

## UI de tutorías
tutoriaUI <- div(
    id = 'tutoria',
    h3("Tutorías"),
    fluidRow(
        column(12,
               dtOutput("tablaTutoria"))
    ),
    hr()
)

## UI de TFG-TFM
TFGUI <- div(
    id = 'tfg',
    h3("TFG / TFM"),
    fluidRow(
        column(12,
               dtOutput("tablaTFG"))
    ),
    hr()
)


## UI de cierre
resultUI <- div(
    id = 'result',
    fluidRow(
        column(3,
               downloadButton2('dExcel', 'Excel', 'file-excel-o')
               ),
        column(3,
               downloadButton2('dPDF', 'PDF', 'file-pdf-o')
               ),
        column(2,
               downloadButton2('dDocencia', 'Docencia', 'table')
               ),
        column(2,
               downloadButton2('dTutoria', 'Tutoria', 'table')
               ),
        column(2,
               downloadButton2('dTFG', 'TFG / TFM', 'table')
               )
    ))

## UI de profesor vacio
missingUI <- div(
    id = 'missing',
    fluidRow(
        column(12,
               p("El profesor seleccionado no ha cumplimentado sus horarios docentes y de tutorías, o no han sido publicados por la Dirección de su departamento.")
               )),
    hr()
)

 
## UI completa
shinyUI(
    fluidPage(
        useShinyjs(),
        includeCSS("styles.css"),
        header,
        profesorUI,
        hidden(missingUI),
        hidden(resultUI),
        hidden(docenciaUI),
        hidden(tutoriaUI),
        hidden(TFGUI)
    )
)
