#!/bin/bash

function getName(){
	echo -n "what is the name of the table you want to create? "
	read tableName
}


function checkRep(){
while true 
do
	getName #declare the tableName variabel
	if test -e $PWD/$tableName
		then
			echo "table already exist, try another name"
			
		else
			
			touch $PWD/$tableName
			break
	fi
done
}

function fieldCharactristics(){


}


function createTable(){

checkRep

echo -n "how many fields in $tableName ?"
read numOfFields

primeryKey=0

for (( i=1; i<=$numOfFields; i++ ))
do	
	echo $primeryKey
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



# check that the table doesn't exist
}


function createField() {
	echo -n "$1,$2,$3:" >> $PWD/$tableName
}


createTable 
