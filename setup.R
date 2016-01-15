#To download the package if needed
packs <- installed.packages()
packs <- names(packs[,'Package'])

if(!any(packs%in%"PKI")){
  install.packages("PKI")  
}

if(!any(packs%in%"R6")){
  install.packages("R6")  
}

if(!any(packs%in%"RCurl")){
  install.packages("RCurl")  
}

if(!any(packs%in%"Rcpp")){
  install.packages("Rcpp")  
}

if(!any(packs%in%"base64enc")){
  install.packages("base64enc")  
}

if(!any(packs%in%"bitops")){
  install.packages("bitops")  
}

if(!any(packs%in%"caTools")){
  install.packages("caTools")  
}

if(!any(packs%in%"digest")){
  install.packages("digest")  
}

if(!any(packs%in%"evaluate")){
  install.packages("evaluate")  
}

if(!any(packs%in%"formatR")){
  install.packages("formatR")  
}

if(!any(packs%in%"highr")){
  install.packages("highr")  
}

if(!any(packs%in%"htmltools")){
  install.packages("htmltools")  
}

if(!any(packs%in%"httpuv")){
  install.packages("httpuv")  
}

if(!any(packs%in%"jsonlite")){
  install.packages("jsonlite")  
}

if(!any(packs%in%"knitr")){
  install.packages("knitr")  
}

if(!any(packs%in%"magrittr")){
  install.packages("magrittr")  
}

if(!any(packs%in%"markdown")){
  install.packages("markdown")  
}

if(!any(packs%in%"mime")){
  install.packages("mime")  
}

if(!any(packs%in%"plyr")){
  install.packages("plyr")  
}

if(!any(packs%in%"rmarkdown")){
  install.packages("rmarkdown")  
}

if(!any(packs%in%"shiny")){
  install.packages("shiny")  
}

if(!any(packs%in%"stringi")){
  install.packages("stringi")  
}

if(!any(packs%in%"stringr")){
  install.packages("stringr")  
}

if(!any(packs%in%"xtable")){
  install.packages("xtable")  
}

if(!any(packs%in%"yaml")){
  install.packages("yaml")  
}

if(!any(packs%in%"pander")){
  install.packages("pander", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"downloader")){
  install.packages("downloader")  
}



