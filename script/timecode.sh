# Shared timecode functions for GIF workflow scripts
# Source this file, do not execute directly

function calc_duration {
    local start_secs=$(timecode_to_seconds "$1")
    local end_secs=$(timecode_to_seconds "$2")

    dc -e "3k $end_secs $start_secs - p"
}

function timecode_to_seconds {
    # 00:00:01,500; 0:01.5
    local tc="${1//,/.}"

    local parts
    local hours=0 minutes=0 seconds=0
    IFS=':' read -ra parts <<< "$tc"

    case ${#parts[@]} in
        3)
            hours="${parts[0]}"
            minutes="${parts[1]}"
            seconds="${parts[2]}"
            ;;
        2)
            minutes="${parts[0]}"
            seconds="${parts[1]}"
            ;;
        1)
            seconds="${parts[0]}"
            ;;
    esac

    dc -e "3k $hours 3600 * $minutes 60 * + $seconds + p"
}

function adjust_timecode {
    local tc="$1"
    local offset="$2"
    local secs=$(timecode_to_seconds "$tc")
    local dc_offset="${offset/-/_}"  # dc uses _ for negative numbers
    local adjusted=$(dc -e "3k $secs $dc_offset + p")

    [[ "$adjusted" == -* ]] \
        && adjusted=0

    seconds_to_timecode "$adjusted"
}

function seconds_to_timecode {
    local total="$1"
    local hours=$(dc -e "$total 3600 / p")
    local minutes=$(dc -e "$total 3600 % 60 / p")
    local seconds=$(dc -e "3k $total $hours 3600 * - $minutes 60 * - p")

    if [[ "$hours" -gt 0 ]]; then
        printf '%d:%02d:%05.2f' "$hours" "$minutes" "$seconds"
    else
        printf '%d:%05.2f' "$minutes" "$seconds"
    fi
}

function is_relative_duration {
    local input="$1"

    [[ "$input" =~ [:hm] ]] \
        && return 1
    return 0
}

function normalise_timecode {
    local input="$1"

    if [[ ! "$input" =~ ^[0-9:.hms\ ]+$ ]]; then
        echo "Invalid timecode: $input" >&2
        return 1
    fi

    if [[ "$input" =~ : ]]; then
        echo "$input"
        return
    fi

    if [[ "$input" =~ [hm] ]]; then
        local hours=0 minutes=0 seconds=0

        # 1h15m35s; 1h 15m 35s; 15m35s; 1h 15m
        [[ "$input" =~ ([0-9]+)h ]] \
            && hours="${BASH_REMATCH[1]}"
        [[ "$input" =~ ([0-9]+)m ]] \
            && minutes="${BASH_REMATCH[1]}"
        [[ "$input" =~ ([0-9.]+)s ]] \
            && seconds="${BASH_REMATCH[1]}"

        if [[ "$hours" -gt 0 ]]; then
            printf '%d:%02d:%02g\n' "$hours" "$minutes" "$seconds"
        else
            printf '%d:%02g\n' "$minutes" "$seconds"
        fi
    else
        local total_seconds="${input%s}"
        local int_seconds="${total_seconds%%.*}"
        local decimal=""

        # 75; 75s; 75.5
        [[ "$total_seconds" =~ \. ]] \
            && decimal=".${total_seconds#*.}"

        local minutes=$((int_seconds / 60))
        local secs=$((int_seconds % 60))
        printf '%d:%02d%s\n' "$minutes" "$secs" "$decimal"
    fi
}
