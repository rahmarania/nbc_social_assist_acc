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

dt <- read.csv('sikd_gabung.csv')
#dt_by$usia <- factor(gsub("tahun", "", dt_by$usia))

#dt_by <- dt_by %>% mutate(usia = as.factor(usia),
#                          status_perkawinan = as.factor(status_perkawinan),
#                          jml_anak = as.factor(jml_anak),
#                          pendapatan = as.factor(pendapatan),
#                          akses_ke_fasilitas = as.factor(akses_ke_fasilitas),
#                          akses_toilet = as.factor(akses_toilet),
#                          air_bersih = as.factor(air_bersih),
#                          menerima_bantuan = as.factor(menerima_bantuan))

dt <- dt %>% select(c('usia',"status_perkawinan","jml_anak","pendapatan","akses_ke_fasilitas","akses_toilet","air_bersih","menerima_bantuan")) 
#dt_by$usia <- cut(dt_by$usia, 
#                breaks = c(0, 30, 50, Inf), 
#                labels = c("<30 tahun", "30-50 tahun", ">50 tahun"),
#                right = FALSE)
#dt_by$jml_anak <- cut(dt_by$jml_anak,
#                    breaks = c(0,5,10,Inf),
#                    labels = c("<5 anak", "5-10 anak",'>10 anak'),
#                    right = FALSE)




