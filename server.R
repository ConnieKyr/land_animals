#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


#some needed operations
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(MASS)
data(Animals)
data("mammals")
set.seed(7)

#basic data manipulation
Animals2 <- local({D <- rbind(Animals, mammals); unique(D[order(D$body,D$brain),])})
dinos<-c("Dipliodocus", "Triceratops", "Brachiosaurus")
rodents<-c("Mouse", "Rat", "Chinchilla", "Ground squirrel", "Golden hamster", "Guinea pig", "Arctic ground squirrel", "African giant pouched rat", "Mountain beaver", "Yellow-bellied marmot")
primates<-c("Human", "Gorilla", "Chimpanzee", "Baboon", "Verbet", "Slow loris", "Galago", "Owl monkey", "Rhesus monkey", "Potar monkey")
Animals3<-Animals2[!(row.names(Animals2) %in% dinos),]
Animals4<-Animals2[row.names(Animals2) %in% rodents,]
Animals5<-Animals2[row.names(Animals2) %in% primates,]

shinyServer(function(input, output) {
   
  output$regPlot <- renderPlot({
    
   
    dgroup <- switch(input$animal_group,
                   all = Animals2,
                   nodino = Animals3,
                   rod = Animals4,
                   prim = Animals5,
                   all)
    
    anim_fit<-lm(log(brain)~log(body), data=dgroup)
    
    if(input$labelled) {
      
      ggplot(dgroup, aes(x=log(body), y=log(brain))) + geom_point(size=2) + geom_smooth(method=lm) + geom_text(aes(label=row.names(dgroup)),hjust=0, vjust=0)
      
    }
    else {
      
      ggplot(dgroup, aes(x=log(body), y=log(brain))) + geom_point(size=2) + geom_smooth(method=lm)
  
    }

    
  })
  
  
  output$model <- renderText({
    
    dgroup <- switch(input$animal_group,
                     all = Animals2,
                     nodino = Animals3,
                     rod = Animals4,
                     prim = Animals5,
                     all)
    
    anim_fit<-lm(log(brain)~log(body), data=dgroup)
    
    model<-summary(anim_fit)$r.squared
    
   
    
  })
  
  
  output$infPlot <- renderPlot({
    
    
    dgroup <- switch(input$animal_group,
                     all = Animals2,
                     nodino = Animals3,
                     rod = Animals4,
                     prim = Animals5,
                     all)
    
    anim_fit<-lm(log(brain)~log(body), data=dgroup)
    cutoff <- 4/((nrow(dgroup)-length(anim_fit$coefficients)-2)) 
    plot(anim_fit, which=4, cook.levels=cutoff)
    
    
  })
  
  
  
})
