hostname=`hostname`
status=`curl -I "http://$hostname.nm.flipkart.com:25280/sherlock/intent?q=samsung" | grep "HTTP" | awk '{print $2}'`

if [ "$status" == "200" ]
then
    echo "========curl command successfull========"
    echo "status $status"
    exit 0
else
    echo "===========curl command failed=========="
    echo "status = $status"
    exit 2
fi