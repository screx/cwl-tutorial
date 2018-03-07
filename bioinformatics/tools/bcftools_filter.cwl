#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "filter variants"

baseCommand: "bcftools"
stdout: $(inputs.output_filename)
arguments: ["filter",  "-i"]

inputs:
    condition:
        type: string
        inputBinding:
            position: 1

    input_file:
        type: File
        streamable: true
        inputBinding:
            position: 2

    output_filename:
        type: string?
        default: output_filtered.vcf

outputs:
    subset:
        type: stdout
