# Common Workflow Language (CWL) Tutorial (WIP)

This tutorial will walk through the basics of CWL to create some basic tool descriptions and workflows. This was created for The Hospital for Sick Children in Toronto (SickKids)

## What is CWL?

[CWL](http://commonwl.org) is a tool that allows for easier design and manipulation of tools in a workflow. 

It can be used to write cleaner workflows that allow quick and easy reproducibility in other environments.

With CWL every component is given a formal description in [JSON](http://json.org) or [YAML](http://yaml.org) format. The wrapping is used to explicitly describe the inputs and outputs of a program and any other requirements that are needed to run a tool. CWL is simply used to describe the command line tool and workflows and in itself is not software. 


This formal description of the tool is useful for the sole purpose of reproducibility and interoperability between systems as it then becomes easier to read how to use the tools, and how it can interact with different ones as well as endowing the ability to run the tools with various programs that have implemented CWL (e.g. [cwltool](https://github.com/common-workflow-language/cwltool), [toil](https://github.com/BD2KGenomics/toil), [arvados](https://arvados.org)).
.

## Table of Contents

* [Setup](#setup)
* [Components](#components)
  * [File Structure](#file-structure)
  * [More Tool Wrapping](#more-tool-wrapping)
    * [grep](#grep)
    * [wc](#wc)
    * [tar](#tar)
* [Tool Wrapping](#tool-wrapping)
* [Workflows](#first-workflow)
* [Visualization Tools](#visualization-tools)
* [The Cluster](#the-cluster)



## Setup

To follow this tutorial you will need a UNIX system capable of basic command line tools and python

It is recommended to setup a virtual environment before installing cwltool

```
$virtualenv env
$source env/bin/activate
```

Install the reference implementation from PyPi

```
$pip install cwlref-runner
```

## Components

There are two main components to using CWL: (1) a CWL file (`.cwl`), and (2) a YAML (`.yml`) file.
These file types serve two distinct purposes. The CWL file is responsible for describing what is going to run and what inputs the program takes and the YAML file holds the values that the workflow will be executed with.

### File Structure


The order to these files don’t matter as it uses a hashmap to construct the runner, but in general it might be a good idea to follow a logical flow to these files so that a person that reads it doesn’t get so confused

`cwlVersion`: describes the version of cwl being used

`class`: describes what the program is (e.g. `CommandLineTool`,`Workflow`)

`baseCommand`: provides the name of the program that will actually run

`inputs`: declares the inputs of the program

`outputs`: declares the outputs of the program

`records`: declares relationships between programs/parameters

`requirements`: declares special requirements needed by the program such as dependencies 

`steps`: used for the actual creation of workflows and linking programs together.


## Tool Wrapping


First we will show how to wrap a basic command line tool, `echo`. echo writes arguments to stdout.

**Basic Usage**
```bash
$echo test
test
```

In this case wrapping echo can be as easy as describing its inputs and outputs, here we will just cover the basic use of echo, writing to stdout.

```
#!/usr/bin/ cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo

inputs:
  message:
    type: string
    inputBinding:
        position: 1
    label: message to print to stdout

outputs: []
```

We start by writing out some required fields required by CWL for tool descriptions
```
#!/usr/bin cwl-runner

cwlVersion:v1.0
class: CommandLineTool #this says that the CWL file describes a command line tool
baseCommand: echo #this says we are using the echo command

```

Now we want to cover the inputs and outputs. For this usage of echo, it takes in a parameter and writes that to stdout.

```
inputs:
  message: # the unique identifier to the input
    type: string # the type of input parameter that is passed in
    label: message to print to stdout # a brief description
    inputBinding:
      position: 1

outputs: [] # here there are no outputs as we are simply printing to stdout
```

Now the echo command is wrapped and ready for use.

### YAML files

Before the tool is run, we need to actually create some inputs to use with the tool.

All this entails is using the CWL descriptions input descriptions and giving them actual values stored in a YAML file.

For the echo tool we see that it takes one input parameter `message` and its `type` is `string` and we can define a YAML file, helloworld.yml

```
# helloworld.yml

message: Hello, world!

``` 


### Running the tool

Running the tool requires the use of a cwl-implementation, for the tutorial we will use the reference implementation cwl-runner.

```
$ cwl-runner echo.cwl helloworld.yml

[job echo.cwl] /tmp/tmpPKUcwP$ echo \
    'Hello, World'
Hello, World
[job echo.cwl] completed success
Final process status is success

```

OKAY! now we have our first tool wrapped in CWL. The idea behind it is that all necessary tools are wrapped in this formal language description, then can be combined and run in a workflow.

### More Tool Wrapping

Before we get to workflows lets touch on some more basic concepts that are used in CWL, and wrap tools that can then be used together in a workflow

### GREP

Let us now work with a tool that takes in files as inputs. The grep tool is able to search for the desired searh string within a file.

```
$grep "hello" helloworld.txt
hello world
```

__CWL DESCRIPTION__

```
cwlVersion: v1.0
class: CommandLineTools
baseCommand: grep
stdout: results.txt
inputs:
  extended:
    type: boolean?
    inputBinding:
      position 1
      prefix: -e
  search_string:
    type: string
    label: The string to look for in search_file
    inputBinding:
      position: 2
  search_file:
    type: File
    label: The file to search
    inputBinding:
      position: 3
outputs:
  occurences:
    type:stdout
```

One difference that we included is we can include an optional parameter in inputs `extended` that can be added to use regex in out search_strings.

```
inputs:
  extended:
    type: boolean? #this can be written as [null, boolean] instead!
    inputBinding:
      position 1
      prefix: -e #if it's true, includes the -e flag to the command!
    label: Allow use of regex.
```

In this example we are also taking a File as input. More on the input types used and their uses can be found on [the CWL user guide](http://commonwl.org/user_guide)


```
search_file
  type: File
  label: The File to search
  inputBinding
```

The YML file used for also changes a bit as we have to describe the input as a YAML object.

```
extended: true
search_string: Hello, world
search_file:
  class: File
  path: "Hello_world.txt"
```


### WC


The wc (wordcount) command prints newline, word, and byte counts for each file. Here we will use `wc` with the `-l` flag.

```
user: $ wc -l somefile.txt
# prints number of lines in somefile.txt to stdout
```


```
#!/usr/bin cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: wc
requirements:
  InlineJavascriptRequirement: {}

stdout: $(inputs.output_filename)
arguments: ["-l"]

inputs:
  input_file:
    type: File
    streamable: true
    inputBinding:
      position: 1
  output_filename:
    type: string?
    default: count.txt

outputs:
  count:
    type: stdout

```


If we wanted to include the `-l` flag here every time we run the command we can do so by declaring it in `arguments` instead of as a parameter of `inputs`

```
arguments: [-l]
```


`streamable: true` can be used to stream the output between tools instead of creating a file then subsequently deleting it to speed things up.

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
stdout: $(inputs.output_file) #javascript is used to access the inputs object. Any ES6 expression can be used within $(...) notation. 
outputs:
  count:
    type:stdout
```


### TAR


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

## Workflows

In this step of the tutorial we will combine the different tools we wrapped to be run together with a single command. We will create a workflow that takes a compressed file, uncompresses it, searches for a desired string, then outputs the number of occurences found in that document into a file named count.txt

We will use the tools gzip, grep, and wc.

```
#!/usr/bin/ cwl-runner

cwlVersion: v1.0
class: Workflow
inputs:
  zip_file:
    type: File
  search_string:
    type: string
  output_filename: 
    type: string?

requirements:
  MultipleInputFeatureRequirement: {}

steps:
  untar:
    run: ../tar/tar.cwl
    in:
      compress_file: zip_file
    out: [uncompress_file]
  grep:
    run: ../grep/grep.cwl
    in:
      extended:
        default: true
      search_file: untar/uncompress_file
      search_string: search_string
    out: [occurences]
  wc:
    run: ../wc/wc.cwl
    in:
      input_file: grep/occurences
      output_filename: output_filename
    out: [count]

outputs:
  occurences:
    type: File
    outputSource: [wc/count]

```

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
$ cwl-runner zipcount.cwl scrooge.yml

/cwl-tutorial/venv/bin/cwl-runner 1.0.20180108222053
Resolved 'workflow/basic.cwl' to 'file:///cwl-tutorial/cl-tools/workflow/basic.cwl'
[workflow basic.cwl] start
[step untar] start
[job untar] /tmp/tmpRS75VX$ tar \
    -x \
    -z \
    -v \
    -f \
    /tmp/tmpSRhqkM/stgec99cb52-ab94-42d5-a1bd-114a4bfa6417/christmas_carol.tar.gz
christmas_carol.txt
[job untar] completed success
[step untar] completed success
[step grep] start
[job grep] /tmp/tmpLF2H3D$ grep \
    -e \
    '^.*Scrooge.*$' \
    /tmp/tmpMpIDFc/stgbd241a39-6f8e-4d66-89d3-2b64bb73d4b6/christmas_carol.txt > /tmp/tmpLF2H3D/results.txt
[job grep] completed success
[step grep] completed success
[step wc] start
[job wc] /tmp/tmp7tQILt$ wc \
    -l \
    /tmp/tmphg2Tyc/stgbfa55c2f-a82b-41bf-8cde-4e77968f1194/results.txt > /tmp/tmp7tQILt/count.txt
[job wc] completed success
[step wc] completed success
[workflow basic.cwl] completed success
{
    "occurences": {
        "checksum": "sha1$352bf226728076c9c30b108b367a39ac3be6a5b6", 
        "basename": "count.txt", 
        "location": "file:///home/cody/cwl-tutorial/cl-tools/count.txt", 
        "path": "/home/cody/cwl-tutorial/cl-tools/count.txt", 
        "class": "File", 
        "size": 71
    }
}
Final process status is success

$ cat count.txt
359 /tmp/tmphg2Tyc/stgbfa55c2f-a82b-41bf-8cde-4e77968f1194/results.txt


```

## Modifying the workflow

Lets look into grep's `man` for some options that we can add to the grep tool description

Here I describe adding the functionality of including the `invert-match` option via the `-v` flag.

```
inputs:
  invert_match:
    type: boolean
      inputBinding: 2
      prefix: -v
```


## Visualization Tools

A tool developed by rabix that allows the client to create workflows and tool descriptions in an aesthetically pleasing GUI. It allows the client to visualize these descriptions from their inputs and outputs, to the interactions between the tools and how something can flow from the input of one tool to the output of (several) others.

It offers an easier method of setting up the workflow descriptions along by including the required sections and other more obscure options that may not be talked about in the CWL tutorial. Alternatively it also allows the client to input actual code which is then parsed and converted to a workflow diagram.

![workflows on rabix-composer](asdasd)

![tool description on rabix-composer](asdasd)

## Working on the cluster

For the cluster we will instead use a toil-cwl to execute the workflow descriptions. Toil is a program that ...

(WIP)
