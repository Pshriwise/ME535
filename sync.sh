#!/bin/bash

## Config:
starturl="https://drive.google.com/folderview?id=<insert-id-here>&usp=sharing"
basefolder="/Users/werner/Programming/wget-gdrive-sync/dest"
## End config:

download () {
	url=$1
	folder=$2
	downloaded=$3
	#echo "Parsing: $url"
	wgetoutput="`wget -qO- $url 2>&1`"
	mkdir -p "$folder"
	commands="$(echo "$wgetoutput" | grep -Eo '\[,,\"(.*?)\",,,,,\"(.*?)\"')"
	#echo "$commands"

	#Download files
	IFS="
	"
	for line in $commands; do
	 id=$(echo "$line" | grep -Eio '\"[0-9a-z]+-[0-9a-z]+\"' | cut -c 2- | sed s'/.$//')
	 name=$(echo "$line" | sed -e 's/\[,,\"//' | sed s/\".*//'')
	 file="$folder/$name"
	 cmd=$(echo "wget -nc --no-cookies -O \"$file\" \"https://docs.google.com/uc?export=download&id="$id"\"")
	 eval "$cmd"
	 commandresult=$?
	 if [ "$commandresult" -eq 0 ]; then 
	 	downloaded=$(($downloaded + 1))
	 fi
	done

	#Go to next
	folderids="$(echo "$wgetoutput" | grep -Eo '\[,".*?\",\".*?folder' | cut -c 4- | cut -d\" -f 1)"
	for folderid in $folderids; do
	 #echo "$folderid"
	 newdest="$2/$(echo "$wgetoutput" | grep -Eo 'entry-'$folderid'.*?</div></div><div class=\"flip-entry-title\">(.*?)</div>' | grep -Eo 'entry-title">.*?</div>$' | cut -c 14- | sed 's/<\/div>//')"
	 #echo "$newdest"
	 output=$(download "https://drive.google.com/folderview?id=$folderid&usp=sharing" "$newdest" $downloaded)
	 downloaded=$output
	done

	echo "$downloaded"
}


result=$(download "$starturl" "$basefolder" 0)
echo "Downloaded: $result files"