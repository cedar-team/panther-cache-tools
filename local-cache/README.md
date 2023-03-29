## Local Cacheing
- The local cache uses the official aws dynnamodb docker image
- By default the cache is available at `localhost:8000`
- The `panther_oss_helper` function should automatically use the local cache when running locally
- Please use the `cache-start` and `cache-stop` functions in the Pipenv setup located in the `../panther-testing/` directory to script to start the container, it will configure things appropriately
- If you want to interact with the cache in any way not covered by Pipenv (see
`../panther-testing/README.md`), you can use any official aws cli dynamodb commands.
- Panther (or PAT) will handle converting a string object to a dictionary for use in a detection, but you must still load the data as a string if pushing data to the test cache manually (default dynamoDB only supports strings)

** Note: When the cache is running, your ~/.aws/credentials file is temporaily backed up and a new file is managed by the cache. When the cache is stopped, the original file is restored

# Pre-populating the cache for testing in CI/CD or high-count detections
The cache can be prepopulated when needed by defining a test in the detection `yaml` file. The cache data *MUST* be the first test in the yaml file, and should always return `FALSE` for the rule engine. The cache is then loaded locally by running `pipenv run cache-populate-tests`. When done testing, the pre-defined values can be unloaded by running `pipenv run cache-clear-tests`. Example:

Tests:
  - 
    Name: CACHE LOAD
    LogType: mylog.audit
    ExpectedResult: false
    Log: 
       { "cache_load": 
        {
          "panther-kv-store": [
              {   
                  "PutRequest": {
                      "Item": { 
                          "key": { "S": "my.dynamodb.key" },
                          "expiresAt": { "N": "34534534535.916358" },
                          "stringSet": { "SS": ["a", "b'] },
                          "dictionary": { "S": "{\"example\":\"dictionary\"}"}
                          "intCount": { "N": "5" }
                      }
                  }
              },
              {   
                  "PutRequest": {
                      "Item": { 
                          "key": { "S": "my.dynamodb.key.Two" },
                          "expiresAt": { "N": "34534534935.916358" },
                          "stringSet": { "SS": ["c", "d'] },
                          "dictionary": { "S": "{\"another\":\"dictionary\"}"}
                          "intCount": { "N": "999" }
                      }
                  }
              }
          ]
        }
      }

