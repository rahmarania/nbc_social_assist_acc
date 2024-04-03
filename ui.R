library(flexdashboard)
library(shiny)
library(shinydashboard)
library(dplyr) # manipulation
library(DT)
library(ggplot2)
library(glue)
library(plotly)
library(shinythemes)
library(tm)
library(wordcloud2)

ui <- fluidPage(
  dashboardPage(
    skin = "purple",
    dashboardHeader(
      title = "Prediksi Bansos"
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem(text = "Penerima Bantuan Sosial", tabName = "bansos", icon = icon("hand-holding-usd"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = 'bansos',
                fluidPage(
                  box(
                    width = 12,
                    h4(strong("Daftar Penerima Bantuan Sosial"), align = "center"),
                    DT::dataTableOutput('dt_by')
                    #DTOutput('bantuan')
                  )
                ),
                fluidPage(
                  box(
                    width = 12,
                    #numericInput("input_umur", "Usia:", value = NA),
                    selectInput("input_Umur", "Usia :", 
                                choices = c("<30 tahun","30-50 tahun",">50 tahun"),
                                selected = "None"),
                    selectInput("input_status", "Status Perkawinan :", 
                                choices = c("Belum Menikah","Menikah","Duda/Janda"),
                                selected = "None"),
                    #numericInput("input_anak", "Jumlah Anak :", value = NA),
                    selectInput("input_anak", "Jumlah Anak :", 
                                choices = c("<5 anak","5-10 anak",">10 anak"),
                                selected = "None"),
                    #textInput("input_pekerjaan", "Pekerjaan :"),
                    selectInput("input_pendapatan", "Pendapatan :", 
                                choices = c("500.000 - 1.500.000","1.500.000 - 3.000.000", "3.000.000 - 4.500.000", "4.500.000 ke atas",'Lainnya'),
                                selected = ""),
                    selectInput("input_kendaraan", "Cara Akses ke Fasilitas :", 
                                choices = c("Jalan Kaki","Sepeda", "Sepeda Motor", "Mobil",'Angkutan Umum',"Lainnya"),
                                selected = ""),
                    radioButtons("input_toilet", "Memiliki Toilet :", choices = c("Ya", "Tidak"), selected = ""),
                    selectInput("input_air", "Pasokan Air Bersih :", 
                                choices = c("Tidak ada","Tidak cukup baik", "Cukup baik", "Baik"),
                                selected = ""),
                    #checkboxInput("input_bantuan", "Menerima Bantuan:", value = FALSE),
                    actionButton("add_row_btn", "Prediksi")
                    )
                )
        )
      )
    )
  )
)
