library(flexdashboard)
library(shiny)
library(shinydashboard)
library(dplyr) 
library(DT)
library(e1071)
library(caret)

server <- function(input, output){
  output$dt_by <- DT::renderDataTable({
    colnames(dt_by) <- c("Usia", "Status", "Jumlah Anak", "Pendapatan", "Cara Akses Fasilitas", "Akses Toilet", "Air Bersih", "Menerima Bantuan")
    
    datatable(dt_by, options = list(
      dom = "lrtip",
      lengthMenu = c(5, 1000)
    ), editable = 'all') 
  }, server = FALSE)
  
  # Update the DataFrame with edited data
  #observeEvent(input$datatable_cell_edit, {
  #  info <- input$datatable_cell_edit
  #  str(info)
    
  #  modified_data <- dt_by
  #  modified_data[info$row, info$col] <- info$value
    
    # Save the modified DataFrame back to the CSV file
  #  write.csv(modified_data, "sikd_gab.csv", row.names = FALSE)
    
    # Update the DataTable
  #  output$dt_by <- renderDT({
  #    datatable(modified_data, editable = TRUE, options = list(pageLength = 10))
  #  })
  #})
  observeEvent(input$add_row_btn, {
    # Create a new row with the same structure as the original DataFrame
    set.seed(211)  
    idx <- sample(x = nrow(dt_by), size = nrow(dt_by) * 0.8)
    dt_by_train <- dt_by[idx, ]
    dt_by_test <- dt_by[-idx, ]
    
    mdl_nbc2 <- naiveBayes(formula = menerima_bantuan ~., data = dt_by_train, laplace = 1)
    
    new_row <- data.frame(
      usia = factor(input$input_Umur),
      status_perkawinan = factor(input$input_status),
      jml_anak = factor(input$input_anak),
      pendapatan = factor(input$input_pendapatan),
      akses_ke_fasilitas = factor(input$input_kendaraan),
      akses_toilet = factor(input$input_toilet),
      air_bersih = factor(input$input_air)
    )
    
    menerima_bantuan = predict(mdl_nbc2, newdata = new_row, type = 'class')
    
    new_row$menerima_bantuan <- menerima_bantuan
    
    dt_by <- rbind(dt_by, new_row)
    
    # Update the DataTable
    output$dt_by <- DT::renderDataTable({
      datatable(dt_by, editable = TRUE, options = list(
        dom = "lrtip",
        lengthMenu = c(5, 1000)
      ))
      
    }, server = FALSE)
    
    # Save the modified DataFrame back to the CSV file
    write.csv(dt_by, "sikd_gabung2.csv", row.names = FALSE)
  })
  
}
