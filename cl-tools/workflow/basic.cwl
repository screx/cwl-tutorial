#!/usr/bin/ cwl-runner

cwlVersion: v1.0
class: Workflow
inputs:
  zip_file:
    type: File
  search_string:
    type: string
  output_filename: 
    type: string

requirements:
  MultipleInputFeatureRequirement: {}

steps:
  gzip:
    run: ../gunzip/gunzip.cwl
    in:
      zip_file: zip_file
    out: [unzipped_file]
  grep:
    run: ../grep/grep.cwl
    in:
      search_file: gzip/unzipped_file
      search_string: search_string
    out: [results]
  wc:
    run: ../wc/wc.cwl
    in:
      input_file: grep/results
      output_filename: output_filename
    out: [count]

outputs:
  occurences:
    type: File
    outputSource: [wc/count]


