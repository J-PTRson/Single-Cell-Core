################# READ ME ##############
# Use these the helper functions to convert between index/well positions.
# example: 
# index_to_well(150)
#
# example:
# well_to_index("G6")
#
#More information can be found here -> LINK
#########################################
########### helper functions ############
#########################################

#To convert a cell-index to a well-index
index_to_well <- function(index){
  wells <- NULL
  for (i in toupper(letters[1:16])){
    for (c in c(1:24)){
      ti<-paste0(i,c)
      wells <- c(wells,ti)
    }
  }
  well_index <- wells[index]
  return(well_index)
} 

#To convert a well-index to a cell-index
well_to_index <- function(well){
  well <- toupper(well)
  row.l <- substr(well,1,1)
  row.nr <- substr(well,2,3)
  index <- (match(row.l, toupper(letters[1:16])) -1 ) * 24
  index <- index + as.integer(row.nr)
  return(index)
}

#Insert plate names for each well/index
insert_plate_name <- function(index, plate_name,ext=".bam"){
  incl.plate_name <- NULL
  for (n in 1:length(index)){
    convert <- paste0(plate_name,index[n],ext)
    incl.plate_name <- c(incl.plate_name, convert)
  }
  return(incl.plate_name)
}

############################
############################
############################

## control group ##

column_controls <- c(1:12) #the control cells are in columns 1 to 12.
row_controls <- toupper(letters[1:16]) #the control cells are in all rows. (A until P)

###Collect all indexes from each sample
plate_controls <- NULL
for (row in row_controls){
  for (c in column_controls){ 
    t1 <- paste0(row,c)
    plate_controls <- c(plate_controls,t1)
  }
}

plate_controls

## test group ##
column_test <- c(13:24) #the test cells are in columns 13 to 24
row_test <- toupper(letters[1:16]) #the test cells are in all rows (A until P)

###Collect all indexes from each sample
plate_test <- NULL
for (row in row_test){
  for (c in column_test){ 
    t1 <- paste0(row,c)
    plate_test <- c(plate_test,t1)
  }
}

plate_test


###convert the well IDs to indexes
index_plate_controls <- well_to_index(plate_controls)

index_plate_test <- well_to_index(plate_test)


###create a vector containing cell ids for each sample (include the _ )
plate_name <- "sc.SCC-scKaryo-HUB-CORE-001_"

full_plate_controls <- insert_plate_name(index_plate_controls, plate_name = plate_name, ext=".bam")

full_plate_test <- insert_plate_name(index_plate_test, plate_name = plate_name, ext=".bam")


###save the created list.
setwd("D:/work/tutorial/SCC-scChIC-HUB-CORE-001") # set this to the directory where you want to save the outputs. 

write.table(full_plate_controls, file="./SCC-scChIC-HUB-CORE-001_controls.txt", sep="\n", row.names = F, col.names = F, quote = F)

write.table(full_plate_test, file="./SCC-scChIC-HUB-CORE-001_test_group.txt", sep="\n", row.names = F, col.names = F, quote = F)


# Create copy of files
file.copy(from = paste0("D:/work/tutorial/", full_plate_controls),
          to = paste0("D:/work/experimental_controls/", full_plate_controls))

# Remove files
#file.remove(from = paste0(""D:/work/tutorial/", full_plate_controls)) 


