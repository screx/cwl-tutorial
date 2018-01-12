# Common Workflow Language (CWL) Tutorial
---

This tutorial will walk through the basics of CWL to create some basic tool descriptions and workflows.

## What is CWL?
---
[CWL](commonwl.org) is a tool that allows for easier design and manipulation of tools in a workflow. 

It can be used to create cleaner solutions that allow for reproducibility in other environments. 

In CWL each tool is 'wrapped' i.e. given a formal description in [JSON](json.org) or [YAML](yaml.org) format. The wrapping is used to explicitly describe the inputs and outputs of a program and any other requirements that are needed to run a tool. CWL is simply used to describe the command line tool and workflows and in itself is not software. 

Once a tool is wrapped, it can then be executed by a cwl-implementation (e.g. [cwltool](https://github.com/common-workflow-language/cwltool), [toil](https://github.com/BD2KGenomics/toil), [arvados](arvados.org), etc.).

This formal description of the tool is useful for the sole purpose of reproducibility and interoperability between systems as it then becomes easier to read how to use the tools, and how it can interact with different ones. 

## Table of Contents
---
* [Getting Started](#getting-started)
* [First Tool](#first-tool)
* [First Workflow](#firstworkflow)
* 


### Getting Started
---
To follow this tutorial you will need a UNIX system capable of basic command line tools and python

It is recommended to setup a virtual environment before installing cwltool

```
virtualenv env
source env/bin/activate
```

Install the reference implementation from PyPi

```
pip install cwlref-runner
```

### First Tool


First we will show how to wrap a basic command line tool, `echo`. echo writes arguments to stdout.

**Basic Usage**
```bash
echo test
>test
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

If instead of printing to stdout we wanted to output to a file we would make the following changes: add the `stdout` field with the `filename` as its value and add it as a formal output


```
stdout: output.txt

outputs:
  output:
    type: stdout
```



```
cwl-runner echo-stdout.cwl message.yml

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

```


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

