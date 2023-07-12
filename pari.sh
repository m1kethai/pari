#!/bin/bash

package_name="$1"

# Retrieve package information using paru
pkg_info=$(paru -Si "$package_name")

# Extract the repository name from the package information
repository=$(echo "$pkg_info" | awk '/^Repository/ { print $3 }')

# Determine the URL based on the repository
case $repository in
    core)
        repo_url="https://www.archlinux.org/packages/core/x86_64/$package_name/"
        ;;
    extra)
        repo_url="https://www.archlinux.org/packages/extra/x86_64/$package_name/"
        ;;
    community)
        repo_url="https://www.archlinux.org/packages/community/x86_64/$package_name/"
        ;;
    aur)
        repo_url="https://aur.archlinux.org/packages/$package_name/"
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
        repo_url="https://www.archlinux.org/packages/?q=$package_name"
        ;;
esac

# Responsive divider
function divi {
    divi_str=""
    divi_segment="#"
    divi_length=$(( $(tput cols) < ${#repo_url} + 15 ? $(tput cols) : ${#repo_url} + 15 ))

    for ((i = 1; i <= divi_length; i++)); do
        divi_str+=$divi_segment
    done

    echo -e "\n$divi_str\n"
}

# Append the URL to the bottom of the pkg info output
echo "$pkg_info"
divi
echo -e "🔗 $repo_url"
