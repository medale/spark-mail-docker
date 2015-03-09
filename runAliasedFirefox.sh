#!/bin/bash
# Runs a firefox instance with HOSTALIASES environment set to sandbox/ip adx of spark-mail-docker
# container. Allows access to resource manager ui via http://sandbox:8088.
# Requires a sudo docker command - must run previous sudo command to cache sudo creds.
exec scala "$0" "$@"
!#    

import scala.sys.process._
import java.io._

object Main {
  def main(args: Array[String]) {
     val psOut = "sudo docker ps"!!
     val lines = psOut.split("\n")
     val mailDockerLine = lines.filter(_.contains("medale/spark-mail-docker")) 
     val splits = mailDockerLine(0).split("\\s+")
     val containerId = splits(0)
     val ipAdx = s"""sudo docker inspect --format="{{.NetworkSettings.IPAddress}}" ${containerId}"""!!
     val trimmed = ipAdx.trim
     val out = new FileWriter("/tmp/host-alias")
     out.write(s"sandbox ${trimmed}\n")
     out.close()
     val firefoxProcesses = "ps -ef" #| "grep firefox"!!
     val firefoxProcessesLines = firefoxProcesses.split("\n")
     if (firefoxProcessesLines.size  == 1) {
        Process(Seq("firefox","-url","http://sandbox:8088"), None, "HOSTALIASES" -> "/tmp/host-alias").!
     } else {
	println("Firefox already running. Please shut down to allow start up with HOSTALIASES.")
     }
  }
}
Main.main(args)
