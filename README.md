# Common Workflow Language (CWL) Tutorial (WIP)

This tutorial will walk through the basics of CWL to create some basic tool descriptions and workflows. This was created for The Hospital for Sick Children in Toronto (SickKids)

## What is CWL?

[CWL](commonwl.org) is a tool that allows for easier design and manipulation of tools in a workflow. 

It can be used to create cleaner solutions that allow for reproducibility in other environments. 

In CWL each tool is 'wrapped' i.e. given a formal description in [JSON](json.org) or [YAML](yaml.org) format. The wrapping is used to explicitly describe the inputs and outputs of a program and any other requirements that are needed to run a tool. CWL is simply used to describe the command line tool and workflows and in itself is not software. 

Once a tool is wrapped, it can then be executed by a cwl-implementation (e.g. [cwltool](https://github.com/common-workflow-language/cwltool), [toil](https://github.com/BD2KGenomics/toil), [arvados](arvados.org)).

This formal description of the tool is useful for the sole purpose of reproducibility and interoperability between systems as it then becomes easier to read how to use the tools, and how it can interact with different ones. 

## Table of Contents

* [Setup](#setup)
* [Components](#components)
  * [File Structure](#file-structure)
* [Tool Wrapping](#tool-wrapping)
* [Workflows](#first-workflow)
* 



## Getting Started
---
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
### WC
### TAR

## Workflows

## Visualization Tools

## Cluster

