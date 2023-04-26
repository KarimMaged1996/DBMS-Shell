#! /usr/bin/bash

# function that will get constrains for each column
# it takes two parameters (number of column to check, path of file)
# it constructs an empty array, and from the first line of a file it gets the constrains
# of specific column and push them to the array.
# it returns a string representation of the array
getConstrains() {
  constrainArr=()
  for ((i = 1; i <= 4; i++)); do
    constrainArr+=($(head -1 $2 | cut -d: -f$1 | cut -d "," -f$i))
  done
  echo ${constrainArr[*]}
}

# function that will check if the user input is a number
isNumber() {
  if [[ $1 =~ ^[0-9]+$ ]]; then
    echo true
  else
    echo false
  fi
}

# function that will check that the input is not empty
isNotEmpty() {
  if [ -z "$1" ]; then
    echo false
  else
    echo true
  fi
}

# function that will check if an input is string
isString() {
  if [[ $1 =~ ^[a-zA-Z]+$ ]]; then
    echo true
  else
    echo false
  fi
}

# function that will check if a value is not repeated in its column in other records
# it will take three args (col num, value, file path)
# the function works by grepping the value from its col, if the grep was empty string
# then the value is unique else it is repeated
isUnique() {
  if [ $# == 2 ]; then
    echo false
  else
    colNum=$1
    value=$2
    filePath=$3
    # the option -v is used to be able to use colNum inside the dollar sign
    check=$(awk -v c=$colNum 'BEGIN {FS = ":"} FNR > 2 { print $c }' $filePath | grep $value)
    if [ -z $check ]; then
      echo true
    else
      echo false
    fi
  fi
}

# this function will check whether a function is null or not
isNotNull() {
  if [[ $1 == 'null' ]]; then
    echo false
  else
    echo true
  fi
}

# this function will create the UI it will take one parameter file path
insertUI() {
  noOfCols=$(awk -F: ' FNR < 2 {print NF}' $1)
  for ((i = 1; i <= $noOfCols; i++)); do
    consts=$(getConstrains $i $1)
    ifPrimary=$(echo $consts | cut -d" " -f2)
    intOrStr=$(echo $consts | cut -d" " -f3)

    #01 if the col is primary and number
    if [[ $ifPrimary == 'primary' && $intOrStr == 'number' ]]; then
      echo $(head -2 $1 | tail -1 | cut -d: -f$i)
      read val

      # check that input is not empty, null, repeated and is number
      emptyBool=$(isNotEmpty $val)
      numberBool=$(isNumber $val)
      nullBool=$(isNotNull $val)
      uniqueBool=$(isUnique $i $val $1)
      while [[ $emptyBool == 'false' || $numberBool == 'false' || $nullBool == 'false' || $uniqueBool == 'false' ]]; do
        echo "This value is invalid"
        echo "make sure the input is unique,non-emty,not null and a number"
        read val
        emptyBool=$(isNotEmpty $val)
        numberBool=$(isNumber $val)
        nullBool=$(isNotNull $val)
        uniqueBool=$(isUnique $i $val $1)
      done
      if [ $i == 1 ]; then # if it is the first column create a new line
        val+=":"
        echo $val >>$1
      elif [ $i == $noOfCols ]; then # if it is the last column don't append : to val
        sed -i '$s/$/'$val'/' $1
      else
        val+=":"
        sed -i '$s/$/'$val'/' $1
      fi
    fi

    #02 if the col is primary and string
    if [[ $ifPrimary == 'primary' && $intOrStr == 'string' ]]; then
      echo $(head -2 $1 | tail -1 | cut -d: -f$i)
      read val

      # check that input is not empty, null, repeated and is number
      emptyBool=$(isNotEmpty $val)
      stringBool=$(isString $val)
      nullBool=$(isNotNull $val)
      uniqueBool=$(isUnique $i $val $1)
      while [[ $emptyBool == 'false' || $stringBool == 'false' || $nullBool == 'false' || $uniqueBool == 'false' ]]; do
        echo "This value is invalid"
        echo "make sure the input is unique,non-emty,not null and a string"
        read val
        emptyBool=$(isNotEmpty $val)
        stringBool=$(isString $val)
        nullBool=$(isNotNull $val)
        uniqueBool=$(isUnique $i $val $1)
      done
      if [ $i == 1 ]; then # if it is the first column create a new line
        val+=":"
        echo $val >>$1
      elif [ $i == $noOfCols ]; then # if it is the last column don't append : to val
        sed -i '$s/$/'$val'/' $1
      else
        val+=":"
        sed -i '$s/$/'$val'/' $1
      fi
    fi

    #3 if the col is notprimary and number
    if [[ $ifPrimary == 'notprimary' && $intOrStr == 'number' ]]; then
      echo $(head -2 $1 | tail -1 | cut -d: -f$i)
      read val

      # check that input is not empty, null, repeated and is number
      emptyBool=$(isNotEmpty $val)
      numberBool=$(isNumber $val)
      while [[ $emptyBool == 'false' || $numberBool == 'false' ]]; do
        echo "This value is invalid"
        echo "make sure the input is non-emty,and a number"
        read val
        emptyBool=$(isNotEmpty $val)
        numberBool=$(isNumber $val)
      done
      if [ $i == 1 ]; then # if it is the first column create a new line
        val+=":"
        echo $val >>$1
      elif [ $i == $noOfCols ]; then # if it is the last column don't append : to val
        sed -i '$s/$/'$val'/' $1
      else
        val+=":"
        sed -i '$s/$/'$val'/' $1
      fi
    fi

    #04 if the col is notprimary and string
    if [[ $ifPrimary == 'notprimary' && $intOrStr == 'string' ]]; then
      echo $(head -2 $1 | tail -1 | cut -d: -f$i)
      read val

      # check that input is not empty, null, repeated and is number
      emptyBool=$(isNotEmpty $val)
      stringBool=$(isString $val)
      while [[ $emptyBool == 'false' || $stringBool == 'false' ]]; do
        echo "This value is invalid"
        echo "make sure the input is non-emty,and a string"
        read val
        emptyBool=$(isNotEmpty $val)
        stringBool=$(isString $val)
      done
      if [ $i == 1 ]; then # if it is the first column create a new line
        val+=":"
        echo $val >>$1
      elif [ $i == $noOfCols ]; then # if it is the last column don't append : to val
        sed -i '$s/$/'$val'/' $1
      else
        val+=":"
        sed -i '$s/$/'$val'/' $1
      fi
    fi

  done
}

insertUI dummy/employee.txt
# read val
# bool=`isNotEmpty $val`
# while  [ $bool == 'false' ]
# do
# echo invalid
# read val
# bool=`isNotEmpty $val`
# done
# echo $val

# isUnique 1 dummy/employee.txt

# sed -i '$s/$/'$val'/' $1
