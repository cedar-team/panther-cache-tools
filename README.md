# panther-cache-tools
A collection of useful scripts and tools, specifically for interacting with a local version of a "Panther Cache" backend (DynamoDB)

## Why?
The purpose of the local cache is to provide complete control over a local version of the production cache used by Panther. This cache helps with testing and development by providing visibility and allowing experimentation without risk. This local cache implemetation relies on a small change to Panther default helper functions, AWS's local dynamoDB docker image, and a series of bash scripts. 

## How to Use
For a basic implementation:
1. Clone this repo 
`git clone https://github.com/cedar-team/panther-cache-tools.git`
2. Replace default Panther global helper file `panther_oss_helpers.py` (`kv_table` function) with the updated code (see `panther_helper_updates` for details)
3. Navigate to `panther-testing`
3. Run `. setup.sh`
4. Cache is ready! Run `pipenv run cache-start`
For a list of all cache commands, see `panther-testing/README.md`
