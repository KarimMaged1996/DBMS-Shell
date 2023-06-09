#! /usr/bin/bash
source create.sh
source insert.sh
source select.sh
source update.sh

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
  select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select from Table" "Delete From Table" "Update Table" "Back to main menu"; do
    case $choice in
    "Create Table") 
 	createTable $1   
  echo your table was created successfully press enter to continue
    ;;
    "List Tables") 
    	listTables $1
    ;;
    "Drop Table") 
      echo those are the available tables in the database
      listTables $1
    	dropTables $1
      echo the table was deleted successfully press enter to continue
    ;;
    "Insert into Table")
    echo "which table do you want to insert into"
    echo those are the available tables
    listTables $1
    read table
    # echo $1
    while  [ ! -f $1/$table ];
    do
      echo "this table does not exist"
      read table
    done
      insertUI $1/$table
      echo the insert was successful press enter to continue

    ;;
    "Select from Table") 
     echo "which table do you want to select from"
     echo those are the available tables
     listTables $1
    read table
    # echo $1
    while  [ ! -f $1/$table ];
    do
      echo "this table does not exist"
      read table
    done
     selectFromTable $1/$table
    ;;
    "Delete From Table")
    deleteFromTable $1
    echo the delete was successfull press enter to continue
     ;;
    "Update Table") 
    updateTable $1
    echo your table was updated successfully, press enter to continue
    ;;
    "Back to main menu")
    echo you are back to main menu press enter to continue
      break
      
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
        echo your Database was created successfully, Press enter to continue
      fi
      ;;

    # choice to to list databases
    "List Databases")
      listDatabases
      echo press enter to continue
      ;;

    # choice three to connect to databases
    # take the name of the database from the user and store in in a variable $databaseToConnet
    # this variable will be used inside all the other functions
    "Connect to Database")
      echo which database you want to connect to
      listDatabases
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
      echo those are the available tables
      listDatabases
      read databaseToDrop
      while [ -z $databaseToDrop ]; do
        echo you Must enter a name
        read databaseToDrop
      done

      if [ -d $PWD/root/$databaseToDrop ]; then
        dropDatabase $databaseToDrop
        echo "$databaseToDrop was deleted successfully, press enter to continue"
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
