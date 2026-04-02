# This script is the first of two steps for removing old branches from a repository, the Populate step.
# This script will get all remote branch names to a CSV which are older that the specified date.
# Branches will include origin, master, main, develop, etc.
# Please remove the branches you don't want to be deleted from the csv before proceeding to the last step, the Deletion step.
# Reference: https://arinco.com.au/blog/deleting-600-git-remote-branches/

# Start Process
echo "Start Get Remote Branch Names"

# Fetch all remote branches
git fetch --all
 
# Set Repository name
repo_name=$(basename -s .git `git config --get remote.origin.url`)

# Specify the cutoff date
dateString="2026-04-03.csv"

# Get all remote branches with their creation dates and latest commit dates, sorted by created date in descending order
branches=$(git for-each-ref --sort=-creatordate --format '%(refname:short),%(creatordate:short),%(committerdate:short)' refs/remotes/)
 
# Filter branches created before the specified date and create an output to a CSV file
echo "Branch,Creation Date,Latest Commit Date" > "${repo_name}_branches_created_before_${dateString}"
while IFS=, read -r branch createDate latestDate; do
  if [[ $createDate < $dateString ]]; then
    echo "$branch,$createDate,$latestDate" >> "${repo_name}_branches_created_before_${dateString}"
  fi
done <<< "$branches"