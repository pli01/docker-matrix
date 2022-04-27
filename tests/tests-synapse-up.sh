#!/bin/bash
timeout=120
test_result=1
ret=0
API_URL="http://localhost/_matrix/client/versions"
until [ "$timeout" -le 0 -o "$test_result" -eq "0" ] ; do
    set +e
    ( curl -s -i $API_URL |grep "^HTTP/.* 200" )
	test_result=$?
    echo "Wait $timeout seconds: is synapse up ($API_URL) ? $test_result";
	(( timeout-- ))
	sleep 1
done

set -e
if [ "$test_result" -gt "0" ] ; then
	ret=$test_result
	echo "ERROR: synapse not ready"
	exit $ret
fi

exit $ret

