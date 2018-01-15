# Common Workflow Language (CWL) Tutorial

This tutorial will walk through the basics of CWL to create some basic tool descriptions and workflows.

## What is CWL?

[CWL](commonwl.org) is a tool that allows for easier design and manipulation of tools in a workflow. 

It can be used to create cleaner solutions that allow for reproducibility in other environments. 

In CWL each tool is 'wrapped' i.e. given a formal description in [JSON](json.org) or [YAML](yaml.org) format. The wrapping is used to explicitly describe the inputs and outputs of a program and any other requirements that are needed to run a tool. CWL is simply used to describe the command line tool and workflows and in itself is not software. 

Once a tool is wrapped, it can then be executed by a cwl-implementation (e.g. [cwltool](https://github.com/common-workflow-language/cwltool), [toil](https://github.com/BD2KGenomics/toil), [arvados](arvados.org)).

This formal description of the tool is useful for the sole purpose of reproducibility and interoperability between systems as it then becomes easier to read how to use the tools, and how it can interact with different ones. 

## Table of Contents

* [Getting Started](#getting-started)
* [First Tool](#first-tool)
* [First Workflow](#firstworkflow)
* 


### Getting Started
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

### First Tool


First we will show how to wrap a basic command line tool, `echo`. echo writes arguments to stdout.

**Basic Usage**
```bash
$echo test
test
```

In this case wrapping echo can be as easy as describing its inputs and outputs, here we will just cover the basic use of echo, writing to stdout.

We start by writing out some required fields required by CWL for tool descriptions
```
#!/usr/bin cwl-runner

cwlVersion:v1.0
class: CommandLineTool
baseCommand: echo #this says we are using the echo command

```

Now we want to cover the inputs and outputs. For echo, it says that it writes out arguments to stdout and can take in any number of arguments and use environment variables but now we will just focus on taking one. In CWL, that looks like this:

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

#### YAML files

Before the tool is run, we need to actually create some inputs to use with the tool.

All this entails is using the CWL descriptions input descriptions and giving them actual values stored in a YAML file.

For the echo tool we see that it takes one input parameter `message` and its `type` is `string` and we can define a YAML file, helloworld.yml

```
# helloworld.yml

message: Hello, world!

``` 


##### Running the tool

To actually run the tool we will need a cwl-implementation, for the tutorial we will use the reference implementation cwl-runner.

```
$ cwl-runner echo.cwl helloworld.yml

[job echo.cwl] /tmp/tmpPKUcwP$ echo \
    'Hello, World'
Hello, World
[job echo.cwl] completed success
Final process status is success

```

OKAY! now we have our first tool wrapped in CWL. The idea behind it is that all necessary tools are wrapped in this formal language description, then can be combined and run in a workflow.

##### Capturing stdout

If instead of printing to stdout we wanted to output to a file we would make the following changes: add the `stdout` field with the `filename` as its value and add it as a formal output with `type: stdout`.


```
stdout: output.txt

outputs:
  output:
    type: stdout
```

and we run it similarily to the previous example.

```
$cwl-runner echo-stdout.cwl message.yml

Resolved 'echo-stdout.cwl' to 'file:///home/cody/cwl-tutorial/cl-tools/echo/echo-stdout.cwl'
[job echo-stdout.cwl] /tmp/tmpLT_FSD$ echo \
    'Hello, World' > /tmp/tmpLT_FSD/output.txt
[job echo-stdout.cwl] completed success
{
    "output": {
        "checksum": "sha1$4ab299c8ad6ed14f31923dd94f8b5f5cb89dfb54", 
        "basename": "output.txt", 
        "location": "file:///home/cody/cwl-tutorial/cl-tools/echo/output.txt", 
        "path": "/home/cody/cwl-tutorial/cl-tools/echo/output.txt", 
        "class": "File", 
        "size": 13
    }
}
Final process status is success

$cat output.txt
Hello, World

```

### grep

Now we will wrap the grep command for its basic functionality (more can be done to the wrapper but I leave that as an exercise for you!).

grep -e searches through files for the given regular expressions passed in as arguments

#### Basic Usage

```bash
$ grep -e "^a.*$" somefile.txt > occurences.txt
#  this is searching somefile.txt for lines that start with a lower case a and outputting the results into a file called occurences.txt
``` 

This is slightly different than the first exercise. One of the parameters it takes is a file. In general when a parameter that is a file is run with CWL, it creates a read-only copy of that file in a temporary folder. It also requires some extra fields in the YAML input file.

We start again by writing the required fields for a tool description

```
#!/usr/bin/ cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: grep
#baseCommand can take an array of arguments and runs them together-- in this case "grep -e" will be run

```

Now the inputs of the file. inputs can take in multiple types specified in an array. If a type is optional then we can denote this by including a `?` after the type. This is shorthand for [null, `type`]


```
inputs:

  extended:
    type: boolean? 
    inputBinding:
      position: 1
      prefix: -e
  search_string:
    type: string
    inputBinding:
      position: 2
  search_file:
    type: File
    inputBinding:
      position: 3
```

Here we see we have an optional argument called `extended`. Extended adds the flag -e if the parameter is set to true. This is done using t hIn this case it gives extended capabilities to `search_string` to use regular expressions

We see that in our basic usage that we captured the results of the search from `stdout` into a file called occurences.txt. Here we use a hardcoded name but this can be modified with the use of javascript or parameter references for more dynamic behavior.

We add a `stdout` to the cwl file as a key and the name of the `file` as the value

```
stdout: occurences.txt
```

For our outputs, we simply create an output with the type stdout

```
outputs:
  occurences:
    type: stdout
```

If we know that `grep -e` will always be run it is possible to include it as an argument that is appended to the base command. The argument field takes an array of strings/expressions and appends them after the `baseCommand`

```
arguments: [-e]
```

*Alternatively the egrep command can also be run*


```
$cwl-runner grep.cwl search.yml

```

### wc

Now we will wrap the wc tool.

#### Basic Usage



<!-- 
can we make a continous page tutorial

1. Echo
2. Grep
3. tar
4. wc
5. workflow
6. modifications (adding a step)
7. customization

 -->

