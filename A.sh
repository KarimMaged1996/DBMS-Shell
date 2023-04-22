#!/bin/bash

function getName(){
	echo -n "what is the name of the table you want to create? "
	read tableName
}


function checkRep(){
while true 
do
	getName #declare the tableName variable
	if test -e $PWD/$tableName
		then
			echo "table already exist, try another name"
			
		else
			
			touch $PWD/$tableName
			break
	fi
done
}

function fieldCharactristics() {

for (( i=1; i<=$1; i++ ))
do	
	isPrimary="notPrimary"
	
	echo -n "what is the name of field $i? " 
	read fieldName
	
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
	
	echo "what is data type of field $i? "
	select choice in "string" "number" 
	do
		choice=$choice 
		break
   	done 
   	
   	
   	createField $fieldName $isPrimary $choice
done
}


function createTable(){

checkRep

#asking the user for the number of field and store the number in a vriable called "numOfFields"
echo -n "how many fields in $tableName ?"
read numOfFields

# assuming that only one field can be a primary key
#'primeryKey' is turned into one when any field is declared to be a primary key
# once any primary key is declared, no other key can be declared that is why the question will no longer be asked  
primeryKey=0
fieldCharactristics $numOfFields

}


function createField() {
	echo -n "$1,$2,$3:" >> $PWD/$tableName
}


createTable 
