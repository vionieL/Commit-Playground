# This script is the second of two steps for removing old branches from a repository, the Deletion step.
# This script will remove all remote branch which names are in the provided CSV.
# Please remove the branches you don't want to be deleted from the csv before proceeding this step.
# If the branch doesn't exist then it will echo the error message and continue to the next branch.
#   Eq: 
#       error: unable to delete 'branch-name': remote ref does not exist
#       error: failed to push some refs to 'github.com:github-user/Repo-Name.git'
# Reference: https://arinco.com.au/blog/deleting-600-git-remote-branches/

# Start Process
echo "Start Delete Remote Branch Names"
 
# Set CSV Input file name
input_csv="Commit-Playground_branches_created_before_2026-04-03.csv"
 
# Read the branch names from the CSV file and delete the remote branches
while IFS=, read -r branch date; do
  # Skip the header line
  if [[ "$branch" == "Branch" ]]; then
    continue
  fi
 
  # Log for each branch deleted
  echo "Deleting branch: $branch"
 
  # Delete the remote branch
  git push origin --delete "${branch#origin/}"
done < "$input_csv"