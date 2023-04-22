#! /usr/bin/bash

# function to create the database
createDatabase(){
  # -p to avoid the error message if the root directory already exists
  mkdir -p $PWD/root/
  mkdir $PWD/root/"$1"
}

listDatabases(){
  # ls the root directory where databases exist 
  # use cut to exclude the .txt in the database name
  ls $PWD/root | cut -d. -f1
}

# create a menu 
connectToDatabase(){
select choice in "Create Table" "List Tables" "Drop Table" "insert into Table"   " select from Table" " Delete From Table" "Update Table" "Back to main menu"
 do
case $choice in 
"Create Table")
;;
"List Tables" )
;;
"Drop Table" )
;;
"insert into Table")
;;
" select from Table")
;;
" Delete From Table")
;;
"Update Table")
;;
 "Back to main menu") menuUI
;;
*) echo $REPLY is not a valid choice
;;
esac 
done 
}


dropDatabase(){
  rm -r $PWD/root/$1
}

menuUI(){
select choice in "create Database" "List Databases" "Connect to Database" "Drop Database"
do 
case $choice in 

# choice one to create a database
"create Database" ) 
echo type the name of the database
read databaseName
while [ -z $databaseName  ]
do 
echo you Must enter a name
read databaseName
done

# to check if the database already exists
if [ -d $PWD/root/$databaseName ]
then
echo the database already exists Now you are back to the main menu
continue
else
createDatabase $databaseName
echo your Database was created successfully
fi 
;;

# choice to to list databases
"List Databases" ) listDatabases
;;

# choice three to connect to databases
# take the name of the database from the user and store in in a variable $databaseToConnet
# this variable will be used inside all the other functions
"Connect to Database" )
echo which database you want to connect to
read databaseToConnect
while [ -z $databaseToConnect  ]
do 
echo you Must enter a name
read databaseToConnect
done
# to check if the database exist
if [ -d $PWD/root/$databaseToConnect ]
then
connectToDatabase
else 
echo "this database doesn't exist Now you are back to the main menu"
fi

;;

# 
"Drop Database" ) 
echo type the name of the database you want to drop
read databaseToDrop
while [ -z $databaseToDrop ]
do 
echo you Must enter a name
read databaseToDrop
done

if [ -d $databaseToDrop ]
then
dropDatabase $databaseToDrop
else
  echo "The database you want to delete does't exist Now you are back to the main menu"
fi
;;
*) echo $REPLY is not a valid choice
;;
esac
done

}


menuUI;