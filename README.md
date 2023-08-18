## Makefiles in daily life

This is a Makefile example that contains targets for
- building a virtual environment
- installing poetry

Makefiles define dependencies. Before building a target its defined dependencies are built.
Each of the dependencies themselves should be defined as new targets.

For e.g. below 'pip' has a dependency [.venv] and [.venv] is defined as a separate target.
```bash
pip: .venv
    # put code here to install pip
.venv: 
    # put code here to build virtual environment
```
In order to build these we use [make] commands.
```bash
make pip
```
Everything defined as a dependency of target [all]
will be built from the base command.
```bash 
make
```
[make clean] is for deleting the files built by [make]. 