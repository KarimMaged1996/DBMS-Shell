#!/bin/bash

#get the name of the table from the user 
function getName(){
while true 
do
	echo -n "what is the name of the table you want to create? "
	read tableName
	checkname $tableName
	if [ $x -eq 1 ]; then
		break
	fi
done
}

function checkname() {
	
	if [[ $1 =~ ^[a-zA-Z0-9_]+\.[tT][xX][tT]$ ]]; then
		echo "File name is valid."
		x=1
	else
		echo "File name is invalid."
		x=0
	fi	
}

# check if a table with the same name exist in the database 
function checkRep(){

	if  [ -f $PWD/$1 ];
	then
		echo "table already exist, try another name"
		x=0
		echo $x
	fi
}

# assuming that only one field can be a primary key
#'primeryKey' is turned into one when any field is declared to be a primary key
# once any primary key is declared, no other key can be declared that is why the question will no longer be asked 

function getFieldName() {
	echo -n "what is the name of field $i? " 
	read fieldName
}

function primeryOrNot(){
	if [ $primeryKey -eq 0 ];
	then
		echo "Is field $i a primary key? "
		select yesOrNo in "yes" "no"
		do
			case $yesOrNo in 
				"yes" )
					isPrimary="primaryKey"
					primeryKey=1
					break
				;;
				
				"no" )
					break
				;;
			
			esac
		done
	fi
}

function dataType() {
	echo "what is data type of field $i? "
	select choice in "string" "number" 
	do
		choice=$choice 
		break
   	done 
}


function createField() {
	if [ $4 -ne $5 ]; then
		echo -n "$1,$2,$3:" >> $PWD/$tableName
	else
		echo -n "$1,$2,$3" >> $PWD/$tableName
	fi
}


function createTable(){

while true 
do
	echo -n "what is the name of the table you want to create? "
	read tableName
	checkname $tableName
	checkRep $tableName
	if [ $x -eq 1 ]; then
		touch $PWD/$tableName
		break
	fi
	
done


checkRep

#asking the user for the number of field and store the number in a vriable called "numOfFields"
echo -n "how many fields in $tableName ?"
read numOfFields
 
primeryKey=0

for (( i=1; i<=$numOfFields; i++ ))
do
	getFieldName
	
	isPrimary="notPrimary"
	primeryOrNot
	
	dataType
	
	createField $fieldName $isPrimary $choice $i $numOfFields

done

}


createTable 
