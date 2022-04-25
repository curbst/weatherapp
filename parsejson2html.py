#!/usr/bin/python3
import json
import sys, getopt
import datetime

def timestr(timestamp, timezone, time_format="%m/%d/%Y %H:%M:%S"):
    # 时区偏移量，timezone单位秒
    offset = int(timezone) / 3600
    td = datetime.timedelta(hours=offset)
    tz = datetime.timezone(td)
    timeArray = datetime.datetime.fromtimestamp(timestamp, tz)
    styleTime = timeArray.strftime(str(time_format))

    return styleTime



#https://blog.csdn.net/sinat_41104353/article/details/79266048
def htmlfromdict(json_data,location_data):
    timezone = json_data["timezone_offset"]
    htmlstr = f"""
        <!DOCTYPE html>
        <html><head><title>weather report</title></head>
        <style>
            table, th, td {{
            border:1px solid black;
            }}
            </style>
        <body>
            <h2>{location_data["country"]}<br>{location_data["regionName"]}<br>{location_data["city"]}<br>{location_data["zip"]}</h2>
            <table>
            <tr>
                <td>{timestr(json_data["current"]["dt"],timezone)}</td>
                <td><table><tr><td><img src="http://openweathermap.org/img/w/{json_data["current"]["weather"][0]["icon"]}.png"></br>{json_data["current"]["weather"][0]["description"]}</td></tr><tr><td>Temp:{json_data["current"]["temp"]}°F</td></tr><tr><td>Wind speed:{json_data["current"]["wind_speed"]}miles/hour</td></tr></table></td>
                <td><table><tr><td>sunrise:{timestr(json_data["current"]["sunrise"],timezone,"%H:%M")}</td></tr><tr><td>runset:{timestr(json_data["current"]["sunset"],timezone,"%H:%M")}</td></tr></table></td>
            </tr>
                <!--以下Day 0 -->
            <tr>
                <td>{timestr(json_data["daily"][0]["dt"],0,"%m/%d/%Y")}</td>
                <td><table><tr><td><img src="http://openweathermap.org/img/w/{json_data["daily"][0]["weather"][0]["icon"]}.png"></br>{json_data["daily"][0]["weather"][0]["description"]}</td></tr><tr><td>Min temp:{json_data["daily"][0]["temp"]["min"]}°F</td></tr><tr><td>Max temp:{json_data["daily"][0]["temp"]["max"]}°F</td></tr><tr><td>Wind speed:{json_data["daily"][0]["wind_speed"]}miles/hour</td></tr></table></td>
                <td><table><tr><td>sunrise:{timestr(json_data["daily"][0]["sunrise"],timezone,"%H:%M")}</td></tr><tr><td>sunset:{timestr(json_data["daily"][0]["sunset"],timezone,"%H:%M")}</td></tr></table></td>
            </tr>
                <!--以下Day 1 -->
            <tr>
                <td>{timestr(json_data["daily"][1]["dt"],0,"%m/%d/%Y")}</td>
                <td><table><tr><td><img src="http://openweathermap.org/img/w/{json_data["daily"][1]["weather"][0]["icon"]}.png"></br>{json_data["daily"][1]["weather"][0]["description"]}</td></tr><tr><td>Min temp:{json_data["daily"][1]["temp"]["min"]}°F</td></tr><tr><td>Max temp:{json_data["daily"][1]["temp"]["max"]}°F</td></tr><tr><td>Wind speed:{json_data["daily"][1]["wind_speed"]}miles/hour</td></tr></table></td>
                <td><table><tr><td>sunrise:{timestr(json_data["daily"][1]["sunrise"],timezone,"%H:%M")}</td></tr><tr><td>sunset:{timestr(json_data["daily"][1]["sunset"],timezone,"%H:%M")}</td></tr></table></td>
            </tr>
                <!--以下Day 2 -->
            <tr>
                <td>{timestr(json_data["daily"][2]["dt"],0,"%m/%d/%Y")}</td>
                <td><table><tr><td><img src="http://openweathermap.org/img/w/{json_data["daily"][2]["weather"][0]["icon"]}.png"></br>{json_data["daily"][2]["weather"][0]["description"]}</td></tr><tr><td>Min temp:{json_data["daily"][2]["temp"]["min"]}°F</td></tr><tr><td>Max temp:{json_data["daily"][2]["temp"]["max"]}°F</td></tr><tr><td>Wind speed:{json_data["daily"][2]["wind_speed"]}miles/hour</td></tr></table></td>
                <td><table><tr><td>sunrise:{timestr(json_data["daily"][2]["sunrise"],timezone,"%H:%M")}</td></tr><tr><td>sunset:{timestr(json_data["daily"][2]["sunset"],timezone,"%H:%M")}</td></tr></table></td>
            </tr>
                <!--以下Day 3 -->
            <tr>
            <td>{timestr(json_data["daily"][3]["dt"],0,"%m/%d/%Y")}</td>
                <td><table><tr><td><img src="http://openweathermap.org/img/w/{json_data["daily"][3]["weather"][0]["icon"]}.png"></br>{json_data["daily"][3]["weather"][0]["description"]}</td></tr><tr><td>Min temp:{json_data["daily"][3]["temp"]["min"]}°F</td></tr><tr><td>Max temp:{json_data["daily"][3]["temp"]["max"]}°F</td></tr><tr><td>Wind speed:{json_data["daily"][3]["wind_speed"]}miles/hour</td></tr></table></td>
                <td><table><tr><td>sunrise:{timestr(json_data["daily"][3]["sunrise"],timezone,"%H:%M")}</td></tr><tr><td>sunset:{timestr(json_data["daily"][3]["sunset"],timezone,"%H:%M")}</td></tr></table></td>
            </tr>
                <!--以下Day 4 -->
            <tr>
                 <td>{timestr(json_data["daily"][4]["dt"],0,"%m/%d/%Y")}</td>
                <td><table><tr><td><img src="http://openweathermap.org/img/w/{json_data["daily"][4]["weather"][0]["icon"]}.png"></br>{json_data["daily"][4]["weather"][0]["description"]}</td></tr><tr><td>Min temp:{json_data["daily"][4]["temp"]["min"]}°F</td></tr><tr><td>Max temp:{json_data["daily"][4]["temp"]["max"]}°F</td></tr><tr><td>Wind speed:{json_data["daily"][4]["wind_speed"]}miles/hour</td></tr></table></td>
                <td><table><tr><td>sunrise:{timestr(json_data["daily"][4]["sunrise"],timezone,"%H:%M")}</td></tr><tr><td>sunset:{timestr(json_data["daily"][4]["sunset"],timezone,"%H:%M")}</td></tr></table></td>
            </tr>
                <!--以下Day 5 -->
            <tr>
                <td>{timestr(json_data["daily"][5]["dt"],0,"%m/%d/%Y")}</td>
                <td><table><tr><td><img src="http://openweathermap.org/img/w/{json_data["daily"][5]["weather"][0]["icon"]}.png"></br>{json_data["daily"][5]["weather"][0]["description"]}</td></tr><tr><td>Min temp:{json_data["daily"][5]["temp"]["min"]}°F</td></tr><tr><td>Max temp:{json_data["daily"][5]["temp"]["max"]}°F</td></tr><tr><td>Wind speed:{json_data["daily"][5]["wind_speed"]}miles/hour</td></tr></table></td>
                <td><table><tr><td>sunrise:{timestr(json_data["daily"][5]["sunrise"],timezone,"%H:%M")}</td></tr><tr><td>sunset:{timestr(json_data["daily"][5]["sunset"],timezone,"%H:%M")}</td></tr></table></td>
            </tr>
                <!--以下Day 6 -->
            <tr>
            </tr>
                <!--以下Day 7 -->
            <tr>
            </tr>                        
            </table>
        </body>
        </html>
    """
    return htmlstr

def main(argv):
    vid = ''
    locationfile = ''
    inputfile = ''
    outputfile = ''
    try:
      opts, args = getopt.getopt(argv,"v:l:i:o:", ['vid=', 'lfile=','ifile=', 'ofile='])
    except getopt.GetoptError:
      print("parsejson2html.py -v <vid> -l <locationfile> -i <inputfile> -o <outputfile>")
      sys.exit(2)
    for opt, arg in opts:
        if  opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg
        elif opt in ("-l", "--lfile"):
            locationfile = arg            
        elif opt in ("-v", "--vid"):
            vid = arg            


    with open(locationfile, 'r') as location_file:
        location_data = json.load(location_file)
        # print(location_data["zip"])

    with open(inputfile, 'r') as json_file:
        json_data = json.load(json_file)
        # print(json_data["lat"])
        # print(json_data["current"]["weather"][0]["description"])
        # write HTML 页面


    htmlstr=""
    htmlstr = htmlfromdict(json_data,location_data)
    f = open(outputfile, "w")
    f.write(htmlstr)
    f.close()

    # print(htmlstr)
    # print('Input file is ',inputfile)

if __name__ == "__main__":
   main(sys.argv[1:])

