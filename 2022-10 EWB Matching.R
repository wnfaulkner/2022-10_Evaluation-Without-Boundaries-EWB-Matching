#0000000000000000000000000000000000000000000000000000#
#    	EWB Matching			           #
#0000000000000000000000000000000000000000000000000000#

# 0-SETUP --------------------------------------------------------------------------------

  #INITIAL SETUP
    rm(list=ls()) #Remove lists
    options(java.parameters = "- Xmx8g") #helps r not to fail when importing large xlsx files with xlsx package
    options(encoding = "UTF-8")
    
  # LOAD LIBRARIES/PACKAGES
    #library(wnf.utils)
    #LoadCommonPackages()
    library(tidyr)
    library(googlesheets4)
    
# 1-IMPORT CONFIGS --------------------------------------------------------------------------------
    
    gs4_auth(email = "william@fluxrme.com")
    
    ewb.ss <-
      as_sheets_id("https://docs.google.com/spreadsheets/d/1RNZtjFLOHPb1x6IqVpf9iLIjt2TjINMQNhzTxGRUBAQ/edit#gid=908159772")
    
    sheet.names.v <- sheet_names(ewb.ss)
    
    ewb.ls <-
      lapply(
        sheet.names.v, 
        function(x){
          read_sheet(ewb.ss, sheet = x)
        }
      )
    
    names(ewb.ls) <- c("orgs","consultants","matching")
    
    #Assign each table to its own tibble object
    
      ListToTibbleObjects <- function(list){
        for(i in 1:length(list)){
          
          object.name.i <- paste(names(list)[i], ".tb", sep = "")
          
          assign(
            object.name.i,
            list[[i]],
            pos = 1
          )
          
          print(paste(i, ": ", object.name.i, sep = ""))
        }
      }
      
      ListToTibbleObjects(ewb.ls) #Converts list elements to separate tibble objects names with
                                  #their respective sheet names with ".tb" appended
    
# 2-RESHAPE DATA --------------------------------------------------------------------------------
    
      
    names(matching.tb) <- matching.tb[1,] %>% unlist() %>% as.vector
    matching.tb <- matching.tb %>% .[-1,]
    
    consultant.names <- 
      c(
        "nancy.fournier",
        "ahad.zwooqar",
        "emily.mcdonald",
        "melissa.schigoda",
        "jenna.lachenaye"
      )
    
    
    
    matching.long.tb <-  
      matching.tb %>%
      pivot_longer(
        ., 
        cols = all_of(consultant.names),
        names_to = "consultant.name"
      ) %>%
      mutate(value = value %>% as.character %>% unlist %>% as.numeric)

  print(getwd())
  write.csv(matching.long.tb, "matching.long.csv")
    