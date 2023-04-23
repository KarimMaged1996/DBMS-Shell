#! /usr/bin/bash

# function that will get constrains for each column
# it takes two parameters (number of column to check, path of file)
# it constructs an empty array, and from the first line of a file it gets the constrains
# of specific column and push them to the array. 
# it returns a string representation of the array
getConstrains(){
  constrainArr=()
  for (( i=1;i<=4;i++))
  do
    constrainArr+=(`head -1 $2 | cut -d: -f$1 | cut -d "," -f$i`);
  done 
  echo $constrainArr
}

# function that will check if the user input is a number
isNumber(){
   if [[ $1 =~ ^[0-9]+$ ]]
  then 
      echo true
   else
      echo false
   fi
}

# function that will check that the input is not empty 
isNotEmpty(){
  if [ -z $1 ]
  then 
     echo false
  else 
     echo true
  fi
}

# function that will check if an input is string
isString(){
   if [[ $1 =~ ^[a-zA-Z]+$ ]]
  then 
      echo true
   else
      echo false
   fi
}


# function that will check if a value is not repeated in its column in other records
# it will take three args (col num, value, file path)
# the function works by grepping the value from its col, if the grep was empty string
# then the value is unique else it is repeated
isUnique(){
  colNum=$1; value=$2; filePath=$3;
  # the option -v is used to be able to use colNum inside the dollar sign 
  check=`awk -v c=$colNum 'BEGIN {FS = ":"} FNR > 2 { print $c }' $filePath | grep $value`
  if [ -z $check ]
  then 
     echo true
  else 
     echo false
  fi 
}

# this function will check whether a function is null or not
isNotNull(){
  if [ $1 == 'null' ]
  then
     echo false
  else
     echo true
  fi
}
