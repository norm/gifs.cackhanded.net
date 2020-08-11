source bin/make_gif

@test join_basic_use {
    [ 'a,b' = "$(join ',' a b)" ]
    [ 'a,b,c,d' = "$(join ',' a b c d)" ]
}

@test join_empty_args_no_extra_commas {
    [ '' = "$(join ',' "")" ]
    [ '' = "$(join ',' "" "")" ]
    [ '' = "$(join ',' "" "" "")" ]
    [ 'a,b' = "$(join ',' "" a b "")" ]
}
