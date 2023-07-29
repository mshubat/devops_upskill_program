#!/bin/bash

#
# Friday, Jun 30, 2023
#
# This script was designed and tested in Ubuntu 22.04.2 LTS
#

getLineCountByOwner() {
	# Iterate over each file in the current directory
	for file in *; do
	  if [ -f "$file" ]; then
      local _owner=$(stat -c "%U" "$file")
        
      if [ "$_owner" == "$owner" ]; then
        wc -l $file | awk 'BEGIN{OFS=", "} {print "File: "$2, "Lines: "$1}'
      fi	    
    fi
	done
}

getLineCountByCreateMonth() {
	# Iterate over each file in the current directory
	for file in *; do
	  if [ -f "$file" ]; then
      local _creation_month=$(stat -c "%y" "$file" | awk '{print $1}' | cut -d'-' -f2)
      local _month_name=$(date -d "$creation_month" "+%B")
		
      if [ "$_month_name" == "$month" ]; then
        wc -l $file | awk 'BEGIN{OFS=", "} {print "File: "$2, "Lines: "$1}'
      fi	    
	  fi
	done
}

getFileOwner() {
	local _owner=$(stat -c "%U" test.txt)
	echo "$_owner"

	# Usage: 
	# echo "getting file owner"
	# RESULT=$(getFileOwner)
	# echo "$RESULT"
	# echo $RESULT == "matt"
}

# -- Gettings Flags -- #
while getopts o:m: flag
do
	case "${flag}" in
		o) owner=${OPTARG};;
		m) month=${OPTARG};;
	esac
done

# -- Debug Info -- #
# echo "owner: $owner"
# echo "month: $month"
# echo -e "----\n\n"

# -- Main -- #
if [[ -n "$owner" && -n "$month" ]] || [[ -z "$owner" && -z "$month" ]]; then
	echo "bad input"
	exit 1;
elif [ -n "$owner" ]; then
	echo "Getting line count of files for owner $owner"
	getLineCountByOwner
else 
	echo "Getting line count of files for month $month"
	getLineCountByCreateMonth
fi

