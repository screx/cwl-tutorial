#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: egrep
stdout: results.txt
inputs:
  search_string:
    type: string
    inputBinding:
      position: 1
  search_file:
    type: File
    inputBinding:
      position: 2
outputs:
  results:
    type: stdout

    


