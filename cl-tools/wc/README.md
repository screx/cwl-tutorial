# wc

The wc (wordcount) command prints newline, word, and byte counts for each file. Here we will use `wc` with the `-l` flag.

### Usage

```
user: $ wc -l somefile.txt
# prints number of lines in somefile.txt to stdout
```


### Wrapping

```
#!/usr/bin/ cwl-runner

cwlVersion: v1.0
class:CommandLineTool
baseCommand: wc
```

```
arguments: [-l]
```

```
inputs:
  input_file:
    type: file
    streamable: true
    inputBinding:
      position: 1
```

```
  output_file:
    type: string?
    inputBinding:
      position: 2
    default: count.txt
```

```
stdout: $(inputs.output_file)
outputs:
  count:
    type:stdout
```
