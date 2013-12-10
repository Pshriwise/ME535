#!/bin/sh

starturl="https://drive.google.com/folderview?id=<insert-id-here>&usp=sharing"
basefolder="/full/path/to/destination"
removefiles=true 

## End config

download () {
	url=$1
	folder=$2
	downloaded=$3
	#echo "Parsing: $url"
	wgetoutput="`wget --no-check-certificate -qO- $url 2>&1`"
	#echo "$wgetoutput"
	mkdir -p "$folder"
	commands="$(echo "$wgetoutput" | grep -Eo '\[,,\"(.*?)\",,,,,\"(.*?)\"')"
	#echo "$commands"
	missingfiles="$(find "$folder" -type f -depth 1 -print)"
	
	#Download files
	IFS="
	"
	for line in $commands; do
		id=$(echo "$line" | grep -Eio '\"[0-9a-z]+-[0-9a-z]+\"' | cut -c 2- | sed s'/.$//')
		name=$(echo "$line" | sed -e 's/\[,,\"//' | sed s/\".*//'')
		file="$folder/$name"
		cmd=$(echo "wget --no-check-certificate -nc -q --no-cookies -O \"$file\" \"https://docs.google.com/uc?export=download&id="$id"\"")
		eval "$cmd"
		commandresult=$?
		if [ "$commandresult" -eq 0 ]; then 
			echo "sync.sh: Downloaded: $file" 1>&2;
			downloaded=$(($downloaded + 1))
		else 
			echo "sync.sh: Skipped (Already exists or error): $file" 1>&2;
		fi
		escapedfile=$(echo "$file" | sed -e 's/[]@$*.^|[]/\\&/g')
		missingfiles=$(echo "$missingfiles" | sed 's@'$escapedfile'@@g' | sed '/^$/d')
	done

	#Remove missing files
	echo "sync.sh: Checking files to remove from $folder" 1>&2;
	if [ $removefiles = true ]; then
		for line in $missingfiles; do
				echo "Removing: $line" 1>&2;
				rm -f "$line"
		done
	fi
	echo "sync.sh: Finished scan" 1>&2;


	#Go to next
	folderids="$(echo "$wgetoutput" | grep -Eo '\[,".*?\",\".*?folder' | cut -c 4- | cut -d\" -f 1)"
	for folderid in $folderids; do
		#echo "$folderid"
		newdest="$2/$(echo "$wgetoutput" | grep -Eo 'entry-'$folderid'.*?</div></div><div class=\"flip-entry-title\">(.*?)</div>' | grep -Eo 'entry-title">.*?</div>$' | cut -c 14- | sed 's/<\/div>//')"
		#echo "$newdest"
		output=$(download "https://drive.google.com/folderview?id=$folderid&usp=sharing" "$newdest" $downloaded)
		downloaded=$output
	done

	echo $downloaded
}

result=$(download "$starturl" "$basefolder" 0)
echo "Downloaded: $result files"
if [ $result -ne 0 ]; then
	echo "Disk has changed. Rescan."
fi