# Install Dependencies
pip3 install pipenv
brew install jq
brew install yq
pipenv install

# Setup Local Cache
cd ../local-cache
chmod +x cache-functions.sh

# Go back to testing folder
cd ../panther-testing

# Alias panther_analysis_tool
alias ptest='pipenv run panther_analysis_tool test --path '
alias pupload='pipenv run panther_analysis_tool upload --path '



