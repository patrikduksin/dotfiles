# Auto-load 1Password .envrc files on directory change
# Handles named pipes created by 1Password Environments feature

# Track loaded env vars per directory
set -g __op_env_loaded_dir ""
set -g __op_env_loaded_vars

function __op_env_is_named_pipe -a filepath
    test -p "$filepath"
end

function __op_env_load
    set -l envrc_path "$PWD/.envrc"

    # Skip if same directory already loaded
    if test "$__op_env_loaded_dir" = "$PWD"
        return
    end

    # Unload previous env vars if we had any
    __op_env_unload

    # Check if .envrc exists and is a named pipe (1Password)
    if test -e "$envrc_path"; and __op_env_is_named_pipe "$envrc_path"
        echo "Loading 1Password environment from .envrc..."

        # Read from the named pipe with timeout
        # 1Password will prompt for authorization
        set -l content
        if set content (timeout 30 cat "$envrc_path" 2>/dev/null)
            set -g __op_env_loaded_dir "$PWD"
            set -g __op_env_loaded_vars

            for line in $content
                # Skip empty lines and comments
                if test -z "$line"; or string match -q '#*' "$line"
                    continue
                end

                # Handle export VAR=value or VAR=value format
                set -l cleaned (string replace -r '^export\s+' '' "$line")

                # Parse KEY=VALUE
                if string match -q '*=*' "$cleaned"
                    set -l key (string split -m1 '=' "$cleaned")[1]
                    set -l value (string split -m1 '=' "$cleaned")[2]

                    # Remove surrounding quotes if present
                    set value (string trim -c '"' "$value")
                    set value (string trim -c "'" "$value")

                    if test -n "$key"
                        set -gx $key "$value"
                        set -a __op_env_loaded_vars $key
                    end
                end
            end

            if test (count $__op_env_loaded_vars) -gt 0
                echo "Loaded" (count $__op_env_loaded_vars) "environment variables"
            end
        else
            echo "Failed to read .envrc (timeout or 1Password not authorized)"
        end
    end
end

function __op_env_unload
    if test -n "$__op_env_loaded_dir"; and test (count $__op_env_loaded_vars) -gt 0
        for var in $__op_env_loaded_vars
            set -e $var
        end
        echo "Unloaded" (count $__op_env_loaded_vars) "environment variables from $__op_env_loaded_dir"
    end
    set -g __op_env_loaded_dir ""
    set -g __op_env_loaded_vars
end

function __op_env_on_pwd_change --on-variable PWD
    # Skip in non-interactive or command substitution
    status is-command-substitution; and return
    not status is-interactive; and return

    __op_env_load
end

# Manual commands
function op-env-reload -d "Reload 1Password .envrc in current directory"
    set -g __op_env_loaded_dir ""  # Force reload
    __op_env_load
end

function op-env-unload -d "Unload 1Password environment variables"
    __op_env_unload
end

function op-env-status -d "Show loaded 1Password environment variables"
    if test -n "$__op_env_loaded_dir"
        echo "Loaded from: $__op_env_loaded_dir"
        echo "Variables:"
        for var in $__op_env_loaded_vars
            echo "  $var=****"
        end
    else
        echo "No 1Password environment loaded"
    end
end

# Initial load for current directory
__op_env_load
