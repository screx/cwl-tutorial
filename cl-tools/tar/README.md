# tar

tar is a compression tool.


## Basic Usage

```
user $ tar -xvzf some.tar.xz
```

we will attempt to create a workflow description of this usage of tar. As with the other programs this is not exhaustive and will be just a short small description for the purposes of the tutorial.

## Wrapping

```
#!/usr/bin/ cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: tar
arguments: [-x, -v, -z, -f]
inputs:
  tarfile:
    type: File
    inputBinding:
      position: 1
    label: the file to be decompressed

outputs:
  extractfile:
    type: File
    outputBinding:
      glob: "*"
```


As with the other examples the rest should be pretty straightforward.Here we see we have a field called glob. This puts any file that matches the pattern from the value and binds it to that particular output object. Since tar automatically generates filenames we can simply use the wildcard pattern to glob for all outputs!

```
outputs:
  extractfile:
    type: File
    outputBinding:
      glob: "*"
```