#!/usr/bin cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: gunzip
arguments: ["-c"]
requirements:
  - class: InlineJavascriptRequirement

stdout: $(inputs.zip_file.nameroot)

inputs:
  zip_file:
    type: File
    inputBinding:
      position: 5
    label: The file that is being unzipped   
outputs:
  unzipped_file:
    type: stdout
    
