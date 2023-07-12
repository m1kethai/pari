#!/bin/bash

package_name="$1"

# Retrieve package information using paru
pkg_info=$(paru -Si "$package_name")

# Extract the repository name from the package information
repository=$(echo "$pkg_info" | awk '/^Repository/ { print $3 }')

# Determine the URL based on the repository
case $repository in
    extra)
        repo_url="https://www.archlinux.org/packages/extra/x86_64/$package_name/"
        ;;
    community)
        repo_url="https://www.archlinux.org/packages/community/x86_64/$package_name/"
        ;;
    core)
        repo_url="https://www.archlinux.org/packages/core/x86_64/$package_name/"
        ;;
    multilib)
        repo_url="https://www.archlinux.org/packages/multilib/x86_64/$package_name/"
        ;;
    chaotic-aur)
        repo_url="https://lonewolf.pedrohlc.com/chaotic-aur/x86_64/$package_name/"
        ;;
    blackarch)
        repo_url="https://www.blackarch.org/packages/$package_name/"
        ;;
    *)
        repo_url="https://aur.archlinux.org/packages/$package_name/"
        ;;
esac

# Responsive divider

function divi {
  TERM_WIDTH="$(tput cols)"

  SHAFT=""
  SHAFT_LENGTH=$(( TERM_WIDTH ))

  SHAFT_SEGMENT="#"
  for ((i = 1; i <= SHAFT_LENGTH; i++)); do
    SHAFT+=$SHAFT_SEGMENT
  done

  echo -e "\n$SHAFT\n"
}

# Append the URL to the package information
echo "$pkg_info"
# sleep 0.1
divi
echo -e "Repo URL:\n$repo_url"
