options(shiny.trace=FALSE)
#options(shiny.trace=TRUE)

library(shiny)
library(digest)
library(plyr)
source('masking_code.R')
source('functions.R')

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 120MB.
options(shiny.maxRequestSize = 120*1024^2)
pathvar <<- getwd();
tempdirpath <<- NULL;

shinyServer(function(input, output, session) {

  observeEvent(input$clean, 
  {   unlink(tempdirpath, recursive = TRUE, force = TRUE)
  })
  
  observeEvent(input$quit, 
  {   quit(save = "no", status = 0, runLast = FALSE)
               })

  observe({
    
    if(input$passwd == input$passwd1)
    {
      checkboxInput("passwordmatch", "Done", value = TRUE)
    }
    else
    {
      checkboxInput("passwordmatch", "Done", value = FALSE)
    }
        
    if(input$step2b == 1)
    {
      updateCheckboxInput(session, "step2", value = TRUE)
    }
    
    
    if(input$passrandom == TRUE)
    {
      updateCheckboxInput(session, "mapping", value = FALSE)
      ranpass <- genrandompass()
      updateTextInput(session, "passwd", value = paste(ranpass))
      updateTextInput(session, "passwd1", value = paste(ranpass)) 
    }
    else
    {
      if(input$step2 == FALSE)
      {
        #updateTextInput(session, "passwd", value = paste(""))
      }
    }
    
    if(input$passrandom == TRUE)
    {
      updateCheckboxInput(session, "mapping", value = FALSE)
    }

    
    if(input$step1b == 1)
    {
      updateCheckboxInput(session, "step1", value = TRUE)
      updateCheckboxInput(session, "step1next", value = FALSE)
      if(input$passrandom == FALSE){
      filekey <- loadkey()
      
      if(!is.null(filekey))
      { updateTextInput(session, "passwd", value = paste(filekey))
        updateTextInput(session, "passwd1", value = paste(filekey))
        }
      }
    }
    

    if(length(intersect(input$pcol, input$rcol))==0)
    {
      updateCheckboxInput(session, "inputok", value = TRUE)
    }
    else
    {
      updateCheckboxInput(session, "inputok", value = FALSE)
    }   
    
    #Check if a file has been uploaded to mask
    inFile <- input$file1
    
    if (!is.null(inFile) && input$step1 == FALSE)
    updateCheckboxInput(session, "step1next", value = TRUE)
    
    #Check if a file has been uploaded to verify f1
    inFile1 <- input$src
    
    if (!is.null(inFile1))
      updateCheckboxInput(session, "verifyf1", value = TRUE)
    
    #Check if a file has been uploaded to verify f2
    inFile2 <- input$msk
    
    if (!is.null(inFile2))
      updateCheckboxInput(session, "verifyf2", value = TRUE)
    
  })
  
  output$nricselect <- renderUI({ 
    inFile <- input$file1
    
    if (is.null(inFile))
      return('')
    
    datain <<- read.csv(inFile$datapath, header = input$header,
                        sep = input$sep, quote = input$quote, nrows = 2)
    
    selectInput(inputId = "nricselect", label = "NRIC Column", choices = as.list(colnames(datain)))
  })
  
  output$legal <- reactive({ 
    htmlcode <- paste(readLines("license.txt"), collapse=" ")
  })
  
  output$warnings <- reactive({ 
    if(input$passrandom == TRUE)
    {"A mapping table cannot be generated in this mode"}
    else
    {""}
    })  
  
  output$warnings2 <- reactive({ 
    if(length(intersect(as.list(input$rcol),as.list(input$pcol))>0))
    {"Cannot remove and de-identify the same variable, please review your options"}
    else
    {""}
  })  

  output$preview_step1_name <- reactive({ 
    paste(input$file1['datapath'])})  
  
  output$preview_step1 <- renderTable({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    updateCheckboxInput(session, "step1next", value = TRUE)
    
    datain <<- read.csv(inFile$datapath, header = input$header,
                       sep = input$sep, quote = input$quote, nrows=5)
  })
  

  output$preview_step1 <- renderTable({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    datain <<- read.csv(inFile$datapath, header = input$header,
                        sep = input$sep, quote = input$quote, nrows=5)
  })
  
  output$pricol <- renderUI({   
    inFile <- input$file1
    
    if (is.null(inFile))
      return('')
    
    datain <<- read.csv(inFile$datapath, header = input$header,
                        sep = input$sep, quote = input$quote, nrows = 2)
    
    radioButtons("primarycol", "Select the primary column", choices = as.list(colnames(datain)))
  })
  
  output$maskcol <- renderUI({   
    inFile <- input$file1
    
    if (is.null(inFile))
      return('')
    
    datain <<- read.csv(inFile$datapath, header = input$header,
                        sep = input$sep, quote = input$quote, nrows = 2)
    
    #radioButtons("pcol", "Select the column to De-identify", choices = as.list(colnames(datain)))
    checkboxGroupInput("pcol", "Columns to De-Identify", choices = as.list(colnames(datain)))
  })
  
  output$removecol <- renderUI({     
    inFile <- input$file1
    
    if (is.null(inFile))
      return('')
    
    datain <<- read.csv(inFile$datapath, header = input$header,
                        sep = input$sep, quote = input$quote, nrows = 2)
    
    checkboxGroupInput("rcol", "Columns to Remove", choices = as.list(colnames(datain))) 
  })
  
  output$downloadData <- downloadHandler(
    filename = 'output.zip',
    content = function(fname) {
      setwd(pathvar)
      
      tmpdir <- tempdir()
      setwd(tempdir())
      print(tempdir())
      print(input$mapping)
      print(input$report)
      
      inFile <- input$file1
      
      if (is.null(inFile))
      return(NULL)
      
      ou <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote = input$quote)

      temp <- mask(ou,as.list(input$rcol),as.list(input$pcol),input$mapping,as.character(input$passwd),input$colnric,input$nricselect,input$mode)
      dl <- temp[[1]]
      mp <- temp[[2]]
      
      no_files <- (length((input$pcol)))
  
      fs <- c("mask.csv")
      fs_no_mask <- c("mask.csv")
      write.csv(dl, file = "mask.csv",row.names = FALSE)
        
      cnt <- 1
      while(cnt <= no_files)
      {
        fs <- append(fs,paste0("mapping-",input$pcol[cnt],".csv"))
        write.csv(mp[cnt], file = fs[cnt+1], na = "",row.names = FALSE)
        cnt <- cnt+1
      }
        
      print (fs)
        
      #check the masking
      tempdirpath <<- tempdir()
      if(input$report == TRUE)
      {
        setwd(pathvar)
        orgpath <- inFile$datapath
        
        newpath <- chartr("\\", "/", orgpath)
        newtempdirpath <- chartr("\\", "/", tempdirpath)
        
        checkSingle(
          newpath,paste(newtempdirpath),paste(newtempdirpath),as.list(input$pcol),as.list(input$rcol),TRUE
        )
        file.rename("./0.pdf",paste0(newtempdirpath,"/report-",inFile$name,".pdf"))
        
        setwd(tempdir())
        fs <- append(fs,paste0("report-",inFile$name,".pdf"))
        fs_no_mask <- append(fs_no_mask,paste0("report-",inFile$name,".pdf"))
        }
        
        print(input$mapping)
        print(input$report)
      
        if(input$mapping == TRUE)
        {
          zip(zipfile=fname, files=fs)
        }
        else
        {
          zip(zipfile=fname, files=fs_no_mask)
        }
        
        if(file.exists(paste0(fname, ".zip"))) {file.rename(paste0(fname, ".zip"), fname)}
    },
    contentType = "application/zip"
  ) 
  
  output$downloadReportData <- downloadHandler(
    filename = 'report.zip',
    content = function(fname) {
      
      setwd(pathvar)
      
      sourcefile <- input$src
      maskedzipfile <- input$msk
      
      if (is.null(sourcefile))
        return(NULL)
      
      if (is.null(maskedzipfile))
        return(NULL)
      
      tmpdir <- tempdir()
      print(tempdir())
      unzipfld <- "./masked"
      reptfld <- "./reports"
      print(unzipfld)
      
      orgpath <- sourcefile$datapath
      newpath <- chartr("\\", "/", orgpath)
      print(newpath)
      
      dir.create(unzipfld)
      unzip(maskedzipfile$datapath,exdir = paste(unzipfld),overwrite = TRUE)
      checkSingle(newpath,paste(unzipfld),paste(unzipfld),as.list(input$pcolchk),as.list(input$rcolchk),TRUE)
      
      unlink("./masked", recursive = TRUE, force = TRUE)
      unlink(paste0("report-",sourcefile$name,".pdf"))
      unlink("./0.rmd")
      dir.create(reptfld)
      file.rename("./0.pdf",paste0(reptfld,"/report-",sourcefile$name,".pdf"))
      
      setwd(reptfld)
      
      fs <- c(paste0("report-",sourcefile$name,".pdf"))
      zip(zipfile=fname, files=fs)
      
    },
    contentType = "application/zip"
  )
  
  output$maskcolchk <- renderUI({   
    inFile <- input$src
    
    if (is.null(inFile))
      return('')
    
    datain <<- read.csv(inFile$datapath, header = input$header,
                        sep = input$sep, quote = input$quote, nrows = 2)
    
    checkboxGroupInput("pcolchk", "Columns to De-Identify", choices = as.list(colnames(datain)))
  })
  
  output$removecolchk <- renderUI({     
    inFile <- input$src
    
    if (is.null(inFile))
      return('')
    
    datain <<- read.csv(inFile$datapath, header = input$header,
                        sep = input$sep, quote = input$quote, nrows = 2)
    
    checkboxGroupInput("rcolchk", "Columns to Remove", choices = as.list(colnames(datain))) 
  })
})


