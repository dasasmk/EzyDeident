trim <- function (x) gsub("^\\s+|\\s+$", "", x)	
pass1 <- NULL;

decrypt_wrap <- function(data)
{
  return(decrypt(data,pass1))
}

decrypt <- function(cipher_text,key){
  
  library(PKI)
  library(RCurl)
  
  cipher_text <- base64(cipher_text,encode=FALSE)
  cipher_text <- charToRaw(cipher_text)
  
  key <- PKI.digest(charToRaw(key), "SHA256")
  result <- PKI.decrypt(cipher_text, key, "aes256")
  result <- rawToChar(result)
  
  return(result)
  
}

encrypt_wrap <- function(data)
{
  return(encrypt(data,pass1))
}

encrypt <- function(plain_text,key){
  
  library(PKI)
  library(RCurl)
  
  plain_text <- charToRaw(plain_text)
  key <- PKI.digest(charToRaw(key), "SHA256")
  result <- PKI.encrypt(plain_text, key, "aes256")
  
  b64result <- base64(result,encode = TRUE)
  
  return(b64result)
}

genrandompass <- function(x){
  n = 16
  randompass=""
  
  special_Char_list=c("!", "@", "#", "$", "%", "^", "&", "*",
                      "(", ")", "_", "-", "+", "+", "?", "<", ">",
                      ":", ";", "~")
  for(i in 1:n){
    temp=sample(c(special_Char_list, letters, LETTERS, as.character(0:9)), 1)
    randompass=paste(randompass, temp, sep="")
  }
  return(randompass)
}

loadkey <- function (x)
{
  keypath <- "./key.txt"
  key <- ""
  if(file.exists(keypath))
  {
    key <- read.csv(keypath, header = FALSE, nrows=1)
    return(as.character(key$V1))
  }
  else
  {
    return(NULL)
  }
}

checknric <- function (x)
{
    #List of NRIC prefix which should not be flagged as abnormal
    no_flag_NRIC = c("S","T","F","G")
  
    #List of NRIC prefix which should not be flagged as 2
    NRIC_2 = c("X")  
  
    if(!nchar(as.vector(x))==9)
    {return(-1)}
    
    firstletter <- substring(x,1,1)
    
    if(firstletter%in%NRIC_2)
    {
      return(2);
    }
    
    if(!firstletter%in%no_flag_NRIC) 
    {
      return(1)
    }
    
    return(0)
}

hmac_wrap <- function(data)
{
  return(hmac(pass1,data,"sha256"))
}

mask <- function(ou,rcol,pcol,mapping,passwd,nricflag,nriccol,mode) {
    
	if(!file.exists("keyused.txt"))
	{
		fileConn<-file("keyused.txt")
		#writeLines(c(passwd), fileConn)
		close(fileConn)
	}	
  	
    mappingtables <- list()  
    count <- 1
    dat <- ou
    cols_to_remove <- as.list(rcol)
    cols_to_mask <- as.list(pcol)
    print(cols_to_remove)

    if(nricflag == TRUE)
    {
      dat$nric_checksum <- sapply(dat[,paste(as.character(nriccol),"",sep="")],checknric)
    }
    
    #Mask everything
		for(s in cols_to_mask)
		{
			mappingtable<-NULL
		    		
			dat[,as.character(s)]<-sapply(dat[,as.character(s)],trim)
			id<-(dat[,as.character(s)])
			
			mappingtable$ID<-unique(id)
			mappingtable$MASK<-rep(NA,length(mappingtable$ID))
			class(mappingtable)
			uid<-unique(mappingtable$ID)
			#print(uid)
		  
			#print(passwd)
			pass1 <<- passwd
			
			if(mode == 'E')
			{
			  mappingtable$MASK[which(mappingtable$ID==uid)] <- sapply(uid,encrypt_wrap)
			}
			else
			{
			  mappingtable$MASK[which(mappingtable$ID==uid)] <- sapply(uid,hmac_wrap)
			}
			
			dat[,paste(s,"_masked",sep="")] <- mappingtable$MASK[match(dat[,as.character(s)],mappingtable$ID)]

      
      #cleanup unmasked cols
	  	dat<-dat[,-which(colnames(dat)==as.character(s)[1])]  
      
      names(mappingtable)[1] <- as.character(s)
      mappingtables[[count]] <- mappingtable
      #print(mappingtables)
		  
      count <- count + 1
  	}

		for(i in cols_to_remove){
		  dat<-dat[,-which(colnames(dat)==as.character(i)[1])]
		}
  
	datmask<-dat
  return(list(datmask,mappingtables))
	
}

