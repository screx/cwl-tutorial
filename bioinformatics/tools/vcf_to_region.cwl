#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "VCF to regions"

baseCommand: vcf_to_region.sh

inputs:
    windowsize:
        type: int
        default: 50
        inputBinding:
            position: 1

    input_file:
        type: File
        streamable: true
        inputBinding:
            position: 2

outputs:
  regions:
    type:
      type: array
      items: File
    outputBinding:
      glob: "regions.*.txt"
