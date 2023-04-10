# panther-cache-tools
This repo applies specifically to the [Panther SIEM](https://panther.com/), and contains a collection of useful scripts and tools, specifically for interacting with a local version of a "[Panther Cache](https://docs.panther.com/writing-detections/caching)" backend (DynamoDB)


## Why?
Why should this matter to me? Well, Panther, as a SIEM, takes a fundamentally different approach to most other SIEM tools. They run detection logic on each log, and each detection is Python. This means that you have a lot of flexibilty in your logic. 

But what if I want to maintain state on my realtime detections? Panther solved this by implementing "[caching](https://docs.panther.com/writing-detections/caching)". Caching is an abstracted [AWS DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html) interface that allows you to store and manipulate key/value pairs and dictionaries directly from detection code. For example, in Python :

Counters:
 ```
 key = my_cool_string
 counter = increment_counter(key) 
 ```

Dictionaries:
 ```
 put_dictionary(key, data)
 get_data = get_dictionary(key)
 ```
Super simple, right? For more examples, see [Panther's Documentation](https://docs.panther.com/detections/caching).

This capability opens up a lot of options, from dynamic lookup tables to detection chaining. But since the "production" cache is hosted by Panther as part of their SaaS SIEM solution, it's not always easy to view live data or integrate caching into local detection development and testing workflows.

The purpose of the local cache is to provide complete control over an identical version of the production cache used by Panther. This cache helps with testing and development by providing visibility and allowing experimentation without risk. This local cache implementation relies on a small change to Panther default helper functions, AWS's local dynamoDB docker image, and a series of bash scripts. 

## Features
A few quick features the the local cache addresses
- Complete Local DynamoDB instance
- Live data manipulation in the local cache
- Seamless integration with Panther's [PAT](https://docs.panther.com/panther-developer-workflows/ci-cd/deployment-workflows/pat) CLI tool 

## Quick Start
For a basic implementation:
1. Clone this repo 
`git clone https://github.com/cedar-team/panther-cache-tools.git`
2. (Skip if you already have your own Panther repo) Clone Panther's repo 
`git clone git@github.com:panther-labs/panther-analysis.git`
3. Replace default Panther global helper file `global_helpers/panther_oss_helpers.py` (`kv_table` function) with the updated code (see [`panther_helper_updates`](https://github.com/cedar-team/panther-cache-tools/tree/main/panther-helper-updates#readme) for the snippet to replace)
4. Navigate to `panther-testing` in this repo
5. Run `. setup.sh`
`** setup.sh was written for MacOS and assuming [brew](https://brew.sh/) is installed. You will likely need to edit the dependency install commands in the setup script prior to running to match your operating system.`  
6. Cache is ready! Run `pipenv run cache-start`
For a list of all cache commands, see [`panther-testing/README.md`](https://github.com/cedar-team/panther-cache-tools/tree/main/panther-testing#readme)

## The details
Other README's in the repo have the details! See the links below: 
- [Local Cache Implementation Details](https://github.com/cedar-team/panther-cache-tools/tree/main/local-cache#readme)
- [Panther Helper Updates required for Local Cache](https://github.com/cedar-team/panther-cache-tools/tree/main/panther-helper-updates#readme)
- [Local Cache and Panther Test CLI](https://github.com/cedar-team/panther-cache-tools/tree/main/panther-testing#readme)
- [GitHub Action Local Cache Implementation Examples](https://github.com/cedar-team/panther-cache-tools/tree/main/github-actions#readme)
