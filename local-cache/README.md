## Local Cacheing
- This uses the official aws dynnamodb docker image to run a local cache
- By default the cache is available at `localhost:8000`
- The `panther_oss_helper` function should automatically use the local cache when running locally
- Please use the `cache-start` and `cache-stop` functions in the Pipenv setup located in the `../panther-testing/` directory to script to start the container, it will configure things appropriately
- If you want to interacti with the cache in any way not covered by Pipenv (see
`../panther-testing/README.md`), you can use any official aws cli dynamodb commands.
- Panther (or PAT) will handle converting a string object to a dictionary for use in a detection, but you must still load the data as a string if pushing data to the test cache manually (dynamoDB only supports strings and integers)

** Note: When the cache is running, your ~/.aws/credentials file is temporaily backed up and a new file is managed by the cache. When the cache is stopped, the original file is restored

# Pre-populating the cache for testing in CI/CD or high-count detections
The cache can be prepopulated when needed by defining a test in the detection `yaml` file. The cache data MUST be the first TEST in the detection, and will always return `FALSE` for the rule engine. The cache is then loaded locally by running `pipenv run cache-populate-tests`. When done testing, the pre-defined values can be unloaded by running `pipenv run cache-clear-tests`. Example:

Tests:
  - 
    Name: CACHE LOAD
    LogType: GSuite.Reports
    ExpectedResult: false
    Log: 
       { "cache_load": 
        {
          "panther-kv-store": [
              {   
                  "PutRequest": {
                      "Item": { 
                          "key": { "S": "GSuite.Shares.Report.LOADEDTEST" },
                          "expiresAt": { "N": "34534534535.916358" },
                          "stringSet": { "SS": ["{\"actor\": \"TESTER@cedar.com\", \"doc_title\": \"UNKNOWN\", \"target_user\": \"someuser@cedar.com\", \"doc_type\": \"msexcel\"}"] },
                          "intCount": { "N": "5" }
                      }
                  }
              },
              {
                  "PutRequest": {
                      "Item": { 
                          "key": { "S": "GSuite.Shares.Report.LOADEDTESTTWO" },
                          "expiresAt": { "N": "1665412280.916358" },
                          "stringSet": { "SS": ["{\"actor\": \"TESTER@cedar.com\", \"doc_title\": \"UNKNOWN\", \"target_user\": \"someemail@kpmg.com\", \"doc_type\": \"msexcel\"}"] },
                          "intCount": { "N": "300" }
                      }
                  }
              }
          ]
        }
      }

