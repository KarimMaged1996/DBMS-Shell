#! /usr/bin/bash

# this function takes one parameter the name of the path to select from
# it then ask for a table and validate it exists and if so it returns the table
askForTable(){
  echo which table do you want to select from
  read table
  table+='.txt'
  while [ ! -f $1/$table ]
    do
      echo this table does not exist please enter a valid table
      read table
      table+='.txt'
    done
  echo $1/s$table
}


# this function will take one parameter the path to table to select from
selectFromTable(){
  echo please type the column names that you want to select, separated by commas
  echo those are the available columns
  # variable to hold all columns from a table
  cols=`head -n 2 $1 | tail -1`
  noOfCols=`awk -F: '{print NF}' <<< $cols ` # get the num of cols in the table 
  changeText=`echo $cols | sed 's/:/,/g' ` # change the : to a , to be more readable
  echo $changeText
  while true
    do
    read colsToSelect
    local IFS=','   # change the default separator from tab to , to search inside user input
    for col in $colsToSelect
      do
        # check is a col name doesn't exist in the table
        if ! grep -q $col <<< $cols
          then
            echo one or more of the columns you entered does not exist in the table
            echo or you used a wrong syntax    
            continue 3 # will keep in the while loop until all cols exist
        fi 
    done
    break 3
  done
  # get the numbers of columns the user chose and put them in a comma separated string
  chosenColsNums=''
  for col in $colsToSelect
  do
    num=`echo $cols | awk  -v l=$noOfCols -v c=$col -F ":" '{for (i=1;i<=l;i++) if ($i == c ) print i}' `
    echo $num
    chosenColsNums+=$num
    chosenColsNums+=','
  done
  chosenColsNums=${chosenColsNums%?} # parameter expansion to remove the last comma
  data=`tail -n +2 $1 | cut -d: -f"$chosenColsNums" `
 
  
  # the conditions to specify which record to disaplay
  echo "type in the condition the selection based on"
  echo "'example: colName=value', colName>value, colName<value, all"
  read condition
  if [ $condition == 'all' ] # if user selects all, all the records will be displayed
  then
    echo $data | column -t -s':' -o'   |   '

  # if the user selects =, data variable is passed to awk to display the first line
  # then a comparison is made to diplay only records that match a condition
  elif grep -q '=' <<< $condition
  then 
      beforeEqual=`echo $condition | cut -d '=' -f1 `
      # get the column number based on the data variiable not the file
      feildNum=`echo $data | head -n +1 | awk  -v l=$noOfCols -v c=$beforeEqual -F ":" '{for (i=1;i<=l;i++) if ($i == c ) print i}' `
      
      afterEqual=`echo $condition | cut -d '=' -f2 `
      
      finalData=`echo $data | awk -F ':' -v n=$feildNum -v v=$afterEqual '{if (NR ==1 || $n == v) {print $0}}' `
      echo $finalData | column -t -s':' -o'   |   '
     
  # if the user selects =, data variable is passed to awk to display the first line
  # then a comparison is made to diplay only records that match a condition
  elif grep -q '<' <<< $condition
  then
      beforeEqual=`echo $condition | cut -d '<' -f1 `
      
      feildNum=`echo $data | head -n +1 | awk  -v l=$noOfCols -v c=$beforeEqual -F ":" '{for (i=1;i<=l;i++) if ($i == c ) print i}' `
      
      afterEqual=`echo $condition | cut -d '<' -f2 `
    
      finalData=`echo $data | awk -F ':' -v n=$feildNum -v v=$afterEqual '{if (NR == 1 || $n < v) {print $0}}' `
      echo $finalData | column -t -s':' -o'   |   '
  
  # if the user selects =, data variable is passed to awk to display the first line
  # then a comparison is made to diplay only records that match a condition
  elif grep -q '>' <<< $condition
  then
      beforeEqual=`echo $condition | cut -d '>' -f1 `
     
      feildNum=`echo $data | head -n +1 | awk  -v l=$noOfCols -v c=$beforeEqual -F ":" '{for (i=1;i<=l;i++) if ($i == c ) print i}' `
     
      afterEqual=`echo $condition | cut -d '>' -f2 `
     
      finalData=`echo $data | awk -F ':' -v n=$feildNum -v v=$afterEqual '{if (NR == 1 || $n > v) {print $0}}' `
      echo $finalData | column -t -s':' -o'   |   '
  fi 
  

}

# selectFromTable dummy/employee.txt


