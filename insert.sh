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
read x
isNotEmpty $x