 chmod +x http.sh funcs.sh
 
 
 we can modify the listening port number 8099 as line below
 run: ncat -l --keep-open -v -p 8099 -c '~/weatherapp/http.sh'
 
 run as background: 
 ncat -l --keep-open -v -p 8099 -c '~/weatherapp/http.sh'>/dev/null 2>&1 &
 
 
 client can visit：
 http://cs.sierracollege.edu:8099/${WEATHER_CGI}, WEATHER_CGI configure in http.sh, eg: WEATHER_CGI=weather 
 http://cs.sierracollege.edu:8099/weather  
  
 client can visit:  http://cs.sierracollege.edu:8099/any.png  any png pic file
 excetion above, any other visit is illegal

