#!/bin/bash

package_name="$1"

# Retrieve package information using paru
pkg_info=$(paru -Si "$package_name")

# Extract the repository name from the package information
repository=$(echo "$pkg_info" | awk '/^Repository/ { print $3 }')

# Determine the URL based on the repository
case $repository in
    core)
        repo_url="https://www.archlinux.org/packages/core/x86_64/$package_name"
        ;;
    extra)
        repo_url="https://www.archlinux.org/packages/extra/x86_64/$package_name"
        ;;
    community)
        repo_url="https://www.archlinux.org/packages/community/x86_64/$package_name"
        ;;
    aur)
        repo_url="https://aur.archlinux.org/packages/$package_name"
        ;;
    multilib)
        repo_url="https://www.archlinux.org/packages/multilib/x86_64/$package_name"
        ;;
    chaotic-aur)
        repo_url="https://lonewolf.pedrohlc.com/chaotic-aur/x86_64/$package_name"
        ;;
    blackarch)
        repo_url="https://www.blackarch.org/packages/$package_name"
        ;;
    *)
        repo_url="https://www.archlinux.org/packages/?q=$package_name"
        ;;
esac

# Prints a pink responsive divider
function print_divider {
    local term_width="$(tput cols)"

    local divider=""
    local divi_length=$(( $term_width ))
    local divi_segment="#"

    for ((i=1; i<=divi_length; i++)); do
        divider+=$divi_segment
    done

    echo -e "\e[95m$divider\e[0m"
}

# Prints the package information wrapped in dividers
function print_pkg_info {
    echo -e ""
    print_divider
    echo "$pkg_info"
    print_divider
    echo -e ""
}

# Styles the repo url with bold, underline, italic and cyan text
function print_styled_url {
    echo -e "🔗  \e[1m\e[4m\e[3m\e[94m$repo_url\e[0m"
}

echo -e ""
echo -e "ℹ️   \e[1m\e[4m\e[32m$(echo $package_name | tr '[:lower:]' '[:upper:]')\e[0m"
print_pkg_info
print_styled_url
