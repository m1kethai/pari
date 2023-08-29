#!/bin/bash

package_name="$1"

# Retrieve package information using paru
pkg_info_file=$(mktemp)
script -q /dev/null -c "paru -Si '$package_name' 2>/dev/null" > "$pkg_info_file"
pkg_info=$(cat "$pkg_info_file")
rm "$pkg_info_file"

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

function print_url {
    # 1) test if the assumed package repo URL is valid
    # 2a) if so, outputs the repo URL (bold, underline, italic and bright cyan text)
    # 2b) if not, outputs "Could not locate a valid repo URL for $package_name 😞" (bold and bright red text)

    curl -s --head "$repo_url" | head -n 1 | grep "HTTP/1.[01] [23].." > /dev/null
    is_valid_url=$?

    if [ $is_valid_url -eq 0 ]; then
        echo -e "\e[1m\e[31mCould not locate a valid repo URL for $package_name 😞\e[0m"
    else
        echo -e "🔗  \e[1m\e[4m\e[3m\e[96m$repo_url\e[0m"
    fi
}

function print_final_output {
    echo -e ""
    print_divider
    echo -e ""
    echo -n "$pkg_info"
    print_divider
    echo -e ""
    print_url
}

### Begin Output ###

echo -e ""
echo -e "ℹ️   \e[1m\e[4m\e[32m$(echo $package_name | tr '[:lower:]' '[:upper:]')\e[0m"

if [ -z "$pkg_info" ]; then
    echo -e "😞  \e[1m\e[31m$package_name not found\e[0m"
    exit 1

    else
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
        print_final_output
fi
