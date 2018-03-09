#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "filter bam"

baseCommand: samtools_view_region.sh
stdout: $(inputs.output_bam)

inputs:
    region:
        type: File
        inputBinding:
            position: 1

    input_bam:
        type: File
        secondaryFiles: .bai
        inputBinding:
            position: 2

    output_bam:
        type: string?
        default: out.bam

outputs:
    filtered_bam:
        type: stdout
