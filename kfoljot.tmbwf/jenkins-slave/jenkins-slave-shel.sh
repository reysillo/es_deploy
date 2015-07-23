#!/bin/sh
nohup java -jar /var/jenkins-slave/slave.jar -jnlpUrl http://192.168.243.241:8080/computer/DMS-AGENT2/slave-agent.jnlp -secret 492a86b563f5f1fe54ebe3325a9634f647dc536f721ef263225f2c90068f838c &
