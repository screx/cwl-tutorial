cwlVersion: v1.0
class: CommandLineTool
baseCommand: tar
arguments: [-x, -v, -f]

inputs:
  zip_file:
    type: File
    inputBinding:
outputs:
  output_file:
    type: 
