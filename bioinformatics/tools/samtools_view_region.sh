#!/bin/bash

readonly REGION_FILE="${1}"
readonly INPUTFILE="${2:-/dev/stdin}"
readonly OUTPUTFILE="${3:-/dev/stdout}"

region=$( cat "${REGION_FILE}" )
samtools view -b ${INPUTFILE} "${region}"
