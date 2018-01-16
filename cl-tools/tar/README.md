# tar

tar is a compression tool.


## Basic Usage

```
user $ tar -xvzf some.tar.xz
```

we will attempt to create a workflow description of this usage of tar. As with the other programs this is not exhaustive and will be just a short small description for the purposes of the tutorial.

## Wrapping

```
# add the shebang
#!/usr/bin/ cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: tar
```

```
arguments: [-x, -v, -z, -f]

```

as with the other examples the rest should be pretty straightforward.

```
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

objective of this section
* output globbing
* just another tool maybe skip this step and just go straight to workflow.

