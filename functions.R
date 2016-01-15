#' Adding YAML parameters to the beginning of an \code{.Rmd} file
#' @param title The title of the resulting document. Default is without title.
#' @param date Date to show in the resulting document. Default is without date.
#' @param output Format of the output file, which should be one of 
#'  \code{pdf_document} (for \code{pdf} file), 
#'  \code{word_document} (for \code{docs} file), or 
#'  \code{html_document} (for \code{html} file). 
#'  Default is \code{pdf_document}.
#' @param fontsize The font size to use for the output \code{pdf} document only. 
#'  Default is 12pt (larger than system default, which is 11pt).
#' @param ... Parameters for function \code{\link{[base]cat}}. 
#' @details By supplying the name of the .Rmd file, this function can write the 
#'  YAML parameters to the file.
addYAML <- function(title = "", date = "", output = "pdf_document", 
                    fontsize = "12pt", ...) {
  cat("---\n", ...)
  if (title != "") cat("title:", title, "\n", ...)
  if (date != "") cat("date:", date, "\n", ...)
  cat("output:", output, "\n", ...)
  cat("fontsize:", fontsize, "\n", ...)
  cat("---\n\n", ...)
}
#' Adding a code chunk to an \code{Rmd} file
#' @param chunkName Name of the chunk. Default is without chunk name.
#' @param rCode The rCode to put in the chunk. Default is without any code.
#' @param chunkOpt Chunk options to apply to this chunk. These options should 
#'  be specified as a string separated by \code{,}. Default is 
#'  \code{echo = FALSE}.
#' @param ... Parameters for function \code{\link{[base]cat}}. 
#' @details By supplying the name of the .Rmd file, this function can write the 
#'  YAML parameters to the file.
addChunk <- function(chunkName = "", rCode = NULL, chunkOpt = "echo = FALSE", 
                     ...) {
  cat("```{r ", chunkName, sep = "", ...)
  if (!is.null(chunkOpt)) {
    cat(", ", toString(chunkOpt), sep = "", ...)
  }
  cat("}\n", sep = "", ...)
  if (!is.null(rCode)) {
    cat(rCode, "\n", ...)
  }
  cat("```\n", ...)
}
#' Printing the \code{params} list to a code chunk in an \code{Rmd} file
#' @param params The parameters to pass to the \code{Rmd} file, specified as a 
#'  normal list.
#' @return Creates a string representing the parameter given, so that it 
#'  could be added into a code chunk.
addParams <- function(params, ...) {
  quoteValue <- function(value) {
    paste0("'", value, "'")
  }
  value <- unlist(lapply(1:length(params), 
                         function(i) paste(names(params)[i], "=", 
                                           quoteValue(params[[i]]))))
  paste0("params <- list(", paste(value, collapse = ", "), ")")
}
#' Checking whether the masked columns specified are legal
checkInput <- function(mappingDir, maskedCols) {
  if (mappingDir == "") {
    stop(simpleError("Please check the masked columns."))
  }
  # Need to check whether the masked columns are correctly specified, i.e. 
  # whether a mapping table exists for each of the columns given
  mappingTbs <- dir(mappingDir, pattern = "mapping-")
  mappingCols <- sapply(mappingTbs, 
                        function(mt) {
                          f <- unlist(strsplit(mt, split = "mapping-"))[2]
                          unlist(strsplit(f, split = "\\."))[1]
                        })
  mapExists <- sapply(maskedCols, function(col) col %in% mappingCols)
  if (any(!mapExists)) {
    nm <- maskedCols[!mapExists]
    stop(simpleError(paste("Are you sure columns", toString(nm), 
                           "were masked?")))
  }
}
#' Creating the \code{Rmd} file to check the masking of a single file
#' @param originalFile The path to the original file. Currently only support 
#'  \code{csv} format.
#' @param maskedDir The path to folder containing the masked data.
#' @param mappingDir The path to folder containing the mapping tables. It 
#'  will be the same folder as the one containing the masked data, if user 
#'  chose to produce mapping tables (set as default), or a temporary folder 
#'  otherwise.
#' @param maskedCols A character vector of the column names of masked columns.
#' @param removedCols A character vector of column names of removed columns.
#'  Default is empty, which means no column has been removed.
#' @param producePFD Whether to render the resulting \code{Rmd} file straight 
#'  away to produce a pdf report. Default is \code{TRUE}.
#' @return The resulting \code{Rmd} file will be saved in the current directory 
#'  with the same name as the original data file. A pdf report will be 
#'  generated with the same name as the ariginal file if parameter 
#'  \code{producePDF} is set to \code{TRUE}.
checkSingle <- function(originalFile = "", maskedDir = "", 
                        mappingDir = maskedDir, maskedCols, 
                        removedCols = "", producePDF = TRUE) {
  checkInput(mappingDir, maskedCols)
  # Import the main part of this Rmd file, saved as txt
  mainText <- readLines("checkSingle.txt")
  # Extract the name of the original data file
  nm <- basename(originalFile)
  nmVec <- unlist(strsplit(nm, split = "\\."))
  #if (nmVec[2] != "csv") {
  #  stop(simpleError("The original data file must be a csv file."))
  #} else {
    nm <- nmVec[1]
 # }
  # Create the Rmd file in the current directory
  filename <- paste0(nm, ".Rmd")
  f <- file(filename, "w")
  addYAML(file = f)
  addChunk(rCode = addParams(
    params = list(originalFile = originalFile, 
                  maskedDir = maskedDir, 
                  mappingDir = mappingDir, 
                  cnames = paste(maskedCols, collapse = ";"), 
                  rmnames = paste(removedCols, collapse = ";"))), 
    file = f, append = TRUE)
  for (line in mainText) cat(line, "\n", file = f, append = TRUE)
  close(f)
  if (producePDF) {
    rmarkdown::render(filename)
  }
}
#' Creating the \code{Rmd} file to check the masking of multiple files
#' @param originalFile A character vector of path to the original files.
#'  Currently only support \code{csv} format.
#' @param maskedDir A character vector of path to folder containing the masked
#'  files.
#' @param mappingDir A character vector of path to folder containing the 
#'  mapping tables. It will be the same folder as the one containing the masked
#'  data, if user chose to produce mapping tables (set as default), or a
#'  temporary folder otherwise.
#' @param maskedCols A character vector of the column names of masked columns. 
#'  It is required that all the input datasets have exactly the same set of 
#'  columns masked using the same password.
#' @param removedCols A list of character vector of column names of removed
#'  columns for each dataset. Default is \code{NULL}, which means no column has
#'  been removed.
#' @param producePFD Whether to render the resulting \code{Rmd} file straight 
#'  away to produce a pdf report. Default is \code{TRUE}.
#' @return The resulting \code{Rmd} file will be saved in the current directory 
#'  with name \code{checkMultiple}. A pdf report named 
#'  \code{Quality check of Masking Tool} appended with the current date will be 
#'  generated if parameter \code{producePDF} is set to \code{TRUE}.
checkMultiple <- function(originalFile = NULL, maskedDir = NULL, 
                          mappingDir = maskedDir, maskedCols, 
                          removedCols = NULL, producePDF = TRUE) {
  checkInput(mappingDir, maskedCols)
  currentDate <- Sys.Date()
  # Import the main part of this Rmd file, saved as txt
  mainText <- readLines("checkMultiple.txt")
  # Create the Rmd file in the current directory
  filename <- "checkMultiple.Rmd"
  f <- file(filename, "w")
  addYAML(file = f)
  addChunk(rCode = addParams(
    params = list(originalFiles = paste(originalFile, collapse = ";"), 
                  maskedDirs = paste(maskedDir, collapse = ";"), 
                  mappingDirs = paste(mappingDir, collapse = ";"), 
                  cnames = paste(maskedCols, collapse = ";"), 
                  rmnames = paste(removedCols, collapse = ";"))), 
    file = f, append = TRUE)
  for (line in mainText) cat(line, "\n", file = f, append = TRUE)
  close(f)
  if (producePDF) {
    rmarkdown::render(input = filename, 
                      output_file = paste0("Quality check of Masking Tool",
                                           currentDate, ".pdf"))
  }
}
