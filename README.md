# fesssearch

curl -x iproxy.sec.sbdc.is.dnp.co.jp:8080 'http://api.atnd.org/events/?keyword_or=google,cloud&format=json' | jq -r '.events[].event | ",\(.event_url),\(.title),\(.started_at)"'
$ sed -e 's/<[^>]*>//g'
