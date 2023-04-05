Use this file to update the default panther_oss_helper file. Only the 'kv_table' function has been edited. The change sets the cache to local if an environment variable exists. See the updated function below if needed!

```
def kv_table() -> boto3.resource:
    """Lazily build key-value table resource"""
    # pylint: disable=global-statement

    # This sets the ddb endpoint to local when the LOCAL_DYNAMO_URL is set.
    if os.environ.get("LOCAL_DYNAMO_URL") != None:
        endpoint = "http://localhost:8000"
    else:
        endpoint = "https://dynamodb" + FIPS_SUFFIX if FIPS_ENABLED else None
    global _KV_TABLE  
    if not _KV_TABLE:
        # pylint: disable=no-member
        _KV_TABLE = boto3.resource("dynamodb", endpoint_url=endpoint).Table(
            "panther-kv-store"
        )
    return _KV_TABLE
```