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

