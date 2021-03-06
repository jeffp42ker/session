#!/bin/bash

if [[ "x${ISPN_HOME}" == "x" ]]; then
    echo "Set ISPN_HOME first"
    exit -1
fi

cd $ISPN_HOME

source "bin/functions.sh"

add_classpath "${ISPN_HOME}"/*.jar
add_classpath "${ISPN_HOME}/lib"
# add_classpath "${ISPN_HOME}/modules/memcached"
add_classpath "${ISPN_HOME}/modules/hotrod"
# add_classpath "${ISPN_HOME}/modules/websocket"

# need for filesystem
# add_classpath "${ISPN_HOME}/modules/cachestores/bdbje"
# add_classpath "${ISPN_HOME}/modules/cachestores/jdbm"

# need for cloud
# add_classpath "${ISPN_HOME}/modules/cachestores/cloud"

add_jvm_args $JVM_PARAMS
add_jvm_args '-Djava.net.preferIPv4Stack=true'

# RHQ monitoring options
add_jvm_args '-Dcom.sun.management.jmxremote.ssl=false'
add_jvm_args '-Dcom.sun.management.jmxremote.authenticate=false'
add_jvm_args -Dcom.sun.management.jmxremote.port=$(find_tcp_port)

# Workaround for JDK6 NPE: http://bugs.sun.com/view_bug.do?bug_id=6427854
add_jvm_args '-Dsun.nio.ch.bugLevel=""'

# Sample JPDA settings for remote socket debugging
#add_jvm_args "-Xrunjdwp:transport=dt_socket,address=8686,server=y,suspend=n"

# LOG4J configuration
# LOG4J_CONFIG=file:///${ISPN_HOME}/etc/log4j.xml

add_program_args "$@"

start org.infinispan.server.core.Main

