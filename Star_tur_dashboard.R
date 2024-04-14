library(shiny)
library(plotly)
library(readxl)
library(dplyr)

# Предполагается, что путь к вашему файлу будет другим
path_to_excel <- "path/to/your/excel/file.xlsx"

# UI
ui <- fluidPage(
  titlePanel("События на временной оси"),
  plotlyOutput("eventPlot")
)

# Server logic
server <- function(input, output) {
  
  output$eventPlot <- renderPlotly({
    # Чтение данных
    events_data <- read_excel(path_to_excel)
    
    # Можно добавить преобразования и фильтрацию данных здесь, если необходимо
    
    # Создание графика
    p <- events_data %>%
      group_by(event) %>%
      plot_ly(x = ~data_start, y = ~event, name = ~event, type = 'scatter', mode = 'markers',
              text = ~log_event, hoverinfo = 'text', marker = list(size = 10)) %>%
      add_lines(x = ~data_start, y = ~event, showlegend = FALSE, mode = 'lines',
                line = list(color = 'grey', width = 0.5))
    
    p <- p %>% layout(title = 'События по времени',
                      xaxis = list(title = 'Дата'),
                      yaxis = list(title = 'Событие'))
    
    return(p)
  })
}

# Запуск приложения
shinyApp(ui = ui, server = server)
