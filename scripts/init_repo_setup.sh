#!/usr/bin/env bash
####################################################################################
# This script runs initial setup logic for the repo — it should be run once after
# cloning the repo for the first time to update the repo's name, owner, and NPM
# package name in documentation, links, etc.
#
# SCRIPT FLAGS:
#
# 	--dry-run: Run the script without making any changes. Useful for testing.
#
####################################################################################

printf '\n%s' "$(printf '—%.0s' {1..80})"
printf '\n%s' "Beginning initial repo setup ..."
printf '\n%s\n\n' "Please answer the following prompts. Where applicable, press Enter to accept the default."

#----------------------------------------------------------
# GET THE NAME OF THE REPO

default_repo_name="$(basename "$PWD")"
read -r -p "Repo name without scope (default: $default_repo_name) → " repo_name
repo_name=${repo_name:-$default_repo_name}

#----------------------------------------------------------
# GET THE REPO OWNER

# Use the GitHub REST API to try to obtain a default.
# The query includes the repo_name, and "Nerdware Template NPM Package Repo" in the README.
# Docs https://docs.github.com/en/rest/search/search?apiVersion=2022-11-28#constructing-a-search-query
gh_rest_api_repo_query="$repo_name%20\"Nerdware%20Template%20NPM%20Package%20Repo\"%20in:name%20in:readme"

gh_api_response="$(curl -sL \
	-H "Accept: application/vnd.github+json" \
	-H "X-GitHub-Api-Version: 2022-11-28" \
	"https://api.github.com/search/repositories?q=$gh_rest_api_repo_query")"

# The first repo-item in the response is used to obtain pertinent details.
# It is stored for later use (e.g., repo "description" for package.json).
gh_api_response_first_repo_json="$(echo "$gh_api_response" | jq -r '.items[0]')"

default_repo_owner="$(echo "$gh_api_response_first_repo_json" | jq -r '.owner.login' 2>/dev/null)"

default_repo_owner_prompt_str=''
[ -n "$default_repo_owner" ] && default_repo_owner_prompt_str="(default: $default_repo_owner)"

read -r -p "Repo owner $default_repo_owner_prompt_str → " repo_owner
repo_owner=${repo_owner:-$default_repo_owner}

#------------------------------------------------------------------------------
# GET REPO DESCRIPTION

# The repo's description is used as the default "description" in package.json.
repo_description="$(echo "$gh_api_response_first_repo_json" | jq -r '.description' 2>/dev/null)"
# package.json "description" is easy to change, skip confirming it w user.

#------------------------------------------------------------------------------
# GET THE NPM SCOPE, IF ANY

read -r -p "NPM package scope (press Enter if none) → " npm_scope
npm_scope=${npm_scope:-''}

#------------------------------------------------------------------------------
# GET THE NPM PACKAGE NAME

default_npm_pkg_name="$repo_name"
[ -n "$npm_scope" ] && default_npm_pkg_name="$npm_scope/$default_npm_pkg_name"

read -r -p "NPM package name (default: $default_npm_pkg_name) → " npm_pkg_name
npm_pkg_name=${npm_pkg_name:-$default_npm_pkg_name}

#------------------------------------------------------------------------------
# GET THE DESIRED NODE+NPM VERSIONS

# If NVM is available, set default to latest LTS version
if command -v nvm &>/dev/null; then
	# nvm ls-remote will list versions, tail gets the last one, grep gets the version number
	latest_node_version="$(nvm ls-remote --lts | tail --lines=1 | grep -oE 'v([0-9]+\.?){3}')"
	# Set the default to the major version number (e.g., '20' from 'v20.11.1')
	default_node_version="$(echo "$latest_node_version" | grep -oP '(?<=v)[0-9]+')"
else
	default_node_version='20' # Default to 20 if nvm is not available (current LTS as of Feb 2024)
fi

while true; do
	read -r -p "Node version number (default: $default_node_version) → " node_version
	node_version=${node_version:-$default_node_version}
	case $node_version in
	[1-9][0-9]) break ;;
	*) echo "Please provide a valid version number" ;;
	esac
done

# Default NPM version = Node version divided by 2. Note that bash division truncates the
# result, so 21/2=10, which just so happens to perfectly match node/npm-versioning logic.
default_npm_version=$(($node_version / 2))

