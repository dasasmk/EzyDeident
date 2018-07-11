#To download the package if needed
deps <- c(
  "PKI",
  "R6",
  "RCurl",
  "Rcpp",
  "base64enc",
  "bitops",
  "caTools",
  "digest",
  "evaluate",
  "formatR",
  "highr",
  "htmltools",
  "httpuv",
  "jsonlite",
  "knitr",
  "magrittr",
  "markdown",
  "mime",
  "plyr",
  "rmarkdown",
  "shiny",
  "stringi",
  "stringr",
  "xtable",
  "yaml",
  "pander",
  "downloader",
  "data.table",
  "shinythemes"
)

packs <- rownames(installed.packages())

install.packages(deps[!(deps %in% packs)], repo = "https://cloud.r-project.org")
