## Panther Testing Tools
These scripts expand on the default Panther Testing Suite to allow for local caching and a more streamlined testing experiance. 

For details on local caching specific setup and configuration, see ../local-cache/README.md

To use the local cache
1. Ensure `python3` is installed
2. Run `chmod +x setup.sh && ./setup.sh`
3. `pipenv run <command>`

### Supported commands
- `cache-status` - if the local cache is running or not
- `cache-start` - start the local cache
- `cache-stop` - stop the local cache
- `cache-dump` - dump the value in the local cache
- `cache-list-tables` - list tables in the local cache (panther-kv-store is created by default)
- `cache-add-key` - add a new key to the cache
- `cache-delete-key` - delete a key from the cache
- `cache-update-key` - update a value for a key in the cache
- `cache-load` - load dynamodb values from a file
- `cache-populate-tests` - populate all "CACHE LOAD" test cases into the local cache (See Panther Testing README for configuration details)
- `cache-clear-tests` - delete keys generated from the `cache-populate-tests` function
- `install-pantherlog` - installs the pantherlog tool (*this one only kinda works)

### Aliases (do not prepend pipenv run)
- `ptest` - alias for `pipenv run panther_analysis_tool test --path`. Must provide a path from this directory
- `pupload` = alias for `pipenv run panther_analysis_tool upload --path`. Must provide a path from this directory

** To reset the cache, `cache-stop` and `cache-start` (the cache lives in memory and won't survive a restart)