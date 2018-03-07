#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "sort bam"

baseCommand: samtools
arguments: ["sort", "-o"]

inputs:
    output_bam:
        type: string
        inputBinding:
            position: 3

    input_bam:
        type: File
        inputBinding:
            position: 4

outputs:
    sorted_bam:
        type: File
        outputBinding:
            glob: $(inputs.output_bam)
