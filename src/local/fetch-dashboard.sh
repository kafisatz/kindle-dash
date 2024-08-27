#!/usr/bin/env sh
# Fetch a new dashboard image, make sure to output it to "$1".
# For example:
#"$(dirname "$0")/../xh" -d -q -o "$1" get https://raw.githubusercontent.com/pascalw/kindle-dash/master/example/example.png
"$(dirname "$0")/../xh" -d -q -o "$1" get https://uptimekumastatus.diro.ch/uptimekumastatus.png

#write battery to influxdb
#battery level as integer (eg. 77)
battery_level=$(gasgauge-info -c | sed 's/%//g')
echo $battery_level

unix_timestamp_now=$(date +%s)
#e.g. 1724747405
#note: the token only has access to the kindle bucket and the influx DB is hosted on a LAN
curl --request POST "https://influx.diro.ch/api/v2/write?org=099e0ad128fe577c&bucket=kindle" --header "Authorization: Token Q0fWs4RcZg2-r85TmPUE1bkH1UP0CL-RjJ3NVIg2C-r-lqCJ9jqcXUlTnBFn9ZsYqtYdwGT0ST1G0tEuNFhIqg==" --header "Content-Type: application/json" --data-binary "battery_level value=${battery_level} ${unix_timestamp_now}000000000"