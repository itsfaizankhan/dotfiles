set -U fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source

    # Set default node version in nvm.fish. Requires nvm.fish plugin, not nvm itself.
    set -U nvm_default_version v20.14.0

    # Some common aliases I use frequently.
    alias venv=". ./.venv/bin/activate.fish"
    alias nopycache="export PYTHONDONTWRITEBYTECODE=1"
    alias py="python3.12"

    # eza aliases. Requires eza.
    alias eza_base="eza --classify auto --icons auto --hyperlink --color auto --group-directories-first"
    alias ls="eza_base"
    alias ll="eza_base -l --header --no-permissions --no-user"
    alias la="ls -A"
    alias lla="ll -A"
end

# Setup autocompletion for eza aliases. Requires eza.
function link_eza_completions
    for alias_name in $argv
        complete --command $alias_name --wraps eza
    end
end
link_eza_completions ls la ll

# Create a directory and cd into it.
function md
    # Check if exactly one argument is provided
    if test (count $argv) -ne 1
        echo "Usage: md <directory>"
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

### Fish syntax highlighting

# set -g fish_color_autosuggestion '555'  'brblack'
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
