# grep

Now we will wrap the grep command for its basic functionality (more can be done to the wrapper but I leave that as an exercise for you!).

grep -e searches through files for the given regular expressions passed in as arguments

### Basic Usage

```bash
user $ grep "^a.*$" somefile.txt > occurences.txt
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

Now the inputs of the file

```
inputs:

  extended:
    type: boolean? # we denote optional parameters with a ? alternatively an array can be used e.g. [null, boolean]
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

Here we see we have an optional argument called `extended`. Extended adds the flag -e if the parameter is set to true. In this case it gives extended capabilities to `search_string` to use regular expressions

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

