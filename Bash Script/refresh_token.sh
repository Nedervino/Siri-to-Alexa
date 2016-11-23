#!/bin/bash
REFRESH=`cat refresh.dat`
CLIENT_ID="<YOUR_CLIENT_ID>"
CLIENT_SECRET="<YOUR_CLIENT_SECRET>"
GRANT_TYPE="refresh_token"
REDIRECT_URI="https://localhost:9745/authresponse"
echo "Refreshing token"
curl -X POST --data "grant_type=${GRANT_TYPE}&refresh_token=${REFRESH}&client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&redirect_uri=${REDIRECT_URI}" https://api.amazon.com/auth/o2/token | tee refresh_token.log | python -c "import sys,json;t1=open('token.dat','w');t2=open('refresh.dat','w');x=sys.stdin.readline(); t1.write(json.loads(x)['access_token']);t2.write(json.loads(x)['refresh_token']);"
