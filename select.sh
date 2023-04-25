#! /usr/bin/bash

# this function takes one parameter the name of the database to select from
# it then ask for a table and validate it exists and if so it returns the table
askForTable(){
  echo which table do you want to select from
  read table
  table+='.txt'
  while [ ! -f $PWD/$1/$table ]
    do
      echo this table does not exist please enter a valid table
      read table
      table+='.txt'
    done
  echo $table
}
