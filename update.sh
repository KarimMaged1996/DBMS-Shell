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
function is_string {
	    re='^[a-zA-Z_]+$'
	    if [[ $1 =~ $re ]] ; then
		#echo "Number"
		return 0
	    else
		echo "this field must be a string"
		return 1
	    fi
}

function is_number {
	    re='^[0-9]+$'
	    if [[ $1 =~ $re ]] ; then
		#echo "Number"
		return 0
	    else
		echo "this field must be a number"
		return 1
	    fi
}

#choosing which table to be updated

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
	
	echo "<---------------------->"
}

#choose which field to be updated 
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
		numOfFields=$(head -n 2 $PWD/$1 | tail -n 1 | while read LINE; do echo $LINE | grep -o ':' |wc -l; done)
		numOfFields=$((numOfFields+1))
		#echo $numOfFields
		
	declare -a ARRAY_NAME=()

	for (( i=1; i<=$numOfFields; i++ ))
	do	
		field=$(head -n 2 $PWD/$1 | tail -n 1 | cut -d":" -f $i )
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
			
			#echo $fieldName
			break
		else
			continue
		fi
		
	done
}

#getfield properties and get the new value and validate it
getFieldProp () {
	
	#get the field number 
	fieldNum=$(awk -v var="$1" -F ':' 'NR==2 { for (i=1; i<=NF; i++) if ($i == var) print i}' $PWD/$2)
	echo "field number is: $fieldNum"
	
	#sed -n '3p' $PWD/$2 | grep $1
	
	primaryOrNot=$(head -n 1 $PWD/$2 | cut -d ":" -f $fieldNum | cut -d "," -f 2)
	dataType=$(head -n 1 $PWD/$2 | cut -d ":" -f $fieldNum | cut -d "," -f 3)
	
	echo "constrains are $primaryOrNot and $dataType"
	
	# store all the field values in array
	mapfile -t array1 < <(awk -v var="$fieldNum" -F ':' '{if (NR > 2) print $var}' $PWD/$2)
	echo ${array1[@]}

	#get the value 
	while true
	do
		echo -n "set $1 = "
		read newValue
		
		if [ $primaryOrNot == "primaryKey" ]; then
			if [[ " ${array1[@]} " =~ " ${newValue} " ]]; then
				echo "primary key is unique, can't be repeated"
				continue
			fi
			
			if [ -z "$newValue" ]; then
				echo "primary key can't be a null value"
				continue
			fi
		fi
		
		if [ $dataType == "string" ]; then
			if is_string $newValue ; then
				break
			fi 
		else
			if is_number $newValue ; then
				break
			fi 
		fi
		
	done 
}

#get the condition on which the tabel will be updated 
getCondition() {
	
	echo "what is the condition on which you want to update Ex: name=amr: "
	echo -n "condition:-"
	read condition
	
	conditionField=$(echo $condition | cut -d "=" -f 1 )
	conditionFieldNum=$(awk -v var="$conditionField" -F ':' 'NR==2 { for (i=1; i<=NF; i++) if ($i == var) print i}' $PWD/$1)
	conditionValue=$(echo $condition | cut -d "=" -f 2 )
	
	#echo $conditionField
	#echo $conditionFieldNum
	#echo $conditionValue
	
	
	#awk -v var="$conditionField" -i inplace -F ":" '{gsub("World", "Universe"); print}' $PWD/$1

 }
 
 #check the rows with the conditon and set the value 
 update() {
 	
 	#echo $1
 	#echo $2
 	#echo $3
 	#echo $4
 	awk -v FN="$1" -v NV="$2" -v CFN="$3" -v CFV="$4" -F ":" '{if(NR > 2) if ($CFN == CFV) gsub($FN, NV); print}' $PWD/$5 > tmp && mv tmp $PWD/$5
 	
 	#print $CFN,$CFV,$FN,$NV}' $PWD/$5
 
 }



# the main function which enteract with the user and run other functions
function updateTable(){
	# keep asking for the file name as long as it's either unvalid or repeated
	chooseTable
	
	chooseField $tableName
	
	getFieldProp $fieldName $tableName
	
	getCondition $tableName
	
	update $fieldNum $newValue $conditionFieldNum $conditionValue $tableName

}

deleteFromTable() {
	
	chooseTable
	
	echo "what is the condition on which you want to delete the row Ex: name=amr: "
	echo -n "condition:-"
	read condition
	
	conditionField=$(echo $condition | cut -d "=" -f 1 )
	conditionFieldNum=$(awk -v var="$conditionField" -F ':' 'NR==2 { for (i=1; i<=NF; i++) if ($i == var) print i}' $PWD/$tableName)
	conditionValue=$(echo $condition | cut -d "=" -f 2 )
	
	echo $conditionFieldNum
	echo $conditionValue
	#awk -v CFN="$conditionFieldNum" -v CFV="$conditionValue" -F ":" '{if(NR > 2) if ($CFN == CFV) delete $0; print}' $PWD/$tableName > tmp && mv tmp $PWD/$tableName 
	
	#awk -v CFN="$conditionFieldNum" -v CFV="$conditionValue" -F ":" '{if(NR > 2) if ($CFN == CFV) print $0}' $PWD/$tableName > tmp && mv tmp $PWD/$tableName 
	
	awk -v CFN="$conditionFieldNum" -v CFV="$conditionValue" -F ":" '{if($CFN != CFV)  print}' $PWD/$tableName > tmp && mv tmp $PWD/$tableName 
	
	
}

deleteFromTable 

#updateTable 





