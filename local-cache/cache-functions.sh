
# cache-dump
if [ $1 = "cache-dump" ]; then
    aws dynamodb scan --table-name $TABLE_NAME --region $AWS_REGION --endpoint-url $LOCAL_DYNAMO_URL  | jq -c "[.Items[] | { key: .key.S, expiresAt: .expiresAt.N, intCount: .intCount.N, stringSet: .stringSet.SS, dictionary: .dictionary.S  }]" | jq -r

# cache-list-tables
elif [ $1 = "cache-list-tables" ]; then
    aws dynamodb list-tables --region $AWS_REGION --endpoint-url $LOCAL_DYNAMO_URL | jq -r

# cache-start
elif [ $1 = "cache-start" ]; then
    mv ~/.aws/credentials ~/.aws/credentials.bkup
    touch ~/.aws/credentials && echo -e "[default]\naws_access_key_id = fakeKey\naws_secret_access_key = fakeSecret\naws_region = us-east-1" >> ~/.aws/credentials
    docker-compose up -d dynamodb
    LOCAL_DYNAMO_URL="http://127.0.0.1:8000"
    aws dynamodb create-table --region us-east-1 --endpoint-url $LOCAL_DYNAMO_URL --cli-input-json file://initial-load.json >> /dev/null
 
# cache-stop
elif [ $1 = "cache-stop" ]; then
    unset LOCAL_DYNAMO_URL
    docker-compose down
    rm ~/.aws/credentials && mv ~/.aws/credentials.bkup ~/.aws/credentials

# cache-populate-tests
elif [ $1 = "cache-populate-tests" ]; then
    cd ../../panther
    touch tmp.txt
    for file in cedar_rules/*/*.yml; do
        # Splice Out the cache_load test and replace << DATETIME_NOW >> w/ current date.
        yq '.Tests[0].Log.cache_load' $file | jq . | sed "s/<< DATETIME_NOW >>/$(date '+%Y-%m-%d %H:%M:%S.000')/g" > tmp.txt
        if ! [[ $(cat tmp.txt) = null ]]; then
            aws dynamodb batch-write-item --request-items file://tmp.txt --endpoint-url $LOCAL_DYNAMO_URL >> /dev/null
            echo "Loaded Cache from $file" 
        fi
    done
    rm tmp.txt

# cache-clear-tests
elif [ $1 = "cache-clear-tests" ]; then
    cd ../../panther
    for file in cedar_rules/*/*.yml; do
        KEY=$(yq '.Tests[0].Log.cache_load.[].[].PutRequest.Item.key.S' $file)
        if ! [[ $KEY = "" ]]; then
            pattern="[[:space:]]+"
            if [[ $KEY =~ $pattern ]]; then
                for i in $(echo $KEY | tr " " "\n")
                    do
                        aws dynamodb delete-item --table-name $TABLE_NAME --key '{"key": {"S": "'$i'"}}' --endpoint-url $LOCAL_DYNAMO_URL >> /dev/null
                        echo "Deleted Key '$i' from cache"
                    done
            else 
                aws dynamodb delete-item --table-name $TABLE_NAME --key '{"key": {"S": "'$KEY'"}}' --endpoint-url $LOCAL_DYNAMO_URL >> /dev/null
                echo "Deleted Key '$KEY' from cache"
            fi
        fi
    done
    

# cache-load (load keys/values from file)
elif [ $1 = "cache-load" ]; then
    echo "Enter Path from User root (Example: Downloads/file.json)"
    read KEY
    cd ~/
    aws dynamodb batch-write-item --request-items file:$KEY --endpoint-url $LOCAL_DYNAMO_URL 

# cache-update-key
elif [ $1 = "cache-update-key" ]; then
    echo "Enter Key"
    read KEY
    echo "Enter field to update (intCount, stringSet, expiresAt, dictionary)"
    read FIELD
    echo "Enter Value"
    read VAL 
    if [ $FIELD == 'intCount' ]; then
       VAL='"'$VAL'"'
       TYPE='N'
    elif [ $FIELD == 'stringSet' ]; then
       TYPE='SS'
    else
       TYPE='S'
       VAL='"'$VAL'"'
    fi
    aws dynamodb update-item --table-name $TABLE_NAME --key '{"key": {"S": "'$KEY'"}}' --attribute-updates '{"'$FIELD'": {"Value": {"'$TYPE'": '$VAL'},"Action": "PUT"}}' --endpoint-url $LOCAL_DYNAMO_URL 

# cache-delete-key
elif [ $1 = "cache-delete-key" ]; then
    echo "Enter Key"
    read KEY
    aws dynamodb delete-item --table-name $TABLE_NAME --key '{"key": {"S": "'$KEY'"}}' --endpoint-url $LOCAL_DYNAMO_URL 

# cache-add-key
elif [ $1 = "cache-add-key" ]; then
    echo "Enter Key"
    read KEY
    JSON='{"key": {"S": "'$KEY'"}'
    echo "Enter intCount (leave blank for no value)"
    read intCount
    echo "Enter stringSet (leave blank for no value)"
    read stringSet
    echo "Enter expiresAt (leave blank for no value)"
    read expiresAt
    echo "Enter dictionary (leave blank for no value)"
    read expiresAt

    if ! [ -z "$intCount" ]; then
        JSON=''$JSON',"intCount": {"N": "'$intCount'"}'
    fi
    if ! [ -z "$stringSet" ]; then
        JSON=''$JSON',"stringSet": {"SS": '$stringSet'}'
    fi
    if ! [ -z "$expiresAt" ]; then
        JSON=''$JSON',"expiresAt": {"S": "'$expiresAt'"}'
    fi
    if ! [ -z "$dictionary" ]; then
        JSON=''$JSON',"dictionary": {"S": "'$dictionary'"}'
    fi

    aws dynamodb put-item --table-name $TABLE_NAME --item "$JSON}" --endpoint-url $LOCAL_DYNAMO_URL 

# cache-status
elif [ $1 = "cache-status" ]; then  
    docker-compose ps | grep dynamodb

# If no argument
elif [ -z "$1" ]; then
    echo "Please include an argument"

# Invalid Argument
else
    echo "Invalid Argument"
fi
