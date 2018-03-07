#!/bin/bash

function vcf_to_region {
    local window="$1"
    local input="$2"

    local tmpfile=tmp.$$
    awk -v window="$window" '/^[^#]/{
        s = $2 - window;
        e = $2 + window;
        s = (s < 1) ? 1 : s;
        printf "%s_%d\t%s:%d-%d\n", $1, $2, $1, s, e
    }' "$input" > "$tmpfile"


    while IFS=$'\t' read -ra line
    do
        echo "${line[1]}" > regions."${line[0]}".txt
    done < "$tmpfile"
    rm -f "$tmpfile"
}

readonly WINDOWSIZE=${1:-50}
readonly INPUTFILE="${2:-/dev/stdin}"

vcf_to_region "$WINDOWSIZE" "$INPUTFILE"
