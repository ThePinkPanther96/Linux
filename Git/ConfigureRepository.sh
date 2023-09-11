#!/bin/bash

# Specify the Git user (replace with your Git user)
git_user="git"

# Specify the path where the repository should be created
repo_path="/home/$git_user/git-repos"

# Specify the name of the new repository
repo_name="new-repo"

# Function to check if a directory already exists
directory_exists() {
  if [ -d "$1" ]; then
    return 0  # Directory exists
  else
    return 1  # Directory does not exist
  fi
}

# Check if the repository directory already exists
if directory_exists "$repo_path/$repo_name.git"; then
  echo "Repository '$repo_name' already exists in '$repo_path'. Aborting."
  exit 1
fi

# Create the repository directory
mkdir -p "$repo_path/$repo_name.git"

# Initialize a bare Git repository
su - "$git_user" -c "git init --bare '$repo_path/$repo_name.git'"

echo "Repository '$repo_name' created successfully in '$repo_path'."
