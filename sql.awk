#######################################################################################
#
# NAME: ASE(AWK SQL EMULATOR)
# DESCRIPTION: Toolkit based on awk that emulates simple SQL gramma execution
# AUTHOR: _0xAF_
# EMAIL: overkazaf@gmail.com
# DATE: 2023-09-14
# USAGE: ase "tiny sql statement" CSV_FILENAME [| PIPELINE COMMAND]
#
# 1. Show csv headers
#    ase "HEADER" data.csv  
########################################################################################

# check if given value inside array
function isInArray(value, array) {
  for (i in array) {
     if (array[i] == value) {
         return 1
     }
  }
  return 0
}
# SELECT
function select(columns, file) {
   # read csv header 
   getline < file
   split($0, header, ",")
      
   # preprocess selected rows
   split(columns, selected, ",")

   # output selected rows
   cnt=1
   for (i in selected) {
       col = selected[i]
       if (isInArray(col, header)) {
          if (cnt > 1) printf ","
          printf "%s", col
          cnt++
       }
   }
   printf "\n"

   # read rows
   while (getline < file) {
       split($0, data, ",")
       # output selected values
       cnt=1
       for (i in selected) {
           col=selected[i]
           if (isInArray(col, header)) {
             if (cnt > 1) printf ","
             printf "%s", data[i]
             cnt++
           }
       }
       printf "\n"
   }
}

# WHERE
function where(condition, file) {
   # read csv header
   getline < file
   split($0, header, ",")

   # parse condition
   split(condition, parts, "=")
   col = parts[1]
   value = parts[2]
   for (i=1; i<=length(header);i++) { if (i > 1) printf ","; printf "%s", header[i] }  
   printf "\n"
   #printf "WHERE CONDITION %s=%s",col,value
   # output rows that matches condition
   while (getline < file) {
       split($0, data, ",")
       for (i in header) {
         if (col == header[i] && data[i] == value) {
           print $0
         }
       }
   }
}

# GROUP BY
function groupBy(column, file) {
   # read csv header
   getline < file
   split($0, header, ",")

   # count by column
   while (getline < file) {
       split($0, data, ",")
       for (i in header) {
         if (header[i] == column) {
           group = data[i]
           count[group]++
         }
       }
   }

   # output group by results
   for (group in count) {
       printf "%s %d\n", group, count[group]
   }
}

# ORDER BY
function orderBy(column, file) {
   # read csv header 
   getline < file
   split($0, header, ",")
   for (i=1;i<=length(header);i++) {
     if (i > 1) printf ","
     printf header[i]
   }
   printf "\n"
   
   #printf "column:%s",column
   # find target column 
   for (j in header) {
     if (header[j] == column) {
       sort_column=j
       break;
     }
   }

   # sorting, use 'sort' command instead of re-implemetation
   cmd="awk -F',' 'NR>1 {print $0}' " file "| sort -t',' -k" sort_column "," sort_column "n"
   system(cmd)
}

# read and show csv headers
function showHeader(file) {
  cmd = "head -n 1 " file
  system(cmd)
}

BEGIN {
   sql = ARGV[1]
   file = ARGV[2]
   delete ARGV[1]
   delete ARGV[2]
   # preparse
   split(sql, parts, " ")
   command = parts[1]
   argument = parts[2]
   if (command == "ORDER" || command == "GROUP") {
      command = parts[1] " " parts[2]
      #printf "EXECUTING COMMAND:%s\n", command
      argument = parts[3]
   }

   # kid stuff
   if (command == "HEADER") {
       showHeader(file)
   } else if (command == "SELECT") {
       select(argument, file)
   } else if (command == "WHERE") {
       where(argument, file)
   } else if (command == "GROUP BY") {
       groupBy(argument, file)
   } else if (command == "ORDER BY") {
       orderBy(argument, file)
   }
}
