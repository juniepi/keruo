#!/bin/bash

COLOR_DIR='\033[1;35m'
COLOR_FILE='\033[1;36m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'

ASCII_ART='██╗░░██╗███████╗██████╗░██╗░░░██╗░█████╗░
██║░██╔╝██╔════╝██╔══██╗██║░░░██║██╔══██╗
█████═╝░█████╗░░██████╔╝██║░░░██║██║░░██║
██╔═██╗░██╔══╝░░██╔══██╗██║░░░██║██║░░██║
██║░╚██╗███████╗██║░░██║╚██████╔╝╚█████╔╝
╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░╚═════╝░░╚════╝░'

TEMP_COPY="/tmp/bash_script_copy.tmp"
TEMP_CUT="/tmp/bash_script_cut.tmp"

declare -a dir_stack

display_ascii_art() {
    clear
    echo -e "${COLOR_YELLOW}$ASCII_ART${COLOR_RESET}"
    echo -e "${COLOR_RESET}|   <X> | <- <B> | -> <Enter> | 󰏫 <U> | 󰆏 <C> | 󰆒 <P> | 󰆐 <N> |   <M> | 󰅬 <Y> |"
    echo
}

list_files() {
    local dir="$1"
    local items=()
    local item_labels=()
    local count=0
    local selection=0

    echo -e "${COLOR_RESET}Listing contents of $dir"

    while IFS= read -r -d $'\0' dir_entry; do
        items+=("$dir_entry")
        item_labels+=("${COLOR_DIR}[DIR] ${dir_entry#"$dir/"}${COLOR_RESET}")
        count=$((count + 1))
    done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d -print0)

    while IFS= read -r -d $'\0' file_entry; do
        items+=("$file_entry")
        item_labels+=("${COLOR_FILE}[FILE] ${file_entry#"$dir/"}${COLOR_RESET}")
        count=$((count + 1))
    done < <(find "$dir" -mindepth 1 -maxdepth 1 -type f -print0)

    if [ "$count" -eq 0 ]; then
        echo "No files or directories found."
        echo "Would you like to create a new file? (o) for Yes, (p) for No"
        echo "Paste copied file into this empty folder? (i) for Yes, (p) for No"
        read -rsn1 input
        case "$input" in
            o)
                echo "Enter the name for the new file:"
                read filename
                touch "$dir/$filename"
                echo "Created file: $filename"
                ;;
            i)
                if [ -s "$TEMP_COPY" ]; then
                    local source_file=$(cat "$TEMP_COPY")
                    cp "$source_file" "$dir"
                    echo "Pasted $source_file into $dir"
                else
                    echo "No file copied to paste."
                fi
                ;;
            p)
                ;;
        esac
        read -n 1 -s
        return
    fi

    while true; do
        clear
        display_ascii_art
        echo -e "Listing contents of $dir"
        for i in "${!item_labels[@]}"; do
            if [ "$i" -eq "$selection" ]; then
                echo -e "\e[7m${item_labels[$i]}\e[0m"
            else
                echo -e "${item_labels[$i]}"
            fi
        done

        read -rsn1 input
        case "$input" in
            $'\x1b')
                read -rsn2 -t 0.1 input
                if [[ "$input" == "[A" ]]; then
                    selection=$((selection - 1))
                    if [ "$selection" -lt 0 ]; then
                        selection=0
                    fi
                elif [[ "$input" == "[B" ]]; then
                    selection=$((selection + 1))
                    if [ "$selection" -ge "$count" ]; then
                        selection=$((count - 1))
                    fi
                fi
                ;;
            '')
                if [ "$selection" -lt "$count" ]; then
                    local selected_item="${items[$selection]}"
                    if [ -d "$selected_item" ]; then
                        dir_stack+=("$dir")
                        list_files "$selected_item"
                    elif [ -f "$selected_item" ]; then
                        nvim "$selected_item"
                    fi
                else
                    break
                fi
                ;;
            b)
                if [ ${#dir_stack[@]} -gt 0 ]; then
                    dir="${dir_stack[-1]}"
                    unset 'dir_stack[-1]'
                    list_files "$dir"
                fi
                ;;
            x)
                exit 0
                ;;
            c)
                if [ "$selection" -lt "$count" ]; then
                    local selected_item="${items[$selection]}"
                    if [ -f "$selected_item" ]; then
                        echo "$selected_item" > "$TEMP_COPY"
                        echo "Copied $selected_item"
                    fi
                fi
                ;;
            v)
                if [ -s "$TEMP_COPY" ]; then
                    local source_file=$(cat "$TEMP_COPY")
                    cp "$source_file" "$dir"
                    echo "Pasted $source_file into $dir"
                fi
                ;;
            n)
                if [ "$selection" -lt "$count" ]; then
                    local selected_item="${items[$selection]}"
                    if [ -f "$selected_item" ]; then
                        echo "$selected_item" > "$TEMP_CUT"
                        rm "$selected_item"
                        echo "Cut $selected_item"
                    fi
                fi
                ;;
            m)
                if [ "$selection" -lt "$count" ]; then
                    local selected_item="${items[$selection]}"
                    if [ -f "$selected_item" ]; then
                        rm "$selected_item"
                        echo "Removed $selected_item"
                    else
                        echo "Selected item is not a file."
                    fi
                fi
                ;;
            u)
                if [ "$selection" -lt "$count" ]; then
                    local selected_item="${items[$selection]}"
                    local item_type
                    if [ -d "$selected_item" ]; then
                        item_type="directory"
                    elif [ -f "$selected_item" ]; then
                        item_type="file"
                    else
                        item_type="unknown"
                    fi
                    if [ "$item_type" != "unknown" ]; then
                        echo "Enter new name for the $item_type (without leading path):"
                        read new_name
                        new_path="$(dirname "$selected_item")/$new_name"
                        if [ -e "$new_path" ]; then
                            echo "Error: $item_type already exists with the name '$new_name'."
                        else
                            mv "$selected_item" "$new_path"
                            echo "Renamed $item_type to $new_name"
                        fi
                    else
                        echo "Selected item is neither a file nor a directory."
                    fi
                fi
                ;;
            y)
                echo "Enter the name for the new file:"
                read filename
                touch "$dir/$filename"
                echo "Created file: $filename"
                ;;
        esac
    done
}

main() {
    local start_dir="$HOME"
    if [ -n "$1" ]; then
        start_dir="$1"
    fi

    display_ascii_art
    list_files "$start_dir"
}

main "$@"
