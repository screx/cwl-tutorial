cwlVersion: v1.0
class: CommandLineTool
baseCommand: wc
stdout: $()
inputs:
  input_file
  output_file
outputs:
  count:
    type: stdout
