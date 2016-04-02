#!/bin/bash
#
# This scripts takes a file as an argument and copies
# it into the same folder with a timestamp preprended.
#
# TO DO : Do a help function displaying the usage
# TO DO : Make a second parameter which is the destination folder


#First check whether the argument has been passed and whether it is indeed a file
if [ -z $1 ] || [ ! -f $1 ] && [ ! -d $1 ]
then
	echo "You must specify a filename"
	exit
fi

#First creating a date suffix
date_suffix=$(date +%Y_%m_%d_)

#Now parse the filename to check whether it is absolute or relative filename
if [[ $1 == /* ]] || [[ $1 == .* ]]
then
	echo "Absolute path or path starting with . or .. "
	#Count the amount of / in the filename, to find how many folders we go accross
	number_of_folders=$(grep -o / <<< "$1" | wc -l)
	echo "Number of folders : " $number_of_folders

	#We take care of the case it is a folder and it finishes with a /
	if [[ $1 == */ ]]
	then
		number_of_folders=$((number_of_folders-1))
	fi

	#Pick the last part in order to get the filename
	filename=$(echo $1| cut -d '/' -f $((number_of_folders+1)))
	echo "Filename is "$filename

	#Re-add the / or . or .. in front of the path
	if [[ $1 == /* ]]
	then
		folder_name="/"
	elif [[ $1 == ..* ]]
	then
		folder_name="../"
	elif [[ $1 == .* ]]
	then
		folder_name="./"
	fi

	#Reconstruct the folder name
	for (( i=1; i<$number_of_folders; i++ ))
	do
		folder_name+=$(echo $1| cut -d '/' -f $((i+1)))/
		#echo "folder : " $folder_name
	done

	#Now we issue the commmand
	echo "Copying $1 into $folder_name$date_suffix$filename ..."
	cp -R $1 $folder_name$date_suffix$filename
else
	echo "Copying $1 into $date_suffix$filename ..."
	cp -R $1 $date_suffix$1
fi