while true; do
	read -r -p "NPM version number (default: $default_npm_version) → " npm_version
	npm_version=${npm_version:-$default_npm_version}
	case $npm_version in
	[1-9][0-9]) break ;;
	*) echo "Please provide a valid version number" ;;
	esac
done

#------------------------------------------------------------------------------
# CONFIRM VALUES WITH USER

# FOR CONFIRMATION DIALOG, SHOW LIST OF FILES THAT WILL BE UPDATED:
files_to_update=()
while IFS='' read -r filename; do files_to_update+=("${filename#./}"); done < <(
	# <REPO_NAME>        → $repo_name
	# <REPO_OWNER>       → $repo_owner
	# <NPM_PKG_NAME>     → $npm_pkg_name
	# <REPO_DESCRIPTION> → $repo_description
	# <NODE_VERSION>     → $node_version
	# <NPM_VERSION>      → $npm_version
	grep \
		--exclude=init_repo_setup.sh --recursive --files-with-matches . \
		-e '<REPO_NAME>' \
		-e '<REPO_OWNER>' \
		-e '<NPM_PKG_NAME>' \
		-e '<REPO_DESCRIPTION>' \
		-e '<NODE_VERSION>' \
		-e '<NPM_VERSION>'
)

printf '\n%s' "$(printf '—%.0s' {1..80})"
printf '\n%s\n' 'Please confirm:'

printf '\n\t%20s %s' 'Repo name:' "$repo_name"
printf '\n\t%20s %s' 'Repo owner:' "$repo_owner"
printf '\n\t%20s %s' 'NPM package name:' "$npm_pkg_name"
printf '\n\t%20s %s' 'Node version:' "$node_version"
printf '\n\t%20s %s' 'NPM version:' "$npm_version"
printf '\n'
printf '\n\t%s' 'Files that will be updated with these values:'
# shellcheck disable=SC2048,SC2086
printf '\n\t%21s %s' ${files_to_update[*]/#/'➜  '}
printf '\n\n'

while true; do
	read -r -p "Is this information correct? If not, script will exit. (y/n) → " is_correct
	case $is_correct in
	[Yy]*) break ;;
	[Nn]*) exit 0 ;;
	*) echo "Please answer Y or N." ;;
	esac
done

#------------------------------------------------------------------------------
# UPDATE VALUES:

printf '\n%s\n' "Updating files ..."

# MAKE THE UPDATES:
sed -i.bak \
	-e "s|<REPO_NAME>|$repo_name|g" \
	-e "s|<REPO_OWNER>|$repo_owner|g" \
	-e "s|<NPM_PKG_NAME>|$npm_pkg_name|g" \
	-e "s|<REPO_DESCRIPTION>|$repo_description|g" \
	-e "s|<NODE_VERSION>|$node_version|g" \
	-e "s|<NPM_VERSION>|$npm_version|g" \
	"${files_to_update[@]}"

#------------------------------------------------------------------------------
# CLEAN UP

printf '\n%s\n' "File updates complete. Cleaning up ..."

# Check if the --dry-run flag was provided
if [[ "$*" == *--dry-run* ]]; then
	# If --dry-run, restore the original files

	printf '\n%s\n' "--dry-run flag detected. Restoring files ..."

	for file in "${files_to_update[@]}"; do
		# Add prefix to amended files to indicate it was a dry run
		file_parent_dir="$(dirname "$(readlink -f "$file")")"
		file_basename="$(basename "$file")"
		mv "$file" "${file_parent_dir}/_REPO_SETUP_DRY_RUN.$file_basename"
		# Restore the original files
		mv "$file.bak" "$file"
	done

	printf '\n%s\n' "Dry run complete."
else
	# Else rm the backup files and print a completion message

	for file in "${files_to_update[@]}"; do rm "$file.bak"; done
	printf '\n%s\n' "Initial setup complete."

	# Ask user if this script should rm itself

	while true; do
		read -r -p "Remove this script? (y/n) → " rm_script
		case ${rm_script:-'EMPTY'} in
		[Yy]*)
			rm -- "$0"
			break
			;;
		[Nn]*) break ;;
		EMPTY) break ;;
		*) echo "Please answer Y or N." ;;
		esac
	done
fi

####################################################################################
