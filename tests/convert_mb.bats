source bin/make_gif

@test number_is_unaltered {
    [ '1024' = $(convert_mb 1024) ]
}

@test megabytes_work {
    [ '1048576' = $(convert_mb 1mb) ]
    [ '2097152' = $(convert_mb 2mb) ]
}

@test fractions_work {
    [ '1048576' = $(convert_mb 1.0mb) ]
    [ '1572864' = $(convert_mb 1.5mb) ]
}



