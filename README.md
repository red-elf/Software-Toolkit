# Software Toolkit

The 'Software Toolkit' represents a set of utilities required to build and run your projects.

Provides the following functionality to the projects:

- Versioning: defining the project version parameters from one central place
- Installation and build recipes
- Dependency providing: project can pull required dependencies and install it.
- Multiple Git upstreams support (for example, GitHub and BitBucket at the same time)
- Project testing iterraction
- Project opening support with advanced feature (pre-opening recipes, etc.)
- Desktop icon launching support

## What is included?

- The [Versionable](https://github.com/red-elf/Versionable) module
- The [Installable](https://github.com/red-elf/Installable) module
- The [Dependable](https://github.com/red-elf/Dependable) module
- The [Upstreamable](https://github.com/red-elf/Upstreamable) module
- The [Testable](https://github.com/red-elf/Testable) module
- The [Project](https://github.com/red-elf/Project) module
- The [Iconic](https://github.com/red-elf/Iconic) module

## How to install?

Execute the following:

```shell
(test -e ./clone || wget "https://raw.githubusercontent.com/red-elf/Software-Toolkit/main/clone?append="$(($(date +%s%N)/1000000)) -O clone) && \
    chmod +x ./clone && ./clone git@github.com:red-elf/Software-Toolkit.git ./Toolkit
```

or via one of the mirror repositories:

- [GitFlic](https://gitflic.ru/):

```shell
(test -e ./clone || \
    wget "https://raw.githubusercontent.com/red-elf/Software-Toolkit/main/clone?append="$(($(date +%s%N)/1000000)) -O clone) && \
    chmod +x ./clone && ./clone git@gitflic.ru:red-elf/software-toolkit.git ./Toolkit
```

- [Gitee](https://gitee.com/):

```shell
(test -e ./clone || wget "https://raw.githubusercontent.com/red-elf/Software-Toolkit/main/clone?append="$(($(date +%s%N)/1000000)) -O clone) && \
    chmod +x ./clone && ./clone git@gitee.com:Kvetch_Godspeed_b073/Software-Toolkit.git ./Toolkit
```

*Note:* It is required to execute the script from empty directory where you whish to clone the Software Toolkit utility.
