#!/usr/bin/ cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: tar
arguments: [-x, -z, -v, -f]

inputs:
  compress_file:
    type: File
    inputBinding:
      position: 1
outputs:
  uncompress_file:
    type: File
    outputBinding:
      glob: "*"
