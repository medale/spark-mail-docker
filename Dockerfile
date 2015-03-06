FROM sequenceiq/hadoop-docker:2.6.0
MAINTAINER medale

# automatically untars spark-1.2.1 at /usr/local
ADD spark-1.2.1.tar.gz /usr/local/
RUN cd /usr/local && ln -s spark-1.2.1-hadoop2.4 spark
ENV SPARK_HOME /usr/local/spark

# Upload sample files and jar file
ADD enron-small.avro /root/
ADD mailrecord-utils-0.9.0-SNAPSHOT-shaded.jar /root/
ADD log4j.properties /root/
ADD start-spark.sh /root/
RUN chmod +x /root/start-spark.sh

# Copy spark libs and enron email to HDFS
RUN $BOOTSTRAP && $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave && $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME/lib /spark && $HADOOP_PREFIX/bin/hdfs dfs -put /root/enron-small.avro /user/root/enron.avro

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin

# update boot script
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]

EXPOSE 4040 8080 18080