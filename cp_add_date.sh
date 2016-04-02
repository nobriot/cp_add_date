#!/bin/bash
#
# This scripts takes a file as an argument and copies
# it into the same folder with a timestamp preprended.
#

#This is a function that displays the help
function print_help
{
	echo "usage: cp_add_date filename [destination_folder]"
	echo "       cp_add_date folder_name [destination_folder]"
}

#First check whether the argument has been passed and whether it is indeed a file
# [ -z ] -> Verify if the string is empty
# [ -f ] -> Verify if it is a file
# [ -d ] -> Verify if it is a directory/folder
if [ -z $1 ] || [ ! -f $1 ] && [ ! -d $1 ] ; then
	echo "You must specify a filename or folder name as the first argument"
	print_help
	exit
fi

#We also throw an error if there is a $2 argument but it is not a directory
if [ ! -z $2 ] && [ ! -d $2 ] ; then
	echo "The second argument is not a valid destination folder"
	print_help
	exit
fi

#First create a date suffix, that we will add to the beginning of the copied file
date_suffix=$(date +%Y_%m_%d_)

#Function that finds the filename / folder / number of folders from $1
# and assigns them in $filename, $number_of_folders and $folder_name
function find_folder_and_filename
{
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
}

# Now we get to process the input : check whether there is a specific destination folder
if [ -z $2 ] ; then
	#Now parse the filename to check whether it is absolute or relative filename
	if [[ $1 == /* ]] || [[ $1 == .* ]]
	then
		#echo "Absolute path or path starting with . or .. "
		# Assign $filename, $number_of_folders and $folder_name
		find_folder_and_filename

		#Now we issue the commmand
		echo "1) Copying $1 into $folder_name$date_suffix$filename"
		cp -R $1 $folder_name$date_suffix$filename
	else
		echo "2) Copying $1 into $date_suffix$filename"
		cp -R $1 $date_suffix$1
	fi
else
	#We have a destination folder, so the cp -R Command will be a bit different

	# Do the same as for with no $2 specified.
	#Now parse the filename to check whether it is absolute or relative filename
	if [[ $1 == /* ]] || [[ $1 == .* ]]
	then
		# Assign $filename, $number_of_folders and $folder_name
		find_folder_and_filename

		# Now we issue the commmand
		# We check whether there was a "/" provided at the end of the destination folder
		if [[ $2 == */ ]] ; then
			echo "3) Copying $1 into $2$date_suffix$filename"
			cp -R $1 $2$date_suffix$filename
		else
			echo "4) Copying $1 into $2/$date_suffix$filename"
			cp -R $1 $2/$date_suffix$filename
		fi

	else
		# We check whether there was a "/" provided at the end of the destination folder
		if [[ $2 == */ ]] ; then
			echo "5) Copying $1 into $2$date_suffix$1"
			cp -R $1 $2$date_suffix$1
		else
			echo "6) Copying $1 into $2/$date_suffix$1"
			cp -R $1 $2/$date_suffix$1
		fi
	fi
fi
