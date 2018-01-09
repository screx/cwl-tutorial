cwlVersion: 1.0
class: CommandLineTool
baseCommand: gunzip
inputs:
  gzfile:
    type: File
    inputBinding:
      position: 1
outputs:
  unzipped_file:
    type: File
    outputBinding:
      glob: $(inputs.extractfile)
    
