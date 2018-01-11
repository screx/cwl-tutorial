
# echo
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

TODO: get output of the cwl runner
```

OKAY! now we have our first tool wrapped in CWL. The idea behind it is that all necessary tools are wrapped in this formal language description, then can be combined and run in a workflow.

##### Capturing stdout

If instead of printing to stdout we wanted to output to a file we would make the following changes: add the `stdout` field with the `filename` as its value and add it as a formal output


```
stdout: message.txt

outputs:
  output:
    type: stdout
```
