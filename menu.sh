#! /usr/bin/bash
source A.sh
source insert.sh
source select.sh

# function to create the database
createDatabase() {
  # -p to avoid the error message if the root directory already exists
  mkdir -p $PWD/root/
  mkdir $PWD/root/"$1"
}

listDatabases() {
  # ls the root directory where databases exist
  # use cut to exclude the .txt in the database name
  ls $PWD/root 
}

# create a menu
connectToDatabase() {
  select choice in "Create Table" "List Tables" "Drop Table" "insert into Table" " select from Table" " Delete From Table" "Update Table" "Back to main menu"; do
    case $choice in
    "Create Table") 
 	createTable $1   
 	break
    ;;
    "List Tables") 
    	listTables $1
    	break
    ;;
    "Drop Table") 
    	dropTables $1
    	break
    ;;
    "insert into Table")
    echo "which table do you want to insert into"
    read table
    # echo $1
    while  [ ! -f $1/$table ];
    do
      echo "this table does not exist"
      read table
    done
      insertUI $1/$table

    ;;
    " select from Table") 
     echo "which table do you want to select from"
    read table
    # echo $1
    while  [ ! -f $1/$table ];
    do
      echo "this table does not exist"
      read table
    done
     selectFromTable $1/$table
    ;;
    " Delete From Table") ;;
    "Update Table") ;;
    "Back to main menu")
      menuUI
      ;;
    *)
      echo $REPLY is not a valid choice
      ;;
    esac
  done
}

# this function takes database name as a parameter and delete it
dropDatabase() {
  rm -r $PWD/root/$1
}

menuUI() {
  select choice in "create Database" "List Databases" "Connect to Database" "Drop Database" "Exit"; do
    case $choice in

    # choice one to create a database
    "create Database")
      echo type the name of the database
      read databaseName
      while [ -z $databaseName ]; do
        echo you Must enter a name
        read databaseName
      done

      # to check if the database already exists
      if [ -d $PWD/root/$databaseName ]; then
        echo the database already exists Now you are back to the main menu
        
      else
        createDatabase $databaseName
        echo your Database was created successfully
      fi
      ;;

    # choice to to list databases
    "List Databases")
      listDatabases
      ;;

    # choice three to connect to databases
    # take the name of the database from the user and store in in a variable $databaseToConnet
    # this variable will be used inside all the other functions
    "Connect to Database")
      echo which database you want to connect to
      read databaseToConnect
      while [ -z $databaseToConnect ]; do
        echo you Must enter a name
        read databaseToConnect
      done
      # to check if the database exist
      if [ -d $PWD/root/$databaseToConnect ]; then
        connectToDatabase $PWD/root/$databaseToConnect
      else
        echo "this database doesn't exist Now you are back to the main menu"
      fi

      ;;

    #
    "Drop Database")
      echo type the name of the database you want to drop
      read databaseToDrop
      while [ -z $databaseToDrop ]; do
        echo you Must enter a name
        read databaseToDrop
      done

      if [ -d $databaseToDrop ]; then
        dropDatabase $databaseToDrop
      else
        echo "The database you want to delete does't exist Now you are back to the main menu"
      fi
      ;;
    'Exit') break
    ;;
    *)
      echo $REPLY is not a valid choice
      ;;
    esac
  done

}

menuUI
