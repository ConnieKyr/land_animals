#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Body weight and brain weight of 65 land animals"),
  h3("Find out how well the body weight of a land animal predicts its brain weight!"),
  h4("Based on the R dataset Animals {MASS} and Animals2 {robustbase}, a dataset containing the average brain and body weights 
         for 62 species of land mammals and three dinosaur species, we fit simple regression lines to various subgroups, and identify outliers with Cook's distance."),
  sidebarLayout(
    sidebarPanel(
      h5("Please choose a subgroup of the available animals. There are 65 species, three of which are dinosaurs, 10 of which rodents and 10 of which primates. 
         You will see the regression line on the right and a summary of the model below."),
      radioButtons("animal_group", "Regression on the groups of:",
                   c("All animals" = "all",
                     "Exclude dinosaurs" = "nodino",
                     "Rodents only" = "rod",
                     "Primates only" = "prim")),
      checkboxInput("labelled", "Label the animals", FALSE),
      submitButton("Submit")
      
    ),
    
    mainPanel(
       plotOutput("regPlot"),
       h3("How much variation is explained by the model?"),
       textOutput("model"),
       p("We can generally see that when including the dinosaurs we end up not explaining much of the variation. The best fit of a linear model 
         happens when animals excluding dinosaurs is selected."),
       plotOutput("infPlot"),
       p("The most influential observations can be identified with Cook's distance.
         Data points with large residuals (outliers) and/or high leverage may distort the outcome and accuracy of a regression. 
         Cook's distance measures the effect of deleting a given observation. 
         Points with a large Cook's distance are considered to merit closer examination in the analysis.",  tags$i("Source: Wikipedia") ),
       p("Lastly, it should be mentioned that the data is log transformed. We chose to do this because the correlation of the raw data can be very low (<0.06), unless
         the Spearman rank correlation is measured (which is calculated as >0.92). This already suggests that the brain and body weights have a nonlinear relationship."),
       p("Data source:", tags$i("Weisberg, S. (1985) Applied Linear Regression. 2nd edition. Wiley, pp. 144–5; 
                              P. J. Rousseeuw and A. M. Leroy (1987) Robust Regression and Outlier Detection. Wiley, p. 57..")
        ),
       p("You can find the server.R and ui.R code (as well as the relevant slidify presentation) on github", tags$a(href="https://github.com/ConnieKyr/land_animals", "here!"))
    )
  )
))
