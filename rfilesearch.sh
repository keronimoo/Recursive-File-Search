#! /bin/bash



#Implementation of the Second Function
function displayModificationDetails
{
	fileNumber="$1" # parameter one
	file="$2"  # parameter two
	currentDirectory="$3" # parameter three
	mainDirectory="$4" # paramater four
	
	# Format Specifications - Displaying the modifications details
	user=$(stat -c '%U' "$currentDirectory/$file") # -c for specified format , %U for user name of the owner 
	lastModified=$(stat -c '%y' "$currentDirectory/$file") # -c for specified format , %y for time of last data modification - human readable
	dateFormat=$(date -d "$lastModified" +"%B %d, %Y at %H.%M") # time specified by a string 
	
	echo "File $((fileNumber)): found_$file was modified by $user on $dateFormat"
	echo "File $((fileNumber)): found_$file was modified by $user on $dateFormat" >> "$mainDirectory/Found/modification_details.txt" # Writing the output to the file
}

#Implementation of the First Function
function search
{
	directory=$1 # paramater one
	keyword=$2 # parameter two

	if [ ! -d "$directory/Found" ]; then # if "Found" directory does not exists, create one 
		mkdir "$directory/Found"
	fi
	
	#Searching the File(recursive)
	files=($(grep -w -rl --exclude-dir="Found" "$keyword" "$directory")) # recursivly search all files in a directory, store results in an array. Exclude the "Found" directory if the user wants to execute the script more than once in same the txt files for avoiding stat errors 
	
	fileCounter=0 #this variable is for counting file number and passing the file number to the displayModificationDetails
	
	if [ ${#files[@]} -eq 0 ]; then #check if any file found in the directory
		echo "Keyword not found in files"
		rmdir "$directory/Found" #after seeing an answer of the instructor for a question if no keyword is found , the found directory will be removed with this line
	else
		echo "Files were copied to the Found directory"
		
		# the for loop is for completing below tasks
		#1)Changing file Names
		#2)Copying the files to the Found directory
		#3)Display the messege
		for file in "${files[@]}";
		do
			if grep -w -q "$keyword" "$file"; then
				cp "$file" "$directory/Found/found_$(basename "$file")" # 1-2
				((fileCounter++))
				displayModificationDetails "$fileCounter" "$(basename "$file")" "$(dirname "$file")" "$directory" # 3
			fi
		done
		
		
	fi
}



echo -n "Enter the name of the directory: " # -n for without new line
read directory

if [ ! -d $directory ]; then   # if directory does not exist , exit
	echo "Directory does not exists"
	exit 1
fi

if [ -z "$directory" ]; then   # if directory name is empty , exit
	echo "Invalid Directory Input"
	exit 1
fi




echo -n "Enter the Keyword: " # -n for without new line
read keyword

if [ -z "$keyword" ]; then  # if keyword is empty , exit
	echo "Invalid Keyword Input"
	exit 1
fi

search $directory $keyword


	

