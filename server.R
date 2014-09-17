library(shiny) 
library(foreign)
library(party)
library(datasets)
library(xtable)

process <- function(ntree, pcttrain) {
  cf <- cforest(Species ~ ., data = iris, control=cforest_unbiased(ntree=ntree, mtry=4)) 
  cf
}
displayTree <- function(cf, idx) {
  len <- length(cf@ensemble)
  pt <- party:::prettytree(cf@ensemble[[idx]], names(cf@data@get("input"))) 
  pt 
  nt <- new("BinaryTree") 
  nt@tree <- pt 
  nt@data <- cf@data 
  nt@responses <- cf@responses 
  nt
}
shinyServer(
  function(input, output, session) {
    output$summary <- renderTable({
      input$SubmitButton
      isolate({
        set.seed(120864)
        cf <<- process(input$ntree, input$pcttrain)
        observe({
          updateNumericInput(session, "i", label = paste('Choose a Tree in the forest (max = ', input$ntree, ")"), 1, min = 1, max = input$ntree, step = 1)
        })
        x <- xtable(table(iris$Species, predict(cf, OOB=TRUE)), sanitize.text.function = function(x) x)
        caption(x, "Species (rows) vs. Forest Predictions (cols)")
        x
      })
    })
    output$guess <- renderText({
      input$GuessButton
      isolate({ 
        species <- predict(cf, newdata=data.frame(Sepal.Length=input$sl, Sepal.Width=input$sw, Petal.Length=input$pl, Petal.Width=input$pw), type = "response")
        paste("The Species for the Entered Measures is: ", species)
      })
    })
    output$help <- renderText({
      input$HelpButton
      "The project is based on the Iris Data Set.\n1. You can choose the number of trees in the random forest.\n2. You can display any tree of the random forest.\n3. Enter the Data for a prediction based on the current forest."
    })
    output$tree <- renderPlot({
      input$ShowButton
      isolate({
        if (input$i >= 1 && input$i <= input$ntree) {
          plot(displayTree(cf, input$i))          
        }        
      })
    })
  } )