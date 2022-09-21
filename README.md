# Software Toolkit

The 'Software Toolkit' represents a set of utilities required to build and run your projects.

Provides the following functionality to the projects:

- Versioning: defining the project version parameters from one central place
- Installation and build recipes
- Dependency providing: project can pull required dependencies and install it.

## What is included?

- The [Versionable](https://github.com/red-elf/Versionable) module
- The [Installable](https://github.com/red-elf/Installable) module
- The [Dependable](https://github.com/red-elf/Dependable) module
- The [Upstreamable](https://github.com/red-elf/Upstreamable) module

## How to use?

Clone or download the release and execute the `initialize.sh` script:

```shell
initialize.sh ~/Documents/Project_Directory "My project name"
```

The first parameter is the location of your project, and the second is the name to assign.
