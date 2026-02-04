bats_require_minimum_version 1.7.0

source script/timecode.sh

@test "timecode_to_seconds hours minutes seconds" {
    run timecode_to_seconds '1:15:35'
    diff -u <(echo '4535') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "timecode_to_seconds minutes seconds" {
    run timecode_to_seconds '15:35'
    diff -u <(echo '935') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "timecode_to_seconds with decimal" {
    run timecode_to_seconds '1:30.5'
    diff -u <(echo '90.5') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "timecode_to_seconds handles SRT comma format" {
    run timecode_to_seconds '00:01:30,500'
    diff -u <(echo '90.500') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "timecode_to_seconds plain seconds" {
    run timecode_to_seconds '45'
    diff -u <(echo '45') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "seconds_to_timecode minutes seconds" {
    run seconds_to_timecode 90
    diff -u <(echo '1:30.00') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "seconds_to_timecode with decimals" {
    run seconds_to_timecode 3088.336
    diff -u <(echo '51:28.34') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "seconds_to_timecode hours minutes seconds" {
    run seconds_to_timecode 3661.5
    diff -u <(echo '1:01:01.50') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "seconds_to_timecode sub-minute" {
    run seconds_to_timecode 28.336
    diff -u <(echo '0:28.34') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "calc_duration simple" {
    run calc_duration '0:10' '0:15'
    diff -u <(echo '5') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "calc_duration across minutes" {
    run calc_duration '1:50' '2:10'
    diff -u <(echo '20') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "calc_duration with decimals" {
    run calc_duration '0:10.5' '0:15.75'
    diff -u <(echo '5.25') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "calc_duration across hours" {
    run calc_duration '0:59:50' '1:00:10'
    diff -u <(echo '20') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "adjust_timecode positive offset" {
    run adjust_timecode '1:00' 5
    diff -u <(echo '1:05.00') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "adjust_timecode negative offset" {
    run adjust_timecode '1:00' -5
    diff -u <(echo '0:55.00') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "adjust_timecode clamps to zero" {
    run adjust_timecode '0:05' -10
    diff -u <(echo '0:00.00') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "adjust_timecode decimal offset" {
    run adjust_timecode '1:00' 0.25
    diff -u <(echo '1:00.25') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "adjust_timecode negative decimal offset" {
    run adjust_timecode '1:00' -0.25
    diff -u <(echo '0:59.75') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "normalise_timecode colon format passes through" {
    run normalise_timecode '1:15:35'
    diff -u <(echo '1:15:35') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "normalise_timecode colon format minutes seconds" {
    run normalise_timecode '3:04'
    diff -u <(echo '3:04') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "normalise_timecode colon format with decimal" {
    run normalise_timecode '3:04.5'
    diff -u <(echo '3:04.5') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "normalise_timecode plain seconds converts to minutes" {
    run normalise_timecode '65'
    diff -u <(echo '1:05') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "normalise_timecode plain seconds with decimal" {
    run normalise_timecode '65.25'
    diff -u <(echo '1:05.25') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "normalise_timecode verbose format hours minutes seconds" {
    run normalise_timecode '1h15m35s'
    diff -u <(echo '1:15:35') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "normalise_timecode verbose format minutes seconds" {
    run normalise_timecode '15m35s'
    diff -u <(echo '15:35') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "normalise_timecode verbose format with spaces" {
    run normalise_timecode '1h 15m 35s'
    diff -u <(echo '1:15:35') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "normalise_timecode verbose format hours and minutes only" {
    run normalise_timecode '1h 15m'
    diff -u <(echo '1:15:00') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "normalise_timecode verbose format with decimals" {
    run normalise_timecode '1m30.5s'
    diff -u <(echo '1:30.5') <(echo "$output")
    [ "$status" -eq 0 ]
}

@test "is_relative_duration true for seconds with suffix" {
    run is_relative_duration '5s'
    [ "$status" -eq 0 ]
}

@test "is_relative_duration true for decimal with suffix" {
    run is_relative_duration '1.5s'
    [ "$status" -eq 0 ]
}

@test "is_relative_duration true for plain number" {
    run is_relative_duration '75'
    [ "$status" -eq 0 ]
}

@test "is_relative_duration false for colon format" {
    run is_relative_duration '1:15:35'
    [ "$status" -eq 1 ]
}

@test "is_relative_duration false for verbose with hours" {
    run is_relative_duration '1h15m35s'
    [ "$status" -eq 1 ]
}

@test "is_relative_duration false for verbose with minutes" {
    run is_relative_duration '15m35s'
    [ "$status" -eq 1 ]
}
