library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Some Iris in Random Forests"), sidebarPanel(
    sliderInput('ntree', 'Size of the Forest', 25, min = 10, max = 50, step = 5),
    actionButton("SubmitButton", 'Compute the Forest'),
    numericInput('i', 'Choose a Tree in the forest', 1, min = 10, max = 50, step = 1),
    actionButton("ShowButton", 'Show Tree'),
    numericInput('sl', "Enter Sepal Length", 0, min = 0, max = 10),
    numericInput('sw', "Enter Sepal Width", 0, min = 0, max = 10),
    numericInput('pl', "Enter Petal Length", 0, min = 0, max = 10),
    numericInput('pw', "Enter Petal Width", 0, min = 0, max = 10),
    actionButton("GuessButton", 'Guess Species'),
    actionButton("Help", "Get Help")
  ),
  mainPanel(
      mainPanel( 
        h2("Species (Rows) vs Predictions (Cols)"),
        tableOutput('summary'), 
        h2("Display Tree"),
        plotOutput('tree'),
        h2("Prediction Result"),
        textOutput('guess'),
        h2("Short Help"),
        textOutput('help')
      )
  ) ))