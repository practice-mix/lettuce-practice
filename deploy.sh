#!/usr/bin/env bash
function build_up() {
	mvn clean
	mvn package -Dmaven.test.skip=true
}
function upload_to_beta() {
    scp -i "us_ufoto.pem" ./target/lettuce-practice-0.0.1-SNAPSHOT.jar ubuntu@35.173.184.94:~/
    ssh -i "us_ufoto.pem" ubuntu@35.173.184.94 << endend
    appName=lettuce-practice-0.0.1-SNAPSHOT.jar
    pid=`ps -ef |grep $appName |grep -v "grep" | awk '{print $2}'`
    if [ "$pid" ]; then
        echo "app is running on pid $pid"
        kill -9 $pid
        if [ $? -eq 0 ]; then
            echo "topped successful"
        else
            echo "failed to stop"
        fi
    else
        echo "there is no $appName running"
    fi
    java -jar lettuce-practice-0.0.1-SNAPSHOT.jar
#    exit
endend
}


function beta_deploy() {
    echo "============START==========="

    build_up
    upload_to_beta

    echo "============E N D==========="
}

beta_deploy     