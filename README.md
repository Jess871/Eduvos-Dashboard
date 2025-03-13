# Eduvos IT Graduates Survey Dashboard

This Shiny dashboard analyzes survey data from Eduvos IT graduates to identify their most used
programming languages, databases, web frameworks, and other tech tools.

## Dashboard Layout and Design

The dashboard features a sidebar with a dropdown menu for category selection
and a main panel to display the corresponding bar plot.

## Data Visualization

The dashboard includes various visualizations for:
- The top programming languages used among graduates
- The top databases used among graduates
- The top cloud platforms used among graduates
- The top web frameworks used among graduates
- The top AI search tools used among gradates
- The top AI search tools used among gradutes
- The top industries graduates work in
- The top job roles help by graduates
- The employment rate of gradutes based on their study field.

## Interactivity

Users can choose the category they wish to analyze by using the dropdown menu, 
and the bar plot on the main panel will adjust accordingly

## Documentation

### Code Documentation

#### The dashboard's user interface and server logic are defined in the 'app.R' file. 
The dashboard displays the title, sidebar, and main panel and loads the cleaned data,
processes it by the chosen category, and generates the corresponding bar graph.

### User Guide

1. Select a category from the sidebar's dropdown menu.
2. The bar graph in the main panel will update and display the top 10 most used 
tools, technologies, or fields related to the selected category.
3. If "Employment Rate of Graduates according to their Study Field" is selected, 
the bar plot will show the employment rate of graduates from their various study fields.
