#!/usr/bin/bash

# chmod +x http.sh funcs.sh
# we can modify the listening port number 8099 as line below
# run: ncat -l --keep-open -v -p 8099 -c '~/weatherapp/http.sh'
# run as background: ncat -l --keep-open -v -p 8099 -c '~/weatherapp/http.sh'>/dev/null 2>&1 &
# client can visit： http://cs.sierracollege.edu:8099/${WEATHER_CGI}, WEATHER_CGI configure as below. 
# client can visit:  http://cs.sierracollege.edu:8099/any.png  any png pic file
# excetion above, any other visit is illegal
#

source funcs.sh

REMOTE_IP=$NCAT_REMOTE_ADDR
GET_LOCATION_URL="http://ip-api.com/json/$REMOTE_IP"

WEATHER_CGI=weather            #http://cs.sierracollege.edu:8080/weather
ROOT_PATH=~/weatherapp/
LOG_FILE=${ROOT_PATH}/log.txt
WEATHER_FILES_PATH=${ROOT_PATH}/weather-files/
WEATHER_DATA_PATH=${ROOT_PATH}/data/
WEATHER_DATABASE_NAME="weather.db"

[ ! -d $WEATHER_FILES_PATH ] && `mkdir $WEATHER_FILES_PATH`
[ ! -d $WEATHER_DATA_PATH ] && `mkdir $WEATHER_DATA_PATH`
check_create_talbes ${WEATHER_DATA_PATH}${WEATHER_DATABASE_NAME}

VID=0
if [ $VID == "0" ]; then VID=`date +%s%N | md5sum | head -c 8`;fi

HTTP_VERSION="HTTP/1.0"

func_response_code(){
	local response_code="$1"
	case "$response_code" in
		200) err_message="OK";;
		*)   err_message="Internal Server Error"
			func_log "Unknown response: $response_code"
			response_code=500
			;;
	esac
	func_log "response: $HTTP_VERSION $response_code $err_message"
	echo "$HTTP_VERSION $response_code $err_message"
}

func_response_file_with_header(){
	local filename=$1
	#		content-type: image/png
	#		content-length: 8400
	filesize=$(stat -c%s "$filename")
	echo Content-Length: $filesize; 
    echo Content-Type: $mime; 
	echo;
	cat $filename
}

func_error_exit(){
	local response_code="$1"
    case "$response_code" in
		200) err_message="OK"
			;;
		  *) err_message="Internal Server Error"
			;;
	esac

    echo "$HTTP_VERSION $response_code $err_message"
	func_log "response: $HTTP_VERSION $response_code $err_message"

	if [ "$2" ]
    then 
        problem="$2"
    else 
        problem="$err_message"
    fi

cat <<EOF
Content-Type: text/html

<!DOCTYPE html>
<html>
<head><meta http-equiv="content-type" content="text/html; charset=utf-8" /><title> $problem </title></head>
<body><h1> $response_code $problem </h1> $problem </body>
</html>
EOF
	func_log "exit! $problem\n"
	exit 1
}


func_log(){
	local message="$1"
    if [ ! -f "$LOG_FILE" ]
    then
        touch "$LOG_FILE"
    fi
    timestr=`date "+%F %T"`

    printf "%s[%s][%s]:%s %s %s\n" "$VID"  "$REMOTE_IP" "$timestr" "$message" >> "$LOG_FILE"
}

func_weather_run(){
	locationfile="${WEATHER_FILES_PATH}/${VID}-location.json"
	func_get_location $GET_LOCATION_URL "$locationfile"

	func_log "CITY_LAT=$CITY_LAT;CITY_LON=$CITY_LON"
   
	#save visiter info into DB
	fun_save_visit_info "$VID" "$locationfile" "${WEATHER_DATA_PATH}/${WEATHER_DATABASE_NAME}" "visit_infomation"

	#call weather API, save save json info  to file
	jsonfile="${WEATHER_FILES_PATH}/${VID}-weather.json"
	#curl -o weather.out "https://api.openweathermap.org/data/2.5/onecall?lat=38.8113&lon=-121.2643&exclude=minutely,hourly&appid=23395ca14ce6f3d0b8deae56539751a7"
    API_URL="https://api.openweathermap.org/data/2.5/onecall?lat=${CITY_LAT}&lon=${CITY_LON}&exclude=minutely,hourly&appid=23395ca14ce6f3d0b8deae56539751a7&units=imperial"
	curl -o "$jsonfile" "$API_URL" 2>/dev/null
    
	#call python script to parse json file, and write info to html file
	
	htmlfile="${WEATHER_FILES_PATH}/${VID}-weather.html"
    fun_parse_json2html "$VID" "$locationfile" "$jsonfile" "$htmlfile"

	#show to client
	mime=text/html
	if [ ! -f $htmlfile ]; then
		htmlfile=${ROOT_PATH}/internal_error.html 
	fi
	#生成的html页面文件
	func_response_code 200  #OK
    func_response_file_with_header "$htmlfile"
}

read method url version

CR=$'\r'
#method="${method%$CR}";
#url="${url%$CR}";
version=${version%$CR};
func_log "$method $url $version"



case "$version" in
	""|http/0.9|HTTP/0.9) 
		;;
	http/1.0|HTTP/1.0|http/1.1|HTTP/1.1)
        read foo; foo=${foo%$CR}
		func_log "$foo"
        while [ "$foo" != "$CR" -a "$foo" != "" ]
        do 
            read foo # foo=${foo%$CR};func_log "$foo"
        done
		#func_log "foo=[$foo] over"
        ;;
	*)
		func_error_exit 501 "Unknown version"
		;;
esac


case "$method" in
	GET|get) 
		;;
	*)
		func_error_exit 501 "Unimplemented method"
		;;
esac

type=""
filename=""
case "$url" in
	*.png|*.PNG)
		type="FILE"; filename="$ROOT_PATH/$url"
		;;
	*.log|*.txt)
		type="FILE"; filename="$ROOT_PATH/$url"
		;;
    *${WEATHER_CGI})
        type="SCRIPT" filename="$ROOT_PATH/${url}.sh"  
		;;
	*) 
		func_error_exit 501 "Unknown request"
		;;
esac

case $type in 
    SCRIPT)
		func_log "call $type"
		#//run $filename:${WEATHER_CGI}.sh
		func_weather_run
        ;;
	FILE)
		if [ -f $filename ]
        then
            func_response_code 200  #OK
            case $filename in
			    *.png)     		mime=image/png;;
                *.html|*.htm)	mime=text/html;;
                *.jpg|*.jpeg)	mime=image/jpeg;;
                *.gif) 			mime=image/gif;;
                *.txt|*.text)	mime=text/plain;;
				*.log)			mime=text/plain;;
                *)				mime=application/binary;;
            esac
			func_response_file_with_header "$filename"
        else
            func_error_exit 501 "Internal Error"
        fi
		;;
	*)
		func_error_exit 501 "Internal Error"
		;;
esac


func_log "$CR"

