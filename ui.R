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

ui <- fluidPage(
  dashboardPage(
    skin = "purple",
    dashboardHeader(
      title = "Prediksi Bansos"
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem(text = "Penerima Bantuan Sosial", tabName = "bansos", icon = icon("hand-holding-usd")),
        menuItem(text = "Grafik", tabName = "graf", icon = icon("line-chart"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = 'bansos',
                fluidPage(
                  box(
                    width = 12,
                    valueBoxOutput("tidak_menerima_bantuan"),
                    valueBoxOutput("menerima_bantuan"),
                    valueBoxOutput("total_responden")
                  )
                ),
                fluidPage(
                  box(
                    width = 12,
                    h4(strong("Daftar Penerima Bantuan Sosial"), align = "center"),
                    DT::dataTableOutput('dt_by')
                  )
                ),
                fluidPage(
                  box(
                    width = 12,
                    selectInput("input_usia", "Usia :", 
                                choices = c("<30 tahun","30-50 tahun",">50 tahun"),
                                selected = "None"),
                    selectInput("input_status", "Status Perkawinan :", 
                                choices = c("Belum Menikah","Menikah","Duda/Janda"),
                                selected = "None"),
                    selectInput("input_anak", "Jumlah Anak :", 
                                choices = c("<5 anak","5-10 anak",">10 anak"),
                                selected = "None"),
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
                    actionButton("add_row_btn", "Prediksi")
                  )
                )
        ),
        tabItem(tabName = 'graf',
                fluidPage(
                  box(
                    width = 12,
                    plotlyOutput("ttl")
                  )
                ),
                fluidPage(
                  box(
                    width = 6,
                    plotOutput("pie2")
                  ),
                  box(
                    width = 6,
                    plotOutput("pie")
                  )
                )
        )
      )
    )
  )
)
