#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "extract region"

baseCommand: "tabix"
stdout: $(inputs.output_filename)
arguments: ["-h"]   # include header

inputs:
    input_file:
        type: File
        secondaryFiles: .tbi
        inputBinding:
            position: 1

    region:
        type: string
        inputBinding:
            position: 2

    output_filename:
        type: string?
        default: output_tabix.vcf

outputs:
    subset_by_region:
        type: stdout
