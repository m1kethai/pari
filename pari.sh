#!/bin/bash

PKG="$1"
pkgman="$2"
div_char="$3"

full_pkg_info=""
repo_name=""
repo_url=""
#TODO: Add support for other package managers
pkgman_opts=("paru" "yay" "pacman")

#* If no package name is specified as $1, exit with an error message
if [ -z "$PKG" ]; then
    echo -e "🚨  \e[1m\e[31mNo package name specified\e[0m"
    exit 1
fi

#* Set defaults:
function set_defaults {
    #- If no package manager is specified as $2, use `paru` as the default. If that's not available, try `yay`, then `pacman`
    if [ -z "$pkgman" ]; then
        for pm in "${pkgman_opts[@]}"; do
            if command -v "$pm" &> /dev/null; then
                echo -e "\n📦  \e[1m\e[32mQuerying '$PKG' with $pm...\e[0m"
                pkgman="$pm"
                break
            fi
        done
        #- Exit with an error message if no package manager is available
        if [ -z "$pkgman" ]; then
            echo -e "🚨  \e[1m\e[31mNo package manager available\e[0m"
            exit 1
        fi
    fi

    #- if no divider character is specified as $3, use '#' as the default
    [ -z "$div_char" ] && div_char="#"
}

#* Print package information
function retrieve_pkg_info {
    tmp_info_file=$(mktemp)
    case $pkgman in
        paru)
            script -q /dev/null -c "paru -Si '$PKG' 2>/dev/null" > "$tmp_info_file"
            ;;
        yay)
            # script -q /dev/null -c "yay -Si '$PKG' 2>/dev/null" > "$tmp_info_file"
            echo -e "yay --- WIP"
            ;;
        pacman)
            # script -q /dev/null -c "pacman -Si '$PKG' 2>/dev/null" > "$tmp_info_file"
            echo -e "pacman --- WIP"
            ;;
    esac

    full_pkg_info=$(cat "$tmp_info_file") ; rm "$tmp_info_file"
}

function guess_and_set_repo_url {
    local matched_repo="$1"
    local test_cmd
    local assumed_url
    local is_valid_url

    ### Check if $matched_repo has been passed to the function:
    if [ -z "$matched_repo" ]; then
        echo -e "⛔ '$PKG' not found 🙂🔫\n"
        exit 1
    fi

    #- 1) guess the package repo URL based on the repo name
    #- 2) test if the assumed package repo URL is valid
    #- 3) if the assumed package repo URL is valid, set $repo_url to the assumed URL

    ### Determine the URL based on $matched_repo:

    if [ "$matched_repo" == "core" ]; then
        assumed_url="https://archlinux.org/packages/core/x86_64/$PKG"
        # echo "MATCH FOUND FOR CORE"
    elif [ "$matched_repo" = "extra" ]; then
        assumed_url="https://archlinux.org/packages/extra/x86_64/$PKG"
        # echo "MATCH FOUND FOR EXTRA"
    elif [ "$matched_repo" == "aur" ]; then
        assumed_url="https://aur.archlinux.org/packages/$PKG"
        # echo "MATCH FOUND FOR AUR"
    elif [ "$matched_repo" == "community" ]; then
        assumed_url="https://archlinux.org/packages/community/x86_64/$PKG"
        # echo "MATCH FOUND FOR COMMUNITY"
    elif [ "$matched_repo" == "multilib" ]; then
        assumed_url="https://archlinux.org/packages/multilib/x86_64/$PKG"
        # echo "MATCH FOUND FOR MULTILIB"
    elif [ "$matched_repo" == "chaotic-aur" ]; then
        assumed_url="https://lonewolf.pedrohlc.com/chaotic-aur/$PKG"
        repo_url="$assumed_url"
    fi
}

#* Extract the repository name from the package information
function set_repo_name {
    local repo
    local repos="$(echo "$full_pkg_info" | awk '/Repository/ { print $3 }')"
    ### Account for scenarios where multiple repositories are listed (ie. "core extra") - only use the first one as the default behavior:
    local repo_1 ; local repo_2 ; local repo_3

    if [ "$(echo "$repos" | wc -w)" -gt 1 ]; then
        repo_1="$(echo "$repos" | head -n 1)"
        # echo -e "\n💲 'repo_1'\n--> 💲$repo_1"
        #TODO: Add support for multiple repositories
        repo="$repo_1"
        if [ "$(echo "$repos" | wc -w)" -gt 2 ]; then
            repo_2="$(echo "$repos" | head -n 2 | tail -n 1)"
            # echo -e "\n💲 'repo_2'\n--> 💲$repo_2"
            if [ "$(echo "$repos" | wc -w)" -gt 3 ]; then
                repo_3="$(echo "$repos" | head -n 3 | tail -n 1)"
                # echo -e "\n💲 'repo_3'\n--> 💲$repo_3"
            fi
        fi
    else repo="$repos"
    fi

    trimmed_repo="$(echo "$repo" | tr -d '[:space:]')"
    # echo -e "\n💲 'trimmed_repo'\n--> 💲$trimmed_repo"
    repo_name="$trimmed_repo"
    # echo -e "\n💲 'set_repo_name ====== repo_name'\n--> 💲$repo_name"
    guess_and_set_repo_url "$repo_name"
}

#* Print a responsive divider
function divider {
    div_str=""
    term_width="$(tput cols)"
    for ((i=1; i<=term_width; i++)); do
        div_str+="$div_char"
    done
    echo -e "\e[95m$div_str\e[0m"
}

#* Trim the full package information to the specified number of repositories:
truncate_output() {
    local max_repos=2
    awk -v max_repos="$max_repos" '/Repository/{if (++count == max_repos) exit}1' <<< "$1"
}

#* Output all the good shit
function output_stuff {
    ### Print header - package name in bold, underlined and bright green text:
    echo -e "\n~~~~~~~~~~~~~~~~~"
    echo -e "ℹ️  \e[1m\e[4m\e[32m$(echo "$PKG" | tr '[:lower:]' '[:upper:]')\e[0m\n"
    ### Print full package information, wrapped in reponsive dividers:
    echo -e "$(divider)$(truncate_output "$full_pkg_info")$(divider)\n"
    ### Print the package repo URL:
    if [ -z "$repo_url" ]; then
        echo -e "🚫😞  \e[1m\e[31mCould not locate a valid repo URL for $PKG\e[0m\n"
        else echo -e "🔗  \e[1m\e[4m\e[3m\e[96m$repo_url\e[0m\n"
    fi
}

set_defaults
retrieve_pkg_info
set_repo_name
output_stuff