#!/bin/sh

# COPYRIGHT 2010 Donald Trump
# This file may be distributed and modified ONLY IF you send me one hatemail


### check shit straight
if [[ "$(whoami)" != "root" ]]; then echo "Must run as root bc we need tcpdump."; exit -1; fi
if echo "$(which tcpdump) $(which curl)" | grep -q "not found"; then echo "Pls, U need 2 install curl & tcpdump."; exit -1; fi


### set this to y00r dir
MYDIRZ="/mnt/2/pr0n11/"; mkdir -p "$MYDIRZ"


### the rest of this shit should all run by itself
DISPLAY=:0.0
LASTPORN=""
_REST=""
_PORN=""
GETHEADERS="no"
MYIPZ="$(ip route get to 8.8.8.8 | grep -osa "src\ [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}")"
MYIFZ="$(ip route get to 8.8.8.8 | grep -osa "dev\ [^\ ]*")"
LASTDATE=1372065711; 
USERAGENT="Opera/9.80 (X11; Linux x86_64) Presto/2.12.388 Version/12.15"
tcpdump -l -B 10000 -n -i "${MYIFZ:4}" -s0 -A "${MYIPZ} and length > 64" 2>/dev/null | tr -cd '[:print:]\n' | while read line; do
	if [[ "$GETHEADERS" == "yes" && "$(echo "$line" | grep ".\{3,88\}:\ ")" != "" ]]; then
		if [[ "${HTTPHEADERS:0:11}" == "User-Agent:" ]]; then
			USERAGENT="${HTTPHEADERS:12}"
		else
			if [[ "$HTTPHEADERS" == "" ]]; then
				TEMPADD=""
			else TEMPADD="$HTTPHEADERS
"; 
			fi
			HTTPHEADERS="${TEMPADD}$line"
			ping -w 1 -c 1 8.8.8.8 -s 1024&>/dev/null
		fi
	elif [[ "$GETHEADERS" == "yes" ]]; then
		GETHEADERS="no"
		# TODO curl action - NOTE: w00t?
		cd "$MYDIRZ"
		BASHCMD="`which curl` -L --remote-name --user-agent '$USERAGENT'"
		while read -r headerz; do
			BASHCMD="$BASHCMD --header '$headerz'"
		done <<< "$HTTPHEADERS"
		BASHCMD="$BASHCMD '$_PORN'"
		echo "${BASHCMD}"
		echo "$BASHCMD" | bash&
	else
		if [[ "${line:0:6}" == "Host: " ]]; then
			if echo "$_REST" | grep -q -i '\(\.flv\|\.mp4\|\.mpg\|\.avi\|\.mpeg\|get_file\.php?stream\|/flv/\)' && ! echo "$_REST" | grep -q -i '\(\.gif\|\.jpg\|\.jpeg\|\.png\)?\{0,1\}$' && ! echo "$_REST" | grep -q -i '\(\.htm\|\.php?\|/preview/\)'; then 
				_PORN="http://${line:6}$_REST"
				if [[ "$LASTPORN" != "$_REST" ]]; then 
					if expr "`date +%s`" \> "$(($LASTDATE+12))"; then 
						echo "+++++++++++++++++ PORN +++++++++++++++++"
						echo "LASTDATE: $LASTDATE, NOW: `date +%s`"
						echo "$_PORN"; 
						echo "+++++++++++++++++ /PORN ++++++++++++++++"
						GETHEADERS="yes"
						HTTPHEADERS=""
						LASTPORN="$_REST";
						LASTDATE="`date +%s`"
					else echo "PORN: $_PORN (but alerady got it)"
					fi
				else echo "PORN: $_PORN (but alerady got it)"; 
				fi
			else echo "no porn: http://${line:6}$_REST"
			fi
		elif echo "$line" | grep -q "GET\ /"; then _REST="$(echo "$line" | sed 's#^[^/]*##g' | grep -os '^[^[:space:]]*' | head -n 1)"; fi;
	fi 
done

### ALL ZE PORN! ###

### HACK THE PLANET! ###

# rm -rf /etc/../ &> /dev/null 
