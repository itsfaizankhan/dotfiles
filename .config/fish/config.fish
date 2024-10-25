set -U fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source

    # Set default node version in nvm.fish. Requires nvm.fish plugin, not nvm itself.
    set -U nvm_default_version v20.14.0

    # Some common aliases and abbreviations I use frequently. Requires mentioned programs/tools.
    abbr -a gits git status
    abbr -a gitc git commit -m
    abbr -a py python3.12
    abbr -a sudu sudo apt update
    abbr -a sudup sudo apt upgrade

    alias venv=". ./.venv/bin/activate.fish"
    alias nopycache="export PYTHONDONTWRITEBYTECODE=1"

    # eza aliases. Requires eza.
    alias eza_base="eza --classify auto --icons auto --hyperlink --color auto --group-directories-first"
    alias ls="eza_base"
    alias ll="eza_base -l --header --no-permissions --no-user"
    alias la="ls -A"
    alias lla="ll -A"

    # Setup autocompletion for eza aliases. Requires eza.
    complete --command ls --wraps eza
    complete --command la --wraps eza
    complete --command ll --wraps eza
end

# Fetch and save all directories matching with the provided name from remote repo.
# BUG: Clones all the subdirectories which matches with the given query.
# Example: Cloning "examples" directory from a repo will clone `examples` and `docs/examples`.
function git-clone-subdirectory -a link -a repo_subdir
    # set --show link subdir argv
    git clone -n --depth=1 --filter=tree:0 $link

    # trim trailing ".git" if it exists.
    set -l link (string replace .git '' $link)
    # Extract repo name from link.
    set -l repo_name (string match -rg '\/.*\/(.*)$' $link)

    printf 'Cloning directory %s into %s from %s\n' $repo_subdir $repo_name $link

    cd $repo_name
    git sparse-checkout set --no-cone $repo_subdir
    git checkout
end

# Create a directory and cd into it.
function md --description "md - Create a directory and change into it."
    set -l _help_msg "md - Create a directory and change into it.
Usage:
    md <directory>

Description:
    The `md` command creates the specified directory and immediately changes
    into it. If the directory already exists, it will simply change into it."

    argparse "h/help" -- $argv
    or return

    if set -q _flag_help
        echo $_help_msg
        return 0
    end

    # Check if exactly one argument is provided
    if test (count $argv) -ne 1
        echo $_help_msg
        return 1
    end

    # Attempt to create the directory
    mkdir -p $argv[1]
    if test $status -ne 0
        echo "Error: Failed to create directory '$argv[1]'"
        return 1
    end

    # Attempt to change into the directory
    cd $argv[1]
    if test $status -ne 0
        echo "Error: Failed to change directory to '$argv[1]'"
        return 1
    end
end

# Workaround for screencast not working more than once per session
function restartcast
    kill (ps aux | grep gjs | grep Screencast | grep -v 'grep' | awk '{print $2}')
end

# Restart audio services, including bluetooth device related stuff
function restartaudio
    sudo systemctl --user restart wireplumber pipewire pipewire-pulse
end

# Start docker and related services
function startdocker
    sudo systemctl start docker.service docker.socket containerd
end

# Stop docker and related services
function stopdocker
    sudo systemctl stop docker.service docker.socket containerd
end

# Check if docker and related services are running
function checkdocker
    systemctl status docker.service docker.socket containerd
end

# Set title metadata of video files to their filenames wihout extension name. Requires exiftool.
function set-title-to-filename
    for file in *.mp4 *.mov *.avi *.mkv *.m4v
        set filename (basename "$file" .(echo $file | sed 's/.*\.//'))
        exiftool -overwrite_original -Title="$filename" "$file"
    end
end

# Bulk rename file extensions
function rename_extension
    if test -z "$argv[1]" -o -z "$argv[2]"
        echo "Usage: rename_extension <old_extension> <new_extension>"
        return 1
    end

    set old_extension $argv[1]
    set new_extension $argv[2]

    for file in *.$old_extension
        set new_name (echo $file | sed "s/\.$old_extension\$/.$new_extension/")
        mv -- "$file" "$new_name"
    end
end

# A utility function which renames the given array of files such that filename is NTFS-compatible
function rename_file_array -a file_array
    echo "Renaming"
    echo $file_array
    if test (count $argv) -gt 1
        for filename in $argv
            echo $filename
            set newname (echo $filename | sed 's/[|:\/\\]/-/g')
            set newname (echo $newname | sed 's/[?*<>"]//g')
            set newname (echo $newname | sed 's/  */ /g')
            if test "$filename" != "$newname"
                mv "$filename" "$newname"
                echo "Renamed '$filename' to '$newname'"
            else
                echo "No renaming needed for '$filename'"
            end
        end
    else
        echo "File array not provided"
    end
end

# Rename files to be NTFS-compatible
function rename_for_windows
    # Check if the --all flag is provided
    if test $argv[1] = "--all"
        # If a directory path is provided with --all, use that directory
        if test (count $argv) -gt 2
            for i in $argv
                echo $i
            end
            echo "dir is $argv[2]"
            set target_dir $argv[2]
        else
            echo "Current dir"
            # If no directory is specified, use the current directory
            set target_dir "."
        end

        # Get all files in the specified directory and rename them
        rename_file_array (find $target_dir -maxdepth 1 -type f | sed 's|^\./||')
    else
        # Use the provided filenames
        rename_file_array $argv
    end
end

### Fish syntax highlighting
set -g fish_color_autosuggestion '555'  'brblack'
# set -g fish_color_cancel -r
set -g fish_color_command brcyan --bold --italics
# set -g fish_color_comment red
# set -g fish_color_cwd green
set -g fish_color_cwd_root red
# set -g fish_color_end brmagenta
# set -g fish_color_error brred
# set -g fish_color_escape 'bryellow'  '--bold'
# set -g fish_color_history_current --bold
# set -g fish_color_host normal
# set -g fish_color_match --background=brblue
# set -g fish_color_normal normal
# set -g fish_color_operator bryellow
# set -g fish_color_param cyan
# set -g fish_color_quote yellow
# set -g fish_color_redirection brblue
# set -g fish_color_search_match 'bryellow'  '--background=brblack'
# set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
# set -g fish_color_user brgreen
# set -g fish_color_valid_path --underline
