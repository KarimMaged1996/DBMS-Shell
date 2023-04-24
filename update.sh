#!/bin/bash

#check that the filename is valid
function checkname() {
	
	if [[ $1 =~ ^[a-zA-Z0-9_]+\.[tT][xX][tT]$ ]]; then
		return 0 
	else
		echo "File name is invalid."
		return 1
	fi	
}


# check if a table with the same name exist in the database 
function checkExistance(){
	
	if  [ -f $PWD/$1 ]; then
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
			name=$(cut -d ":" -f $fieldNum $PWD/$tableName | cut -d "," -f 1) 
			#echo $name
			arr+=($name)
			#echo ${arr[@]}
	fi

	while true
	do	
		#get names of the created fields
		#echo $fieldNum
		#ask for the name of the new field
		echo -n "what is the name of field $i? " 
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
		if [ $4 -ne $5 ]; then
			echo -n "$1,$2,$3:" >> $PWD/$tableName
		else
			echo -n "$1,$2,$3" >> $PWD/$tableName
		fi
}

function chooseTable(){
	while true
	
	do
		echo "what is the name of the table you want to update? "
		echo "the tabels available in the current database are :-"
		ls .
		echo -n ":"
		read tableName
		
		echo "<---------------------->"
		
		if checkname $tableName ; then 
			:
		else
			continue
		fi
		
		if checkExistance $tableName ; then 
			
			numOfLines=$(wc -l $tableName | cut -d " " -f 1)
			#echo $numOfLines
			numToPrint=$((numOfLines-2))
			#echo $numToPrint
			tail -n $numToPrint $PWD/$tableName
			break
			
		else
			continue
		fi
	done

}


chooseField () {
	
	while true
	do
		echo "what is the name of the field you want to update in $tableName? "
		echo "the fields available in the current database are :-"
		
		# is seprator is " : " 
		#numOfFields=$(head -n 3 $PWD/$1 | tail -n 1 | wc -w)
		#numOfFields=$((numOfFields+1))
		#numOfFields=$((numOfFields/2))
		
		#if the seprator is ":" 
		numOfFields=$(head -n 3 $PWD/$1 | tail -n 1 | while read LINE; do echo $LINE | grep -o ':' |wc -l; done)
		numOfFields=$((numOfFields+1))
		#echo $numOfFields
		
	declare -a ARRAY_NAME=()

	for (( i=1; i<=$numOfFields; i++ ))
	do	
		field=$(head -n 3 $PWD/$1 | tail -n 1 | cut -d":" -f $i )
		#echo $field
		ARRAY_NAME+=( "$field" )
		#echo ${ARRAY_NAME[@]}
	done
		
		echo ${ARRAY_NAME[@]}
		#echo $numOfFields
		#echo "number of fields:"$numOfFields
		echo -n ":"
		read fieldName
		echo "<---------------------->"
		
		if [[ " ${ARRAY_NAME[@]} " =~ " ${fieldName} " ]]; then
			
			echo $fieldName
			break
		else
			continue
		fi
		
	done
}

getFieldProp () {
	
	#get the field number
	echo "prop of $1"
	x=$1
	#echo $x
	awk -v var="$x" -F ':' 'NR==3 { for (i=1; i<=NF; i++) if ($i == var) print i}' $PWD/$2
	#sed -n '3p' $PWD/$2 | grep $1

}




# the main function which enteract with the user and run other functions
function updateTable(){
	# keep asking for the file name as long as it's either unvalid or repeated
	chooseTable
	
	chooseField $tableName
	
	getFieldProp $fieldName $tableName
	
}



updateTable 





