#!/bin/bash
# This script is used to query and export a CSV of remote branches that are older than the specified date.
# After running this script you should modify the CSV to remove specific branches which you don't want to delete using git-delete-remote-branches.sh.
# Branches to remove from the generated CSV include: origin, master, main, develop, etc
 
# Fetch all remote branches
git fetch --all
 
# Get the repository name
repo_name=$(basename -s .git `git config --get remote.origin.url`)
 
# Get all remote branches with their creation dates, sorted by creatordate in descending order
branches=$(git for-each-ref --sort=-creatordate --format '%(refname:short),%(creatordate:iso8601)' refs/remotes/)
 
# Debug: Print branches to verify output
echo "Branches and creation dates:"
echo "$branches"
 
# Filter branches created before 1st July 2024 and output to a CSV file
echo "Branch,Creation Date" > "${repo_name}_branches_created_before_2024-07-01.csv"
while IFS=, read -r branch date; do
  # Debug: Print each branch and date being processed
  echo "Processing branch: $branch with creation date: $date"
   
  # Extract just the date part (YYYY-MM-DD) for comparison
  date_only=$(echo $date | cut -d' ' -f1)
   
  if [[ "$date_only" < "2024-07-01" ]]; then
    echo "$branch,$date" >> "${repo_name}_branches_created_before_2024-07-01.csv"
  fi
done <<< "$branches"