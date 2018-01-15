# wc

The wc (wordcount) command prints newline, word, and byte counts for each file. Here we will use `wc` with the `-l` flag.

### Usage

```
user: $ wc -l somefile.txt
# prints number of lines in somefile.txt to stdout
```


### Wrapping

As usual it starts with the basic requirements
```
#!/usr/bin/ cwl-runner

cwlVersion: v1.0
class:CommandLineTool
baseCommand: wc
```

we will include the `-l` flag here

```
arguments: [-l]
```


`streamable: true` can be used for future workflows

```
inputs:
  input_file:
    type: file
    streamable: true
    inputBinding:
      position: 1
```

We include an optional parameter `output_file` that allows us to provide a file name if necessary.

```
  output_file:
    type: string?
    inputBinding:
      position: 2
    default: count.txt
```

We can use javascript here to include a parameter reference to the string passed in via `output_file`

```
requirements: inlineJavascript
stdout: $(inputs.output_file)
outputs:
  count:
    type:stdout
```
