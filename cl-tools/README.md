# Command Line Tools

A few tools have been wrapped to show basic functionality in CWL. The descriptions are not exhaustive, but for the purposes of the tutorial will show how to wrap a few functions and use them together in a workflow

## echo

First we will show how to wrap a basic command line tool, `echo`. echo writes arguments to stdout.

#### Basic usage
```bash
user$ echo test
test
user$ SOME_ENV_VAR="nothing"
user$ echo $SOME_ENV_VAR
nothing
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
  message:
    type: string
    label: message to print to stdout

outputs: []
```
And that's it.

## Running

To run the workflow:

  1. Ensure the virtualenv is enabled with cwltools and cwl-runner installed
  2. Type the following command into the terminal
      `cwl-runner workflow/basic.cwl basic.yml`

To re-use this basic workflow modify basic.yml, or create a new one with the same parameters that `basic.cwl` takes.

