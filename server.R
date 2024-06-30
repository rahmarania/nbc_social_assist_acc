library(flexdashboard)
library(shiny)
library(shinydashboard)
library(dplyr) 
library(DT)
library(e1071)
library(caret)
library(ggplot2)
library(glue)
library(plotly)

server <- function(input, output, session){
  
  # datatables
  output$dt_by <- DT::renderDataTable({
    colnames(dt) <- c("Usia", "Status", "Jumlah Anak", "Pendapatan", "Cara Akses Fasilitas", "Akses Toilet", "Air Bersih", "Menerima Bantuan")
    
    datatable(dt, options = list(
      dom = "lrtip",
      lengthMenu = c(5, 1000)
    ), editable = 'all') 
  }, server = FALSE)
  
  output$ttl <- renderPlotly({
    dt %>% 
      group_by(menerima_bantuan, pendapatan) %>% 
      summarise(total = n()) %>% 
      ungroup() %>% mutate(label = paste("Status? ", menerima_bantuan, 
                                         "\nPendapatan",pendapatan,
                                         "\nTotal:", total)) %>% 
      ggplot(aes(x = menerima_bantuan, y = total)) +
      geom_bar(stat = "identity", position = "dodge", aes(fill = reorder(pendapatan, total), text = label), show.legend = FALSE) +
      labs(title = "Penerima Bantuan Sosial",
           x = "Menerima?",
           y = "Total") +
      theme_gray() + 
      theme(plot.title = element_text(face = "bold", hjust = 0.5)) 
    
    ggplotly(tooltip = "text")
  })
  
  output$pie <- renderPlot({
    piechrt <- dt %>% 
      filter(menerima_bantuan == "Ya") %>%
      group_by(akses_ke_fasilitas) %>% 
      summarise(total = n(),
                persen = total / nrow(dt) * 100) 
    
    ggplot(piechrt, aes(x = "", y = persen, fill = akses_ke_fasilitas, label = total)) +
      geom_bar(width = 1, stat = "identity", color = "black", alpha = 0.8) +
      geom_text(position = position_stack(vjust = 0.5), color = "black") +  # Add labels for total
      coord_polar(theta = "y") +
      theme_void() +
      theme(legend.position = "right", legend.text = element_text(size = 15)) +
      labs(title = "Kendaraan Responden Penerima Bantuan",
           subtitle = "Cara responden menuju fasilitas di desa") + 
      theme(plot.title = element_text(face = "bold", hjust = 0.5),
            plot.subtitle = element_text(hjust = 0.5))
    
    
  })
  
  output$pie2 <- renderPlot({
    piechrt2 <- dt %>% 
      filter(menerima_bantuan == "Tidak") %>%
      group_by(akses_ke_fasilitas) %>% 
      summarise(total = n(),
                persen = total / nrow(dt) * 100) 
    
    ggplot(piechrt2, aes(x = "", y = persen, fill = akses_ke_fasilitas, label = total)) +
      geom_bar(width = 1, stat = "identity", color = "black", alpha = 0.8) +
      geom_text(position = position_stack(vjust = 0.6), color = "black") + 
      coord_polar(theta = "y") +
      theme_void() +
      theme(legend.position = "right", legend.text = element_text(size = 15)) +
      labs(title = "Kendaraan Responden Bukan Penerima Bantuan",
           subtitle = "Cara responden menuju fasilitas di desa") + 
      theme(plot.title = element_text(face = "bold", hjust = 0.5),
            plot.subtitle = element_text(hjust = 0.5))
    
  })
  
  observeEvent(input$add_row_btn, {
    set.seed(211)  
    idx <- sample(x = nrow(dt), size = nrow(dt) * 0.8)
    dt_train <- dt[idx, ]
    dt_test <- dt[-idx, ]
    
    mdl_nbc2 <- naiveBayes(formula = menerima_bantuan ~., data = dt_train, laplace = 1)
    
    new_row <- data.frame(
      usia = factor(input$input_usia),
      status_perkawinan = factor(input$input_status),
      jml_anak = factor(input$input_anak),
      pendapatan = factor(input$input_pendapatan),
      akses_ke_fasilitas = factor(input$input_kendaraan),
      akses_toilet = factor(input$input_toilet),
      air_bersih = factor(input$input_air),
      menerima_bantuan = factor(input$add_row_btn)
    )
    
    menerima_bantuan <- predict(mdl_nbc2, newdata = new_row, type = 'class')
    
    new_row$menerima_bantuan <- menerima_bantuan
    
    dt <<- rbind(dt, new_row)
    
    # Update the DataTable
    output$dt_by <- DT::renderDataTable({
      datatable(dt, editable = TRUE, options = list(
        dom = "lrtip",
        lengthMenu = c(5, 1000)
      ))
    })
    
    # Save the modified DataFrame back to the CSV file
    write.csv(dt, "sikd_gabung.csv", row.names = FALSE)
    
    output$tidak_menerima_bantuan <- renderValueBox({
      valueBox(
        value = sum(dt$menerima_bantuan == "Tidak"),
        subtitle = "Tidak Menerima Bantuan",
        icon = icon("book"),
        color = "red"
      )
    })
    
    output$menerima_bantuan <- renderValueBox({
      valueBox(
        value = sum(dt$menerima_bantuan == "Ya"),
        subtitle = "Menerima Bantuan",
        icon = icon("dollar"),
        color = "green"
      )
    })
    
    output$total_responden <- renderValueBox({
      valueBox(
        value = nrow(dt),
        subtitle = "Responden",
        icon = icon("person"),
        color = "yellow"
      )
    })
  })
  
  output$tidak_menerima_bantuan <- renderValueBox({
    valueBox(
      value = sum(dt$menerima_bantuan == "Tidak"),
      subtitle = "Tidak Menerima Bantuan",
      icon = icon("book"),
      color = "red"
    )
  })
  
  output$menerima_bantuan <- renderValueBox({
    valueBox(
      value = sum(dt$menerima_bantuan == "Ya"),
      subtitle = "Menerima Bantuan",
      icon = icon("dollar"),
      color = "green"
    )
  })
  
  output$total_responden <- renderValueBox({
    valueBox(
      value = nrow(dt),
      subtitle = "Responden",
      icon = icon("person"),
      color = "yellow"
    )
  })
  
}
