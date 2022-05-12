 # weatherapp 
 chmod +x http.sh funcs.sh parsejson2html.py savevisitinfo.pl
 
 we can modify the listening port number 8099 as line below
 ## run as front: 
 
 ncat -l --keep-open -v -p 8099 -c '~/weatherapp/http.sh'
 
 ## run as background: 
 
 ncat -l --keep-open -v -p 8099 -c '~/weatherapp/http.sh'>/dev/null 2>&1 &
 
 ## desc scripts  
 http.sh: main script  
 
 funcs.sh: funcions script to call python and perl script  
 
 parsejson2html.py: python script to parse weather json data file and localtion json data file into html page  
 
 savevisitinfo.pl: perl script to save visit info to sqlite table in weather.db  
 
 ## visit weather app  
 client can visit：  
 http://cs.sierracollege.edu:8099/${WEATHER_CGI}, WEATHER_CGI configure in http.sh, eg: WEATHER_CGI=weather   
 http://cs.sierracollege.edu:8099/weather    
  
 client can visit:  http://cs.sierracollege.edu:8099/any.png  any png pic file  
 excetion above, any other visit is illegal  
 
 ## code respository  
 github respository:   
 
 https://github.com/curbst/weatherapp.git  
 
 ## sub-directory  
 database file: data/weather.db  
 
 data file(json): weather-files/*.json  
 
 
 ## about ncat:  
 https://nmap.org/ncat/guide/index.html  


