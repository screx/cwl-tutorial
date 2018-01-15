# Basic Workflows in CWL

In this step of the tutorial we will combine the different tools we wrapped to be run together with a single command. We will create a workflow that takes a compressed file, uncompresses it, searches for a desired string, then outputs the number of occurences found in that document into a file named count.txt

We will use the tools gzip, grep, and wc.

As we are creating a workflow, the `class` field must also be set accordingly
```
#!/usr/bin/ cwl-runner

cwlVersion: v1.0
class: Workflow

```

One thing that must be considered is the inputs and outputs of the intermediate steps.

Do any of the `steps` interact with each other (i.e. input of one tool can be from the output of another)

We can first start by describing all the tools that are going to be used in this Workflow leaving all the fields for their inputs blank

```
steps:
  egrep:
    run: ../grep/grep.cwl
    in:
      extended:
      search_string:
      search_file:
    out: [occurences]
  gzip:
    run: ../gunzip/gunzip.cwl
    in:
      zipped_file:
    out: [uncompress]
  wc:
    run: ../wc/wc.cwl
    in:
      input_file:
      output_filename:
    out: [count]
```

The first step to this workflow is decompressing the file thus we must use gzip first and add the inputs required for this tool to the workflows inputs list and reference them in the description for gzip in `steps`

```
...

inputs:
  zipped_file:
    type: File

...

steps:
 ...
 gzip:
   ...
   in:
     zipped_file: zipped_file
   ...

```

Running this step of the workflow will give us an uncompressed file that will be searchable with grep. Thus we can reference the parameter in grep to the output of gzip. 

the search_string parameter will need to be added as an input for the workflow.

```
...
inputs:
  ...
  search_string:
    type: string
...
steps:
  ...
  grep:
    ...
    in:
      extended:
        default: true
      search_string: search_string
      search_file: gzip/unzipped_file
    ...
...
```

We want to use the output file from the grep tool for the input for wc, so similar to before we simply reference the output of grep.

```
...
inputs:
  ...
  o_filename:
    type: string
...
steps:
  ...
  wc:
    ...
    in:
      input_file: grep/occurences
      output_filename: o_filename
    ...
  ...
...

```

Now putting all of this together should give a functional cwl workflow description and can be run with a cwl-implementation.

To run this similar to before we create a YAML(.yml) file that gives the values for the inputs

```
o_filename: count.txt
search_string: "^.*Scrooge.*$"
zip_file: 
  type: File
  class: christmas_carol.txt.gz
```

and now to put it all together:

```
user: $ cwl-runner zipcount.cwl scrooge.yml

...

user: $ cat count.txt

```

Objective of this section

hmmmm