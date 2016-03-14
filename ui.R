library(shiny)

shinyUI(navbarPage("Ezy De-Identifier",
                   
                   tabPanel("License",
                            tags$div(
                              HTML('<iframe src="license.htm" width="100%" style="height: 35em;"></iframe>')),
                            checkboxInput("legalchk", "I agree that my use of this tool is subject to the terms stated above", value = FALSE)
                             ),
                   
                   tabPanel("De-Identify",
                            fluidPage(
                  
  
  conditionalPanel("input.step1b < 0",
                  checkboxInput("step1", "Done", value = FALSE),
                  checkboxInput('header', 'Header', TRUE),
                  checkboxInput("step1next", "Done", value = FALSE),
                  checkboxInput("inputok", "Done", value = FALSE),
                  checkboxInput("step2", "Done", value = FALSE),
                  checkboxInput("passwordmatch", "Done", value = FALSE),
                  checkboxInput("verifyf1", "Done", value = FALSE),
                  checkboxInput("verifyf2", "Done", value = FALSE)),
  
                  conditionalPanel("input.step1 != true",
                  fluidRow(column(12,offset=2,"Please select a text file to upload and use the radio buttons to format the file into columns. Click Next when done.")),
                  HTML("<br>"),
                                   
                  fluidRow(column(3,
                  fileInput('file1', 'Choose Text File',accept = c(
                    'text/csv',
                    'text/comma-separated-values',
                    'text/tab-separated-values',
                    'text/plain',
                    '.csv',
                    '.tsv'
                  )),
                  
                  radioButtons('sep', 'Separator',
                                                  c(Comma=',',
                                                  Semicolon=';',
                                                  Tab='\t'),
                                                  ',')
#                   radioButtons('quote', 'Quote',
#                                                   c(None='',
#                                                   'Double Quote'='"',
#                                                   'Single Quote'="'"),
#                                                   '"')),
                  ),column(9,
                  tableOutput('preview_step1'),
                  textOutput("preview_step1_name")))),
                  
                  
                  conditionalPanel("input.step1next == true",
                                   actionButton("step1b", "Next")),
                  
                  conditionalPanel("input.step1 == true && input.step2 == false",
                  fluidRow(column(6,htmlOutput("maskcol"),htmlOutput("nricselect"),checkboxInput("colnric", "Perform NRIC check?", value = FALSE)),column(6,htmlOutput("removecol"))),
                  fluidRow(column(6,passwordInput("passwd",label = "Enter password"),passwordInput("passwd1",label = "Confirm password"), checkboxInput("passrandom", "Random Password?", value = FALSE)),column(6,
                  radioButtons('mode', 'Mode',
                               c(HMAC='M'),
                               'M'), 
                  checkboxInput('mapping', 'Produce Mapping File', TRUE),
                  checkboxInput('report', 'Produce Validation Report', TRUE))),
                  textOutput("warnings"),
                  textOutput("warnings2")),
                  
                  conditionalPanel("(input.passwd != input.passwd1)",
                                   "The passwords entered do not match"),
  
                  conditionalPanel("input.pcol == false && input.step1 == true && input.step2 == false",
                   "Please select at least one column to de-identify"),
  
                  conditionalPanel("input.step1 == true && input.step2 == false && input.passwd.length == 0",
                   "Please enter a password"),
  
                  conditionalPanel("input.step1 == true && input.step2 == false && input.inputok == true && (input.rcol.length >0 || input.pcol.length >0) && (input.passwd == input.passwd1) && input.passwd.length >0",
                                   actionButton("step2b", "Next")),
 
                  conditionalPanel("input.step1 == true && input.step2 == true && input.legalchk == false",
                   "Please agree to the license agreement"
                   ),
  
                  conditionalPanel("input.step1 == true && input.step2 == true && input.legalchk == true",
                                   fluidRow(column(12,offset=2,"Please click the download button to download your de-identified and mapping table (if selected) as a single zip file")),
                                   HTML("<br>"),
                                   fluidRow(column(4,downloadButton('downloadData', 'Download')),(column(4,actionButton("clean", "Remove Temporary Files"))),(column(4,actionButton("quit", "Quit")))))

  
)),
tabPanel("Verify",
        
         fluidRow(column(12,offset=1,"To verify data previously created without a validation report please select the source text and previous output zip")),
         HTML("<br>"),
         
         fileInput('src', 'Choose Source Text File',accept = c(
           'text/csv',
           'text/comma-separated-values',
           'text/tab-separated-values',
           'text/plain',
           '.csv',
           '.tsv'
         )),
         fileInput('msk', 'Choose previous output ZIP File',accept=c('text/csv','text/comma-separated-values,text/plain','.zip')),
         
         fluidRow(column(6,htmlOutput("maskcolchk")),column(6,htmlOutput("removecolchk"))),
        
         conditionalPanel("input.verifyf1 == true && input.verifyf2 == true",
         fluidRow(column(5,""),(column(6,downloadButton('downloadReportData', 'Download Report')))))
     ),
tabPanel("About",
         
         
         fluidRow(column(12,offset=1,"Ezy De-identifer v1.1 - Copyright 2016")),
         fluidRow(column(12,offset=1,"Co-developed by the Centre for Health Services and Policy Research and the Saw Swee Hock School of Public Health")),
         fluidRow(column(12,offset=1,"at the National University of Singapore and National University Health System in Singapore"))
         

))

)
