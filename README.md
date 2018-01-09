# cwl-tutorial
This is a tutorial for Common Workflow Language (CWL)

## Introduction
CWL is a tool that allows for easier design and manipulation of tools in a workflow. 

It can be used for to decouple the use , cleaner solutions that allow for reproducibility in other environments. This tutorial will walk through the basics of CWL and include some basic problems and uses of CWL.

### Program Wrapping
In CWL each tool is 'wrapped' i.e. given a formal description in YAML formats. This wrapping describes any software requirements that it has as well as any and all inputs and outputs that are used.

Once a tool is wrapped, it can then be executed by a cwl-implementation (e.g. cwl-runner, toil, arvados, etc.).

This formal description of the tool is useful for the sole purpose of reproducibility and interoperability between systems as it then becomes easier to read how to use the tools, and how it can interact with different ones. 



