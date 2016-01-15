#To download the package if needed
packs <- installed.packages()
packs <- names(packs[,'Package'])

if(!any(packs%in%"PKI")){
  install.packages("PKI", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"R6")){
  install.packages("R6", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"RCurl")){
  install.packages("RCurl", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"Rcpp")){
  install.packages("Rcpp", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"base64enc")){
  install.packages("base64enc", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"bitops")){
  install.packages("bitops", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"caTools")){
  install.packages("caTools", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"digest")){
  install.packages("digest", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"evaluate")){
  install.packages("evaluate", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"formatR")){
  install.packages("formatR", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"highr")){
  install.packages("highr", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"htmltools")){
  install.packages("htmltools", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"httpuv")){
  install.packages("httpuv", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"jsonlite")){
  install.packages("jsonlite", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"knitr")){
  install.packages("knitr", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"magrittr")){
  install.packages("magrittr", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"markdown")){
  install.packages("markdown", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"mime")){
  install.packages("mime", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"plyr")){
  install.packages("plyr", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"rmarkdown")){
  install.packages("rmarkdown", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"shiny")){
  install.packages("shiny", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"stringi")){
  install.packages("stringi", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"stringr")){
  install.packages("stringr", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"xtable")){
  install.packages("xtable", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"yaml")){
  install.packages("yaml", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"downloader")){
  install.packages("downloader", repos="http://cran.us.r-project.org")  
}

if(!any(packs%in%"pander")){
  install.packages("pander", repos="http://cran.us.r-project.org")  
}



