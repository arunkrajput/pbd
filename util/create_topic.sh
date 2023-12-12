while read p
do
        echo $p

        #extract fields
        topic_name=`echo $p | cut -f1 -d',' `
        retention_days=`echo $p | cut -f2 -d','`
        partitions=`echo $p | cut -f3 -d','`
        replication_factor=`echo $p | cut -f4 -d','`

        #skip first line of column headers
        if [[ $topic_name  == 'TopicName' ]]
        then
                continue
        fi
        if [[ $retention_days -eq -1 ]]
        then
                # -1 so keep it -1 ie infinite retention
                retention_ms=-1
        else
                #convert to milliseconds
                let retention_ms="retention_days*86400000"
        fi


        echo $retention_days  $topic_name $retention_ms

        ./bin/kafka-topics.sh --create --topic $topic_name --bootstrap-server $2 --config retention.ms=$retention_ms --partitions $partitions --replication-factor $replication_factor
done < $1