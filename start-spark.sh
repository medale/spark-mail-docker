/usr/local/spark/bin/spark-shell --master yarn-client --driver-memory 1G --executor-memory 1G --num-executors 1 --executor-cores 1 \
    --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
    --conf spark.kryo.registrator=com.uebercomputing.mailrecord.MailRecordRegistrator \
    --conf spark.kryoserializer.buffer.mb=128 \
    --conf spark.kryoserializer.buffer.max.mb=512 \
    --jars /root/mailrecord-utils-0.9.0-SNAPSHOT-shaded.jar \
    --driver-java-options "-Dlog4j.configuration=log4j.properties"
