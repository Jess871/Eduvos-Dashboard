library(tidyverse)
library(shiny)

# Function to split and count values, get the top 10
split_count <- function(data, column) {
  data %>%
    select(!!sym(column)) %>%
    filter(!is.na(!!sym(column))) %>%
    separate_rows(!!sym(column), sep = ";") %>%
    group_by(!!sym(column)) %>%
    summarise(Count = n()) %>%
    arrange(desc(Count)) %>%
    top_n(10, Count)
}

# Function to create bar plots 
top_tools_plot <- function(df, title, y_label) {
  ggplot(df, aes(x = reorder(!!sym(names(df)[1]), Count), y = Count, fill = Count)) +
    geom_bar(stat = "identity", show.legend = FALSE) +
    scale_fill_gradient(low = "#D8BFD8", high = "#4B0082") +  
    coord_flip() +
    labs(title = title, x = y_label, y = "Usage Count") +
    theme_minimal() +
    theme(axis.title.x = element_text(size = 16, margin = margin(t = 20)),
          axis.title.y = element_text(size = 16, margin = margin(r = 20)),
          axis.text = element_text(size = 10),
          plot.title = element_text(size = 20, face = "bold", hjust = 0.5, margin = margin(b = 10)))
}

# Define UI
iu <- function() {
  fluidPage(
    tags$h1("Eduvos IT Graduates Survey Dashboard", style = "font-weight: bold;"),
    tags$div(style = "margin-top: 70px;"),
    sidebarLayout(
      sidebarPanel(
        selectInput("category", "Select Category:",
                    choices = c("Top Programming Languages used by Graduates" = "ProgLang",
                                "Top Databases used by Graduates" = "Databases",
                                "Top Cloud Platforms used by Graduates" = "Platform",
                                "Top Web Frameworks used by Graduates" = "WebFramework",
                                "Top AI Search Tools used by Graduates" = "AISearch",
                                "Top AI Developer Tools used by Graduates" = "AITool",
                                "Top Industries Graduates Work In" = "Industry",
                                "Top Job Roles Graduates Work In" = "Role",
                                "Employment Rate of Graduates according to their Study Field" = "EmploymentRate")),
        width = 3
      ),
      mainPanel(
        plotOutput("barPlot", height = "600px")
      )
    )
  )
}

# Define server logic
server <- function(input, output) {
  data <- read_csv("C:/Users/jessb/Downloads/cleaned_data.csv", show_col_types = FALSE)
  
  output$barPlot <- renderPlot({
    category <- input$category
    
    if (category == "EmploymentRate") {
      employment_rate <- data %>%
        group_by(StudyField) %>%
        summarise(
          total_graduates = n(),
          employed_graduates = sum(grepl("Employed, full-time|Employed, part-time", Employment))
        ) %>%
        mutate(
          employment_rate = (employed_graduates / total_graduates) * 100
        )
      
      ggplot(employment_rate, aes(x = StudyField, y = employment_rate, fill= StudyField)) +
        geom_bar(stat = "identity") +
        labs(title = "Employment Rate of Graduates from various Study Fields",
             x = "Field of Study",
             y = "Employment Rate in Percentage") +
        theme_minimal() +
        theme(legend.position = "none",
              axis.title.x = element_text(size = 16, margin = margin(t = 20)),
              axis.title.y = element_text(size = 16, margin = margin(r = 20)),
              axis.text = element_text(size = 10),
              plot.title = element_text(size = 20, face = "bold", hjust = 0.5, margin = margin(b = 10))) +
        geom_text(aes(label=paste0(round(employment_rate, 1), "%")), vjust = -0.5) +
        scale_fill_manual(values = c("#4B0082", "#9370DB", "#D8BFD8"))
      
    } else {  
      top_data <- split_count(data, category)
      title_map <- list(
        "ProgLang" = "Top Programming Languages Among Graduates",
        "Databases" = "Top Databases Among Graduates",
        "Platform" = "Top Cloud Platforms Among Graduates",
        "WebFramework" = "Top Web Frameworks Among Graduates",
        "AISearch" = "Top AI Search Tools Among Graduates",
        "AITool" = "Top AI Developer Tools Among Graduates",
        "Industry" = "Top Industries Among Graduates",
        "Role" = "Top Job Roles Among Graduates"
      )
      
      y_label_map <- list(
        "ProgLang" = "Programming Languages",
        "Databases" = "Databases",
        "Platform" = "Cloud Platforms",
        "WebFramework" = "Web Frameworks",
        "AISearch" = "AI Search Tools",
        "AITool" = "AI Developer Tools",
        "Industry" = "Industries",
        "Role" = "Roles"
      )
      
      plot_title <- title_map[[category]]
      y_label <- y_label_map[[category]]
      
      top_tools_plot(top_data, plot_title, y_label)
    }
  })
}

# Run the application
shinyApp(ui = iu(), server = server)
