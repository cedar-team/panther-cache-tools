## Local Cacheing & GitHub Actions
### GitHub Actions
- These GitHub actions are quite straight forward and accomplish the following:
1. Interact with Panther (test or upload)
2. Integrate the local cache (mimicks the local setup)
3. Posts to Slack on errors
### Panther Testing:
- This file will run on new PR's and test Panther Schemas, Lookups, Rules, and Queries. Variables that need to be set are defined as `<VARIABLE>`

### Panther Upload:
- This file will run on merged PR's and will upload Panther Schemas, Lookups, Rules, and Queries. Variables that need to be set are defined as `<VARIABLE>`

