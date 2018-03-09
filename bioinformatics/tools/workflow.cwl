#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
    - class: ScatterFeatureRequirement
    - class: StepInputExpressionRequirement

inputs:
    input_vcf_file:
        type: File
    input_bam_file:
        type: File
    region:
        type: string
    condition:
        type: string
    windowsize:
        type: int
        default: 50
    output_filename:
        type: string

outputs:
    smallsortbam:
        type: File
        outputSource: samtools_sort/sorted_bam

steps:
    extract:
        run: tabix_extract.cwl
        in:
            input_file:
                source: input_vcf_file
            region:
                source: region
        out: [subset_by_region]

    filter:
        run: bcftools_filter.cwl
        in:
            input_file: 
                source: extract/subset_by_region
            condition: 
                source: condition
        out: [subset]

    regions:
        run: vcf_to_region.cwl
        in:
            windowsize:
                source: windowsize
            input_file:
                source: filter/subset
        out: [regions]

    samtools_view:
        run: samtools_view.cwl
        scatter: region
        in:
            input_bam:
                source: input_bam_file
            region:
                source: regions/regions
            output_bam:
                valueFrom: $(inputs.region.nameroot).bam
        out: [filtered_bam]

    samtools_merge:
        run: samtools_merge.cwl
        in:
            input_bams:
                source: samtools_view/filtered_bam
        out: [merged_bam]

    samtools_sort:
        run: samtools_sort.cwl
        in:
            input_bam:
                source: samtools_merge/merged_bam
            output_bam:
                source: output_filename
        out: [sorted_bam]
