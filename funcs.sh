#!/usr/bin/bash
function check_create_talbes(){
    dbname=$1
    sqlite3 $dbname << EOF
        CREATE TABLE IF NOT EXISTS "visit_infomation" (
            "vid"    TEXT,
            "remote_ip"    TEXT,
            "visittime"    TEXT,
            "lat"    TEXT,
            "lon"    TEXT, 
            "country"    TEXT,
            "countryCode"   TEXT,
            "region"    TEXT,
            "regionName"    TEXT,
            "city"  TEXT,
            "zip"   TEXT,
            "timezone"    TEXT,
            PRIMARY KEY("vid")
        );
EOF
}

function func_get_location(){
    local url=$1
    local jsonfile=$2
    curl -o "$jsonfile" "$url" 2>/dev/null
    eval `cat "$jsonfile"|awk '
        BEGIN{
            RS=",";
            FS=":"
        }
        {
            if(NR==8)
            {
                printf("CITY_LAT=%s;",$2);
            }
            if(NR==9)
            {
                printf("CITY_LON=%s;\n",$2);
            }
        }'`
}

#{"status":"success","country":"United States","countryCode":"US","region":"CA","regionName":"California","city":"Rocklin","zip":"95765","lat":38.8113,"lon":-121.2643,"timezone":"America/Los_Angeles","isp":"Consolidated Communications, Inc.","org":"Consolidated Communications, Inc.","as":"AS14051 Consolidated Communications, Inc.","query":"67.58.225.146"}


fun_save_visit_info()
{
    local vid=$1
    local jsonfile=$2
    local dbfile=$3
    local tablename=$4
    #parse location-<vid>.json with grep
    remote_ip=$(grep -P -o "(?<=\"query\":\").*?(?=\")" $jsonfile)
    lat=$(grep -P -o "(?<=\"lat\":).*?(?=,)" $jsonfile)
    lon=$(grep -P -o "(?<=\"lon\":).*?(?=,)" $jsonfile)
    country=$(grep -P -o "(?<=\"country\":\").*?(?=\")" $jsonfile)
    countryCode=$(grep -P -o "(?<=\"countryCode\":\").*?(?=\")" $jsonfile)
    region=$(grep -P -o "(?<=\"region\":\").*?(?=\")" $jsonfile)
    regionName=$(grep -P -o "(?<=\"regionName\":\").*?(?=\")" $jsonfile)
    city=$(grep -P -o "(?<=\"city\":\").*?(?=\")" $jsonfile)
    zip=$(grep -P -o "(?<=\"zip\":\").*?(?=\")" $jsonfile)
    timezone=$(grep -P -o "(?<=\"timezone\":\").*?(?=\")" $jsonfile)

    ./savevisitinfo.pl $vid $remote_ip $lat $lon "$country" $countryCode $region $regionName $city $zip "$timezone" "$dbfile" "$tablename"

}

# VID=0
# if [ $VID == "0" ]; then VID=`date +%s%N | md5sum | head -c 8`;fi

# fun_save_visit_info $VID location.json



fun_parse_json2html()
{
#call python script to parse json file, and save them into DB
    local vid=$1
    local locationfile=$2
    local jsonfile=$3
    local htmlfile=$4
    ./parsejson2html.py -v "$vid" -l "$locationfile" -i "$jsonfile" -o "$htmlfile"
}