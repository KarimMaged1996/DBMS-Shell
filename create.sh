#!/bin/bash

#check that the filename is valid (txt file)
function checkname() {
	
	if [[ $1 =~ ^[a-zA-Z0-9_]+ ]]; then
		return 0 
	else
		echo "File name is invalid."
		return 1
	fi	
}


# check if a table with the same name exist in the database 
function checkRep(){
	if  [ -f $path/$1 ]; then
		echo "table already exist, try another name"
		return 1
	else
		return 0
	fi
}

function checkExistance(){
	#echo $1
	#echo $2
	if  [ -f $1/$2 ]; then
		return 0
	else
		echo "table doesn't exist, try another name"
		return 1
	fi
	
}


#check if the number of fields is a number return 0 if true and 1 if false 
function is_number {
	    re='^[0-9]+$'
	    if [[ $1 =~ $re ]] ; then
		#echo "Number"
		return 0
	    else
		echo "number of field must be a number"
		return 1
	    fi
}


# assuming that only one field can be a primary key
function getFieldName() {
	local -n arr=$1
	local fieldNum=$2
	#echo ${arr[@]}
	if [ $fieldNum -ne 0 ]; then
			name=$(cut -d ":" -f $fieldNum $path/$tableName | cut -d "," -f 1) 
			#echo $name
			arr+=($name)
			#echo ${arr[@]}
	fi

	while true
	do	
		#get names of the created fields
		#echo $fieldNum
		#ask for the name of the new field
		echo -n "what is the name of field $3? " 
		read fieldName
		
		if [[ " ${arr[@]} " =~ " ${fieldName} " ]]; then
		
			echo "there is a field with the same name"
		else
			#echo "variable is not in array"
			break
		fi
	done
}


#'primeryKey' is turned into "1" when any field is declared to be a primary key
# once any primary key is declared, no other key can be declared that is why the question will no longer be asked 
function primeryOrNot(){
	if [ $primeryKey -eq 0 ];
	then
		echo "Is field $i a primary key? "
		select yesOrNo in "yes" "no"
		do
			case $yesOrNo in 
				"yes" )
					isPrimary="primary"
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


#data type is either a string or a number 
function dataType() {
	echo "what is data type of field $i? "
	select choice in "string" "number" 
	do
		choice=$choice 
		break
   	done 
}


# store the field info in the created table following this pattern field1(name,primary,datatype):field2 
function createField() {
	#echo $6
		if [ $4 -ne $5 ]; then
			echo -n "$1,$2,$3:" >> $6/$tableName
		else
			echo -n "$1,$2,$3" >> $6/$tableName
		fi
}


# the main function which enteract with the user and run other functions
function createTable(){
	#cd $1
	#echo $1
	path=$1
	# keep asking for the file name as long as it's either unvalid or repeated
	while true
	
	do
		echo -n "what is the name of the table you want to create? "
		read tableName
		
		if checkname $tableName ; then 
			:
		else
			continue
		fi
		
		if checkRep $tableName ; then
			touch $1/$tableName
			break
		else 
			continue 
		fi 
	done


	#asking the user for the number of field and store the number in a vriable called "numOfFields"
	while true
	
	do
		echo -n "how many fields in $tableName ?"
		read numOfFields
		
		if is_number $numOfFields ; then
			break
		fi
	done
 	
	primeryKey=0
	declare -a ARRAY_NAME=()
	fieldNum=0
	
	#loopin over the fields to add to the table
	for (( i=1; i<=$numOfFields; i++ ))
		do
			getFieldName ARRAY_NAME $fieldNum $i
			
			((fieldNum++))
			
			isPrimary="notprimary"
			
			primeryOrNot
			
			dataType
			
			
			createField $fieldName $isPrimary $choice $i $numOfFields $path
		done
	
	# adding a line break and adding the heading row with " : " seperating each 
	echo -e "" >> $path/$tableName
	
	for (( i=1; i<=$numOfFields; i++ ))
	do	
		if [ $i -eq $numOfFields ]; then
			echo -n $(cut -d ":" -f $i $path/$tableName | cut -d "," -f 1) >> $path/$tableName
		else 
			
			echo -n $(cut -d ":" -f $i $path/$tableName | cut -d "," -f 1)":" >> $path/$tableName
		fi
	done
	echo -e "" >> $path/$tableName
}


listTables() {
	ls $1
}

dropTables() {
        #echo "here"
        #echo "$1"
	#path=$1
	while true
	do
		echo "which table do you want to drop ?"
		read table
		if checkExistance $1/$table ; then 
			break 
		else 
			echo "this table doesn't exist"
			continue 
		fi
	done
	
	
	rm $1/$table
	
}


#path=$PWD/root/DB1

#createTable $path


#listTables





