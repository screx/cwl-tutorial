#!/usr/bin cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: wc
requirements:
  InlineJavascriptRequirement: {}

stdout: $(inputs.output_filename)
arguments: ["-l"]

inputs:
  input_file:
    type: File
    streamable: true
    inputBinding:
      position: 1
  output_filename:
    type: string

outputs:
  count:
    type: stdout
