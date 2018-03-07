#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "merge bams"

baseCommand: samtools
arguments: ["merge"]

inputs:
    output_bam:
        type: string
        inputBinding:
            position: 2

    input_bams:
        type: File[]
        inputBinding:
            position: 3

outputs:
    merged_bam:
        type: File
        outputBinding:
            glob: $(inputs.output_bam)
