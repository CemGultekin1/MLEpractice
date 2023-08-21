## Makefiles in daily life

This is a Makefile example that contains targets for
- building a virtual environment
- installing poetry
Makefiles are a great way to establish repeatable builds.

Makefiles define dependencies. Before building a target its defined dependencies are built.
Each of the dependencies themselves should be defined as new targets.

For e.g. below `pip` has a dependency `.venv` and `.venv` is defined as a separate target.
```bash
pip: .venv
    # put code here to install pip
.venv: 
    # put code here to build virtual environment
```
In order to build these we use `make` commands.
```bash
make pip
```
Everything defined as a dependency of target `all`
will be built from the base command.
```bash 
make
```
Currently `Makefile` is set to build `poetry` into a virtual environment `.venv` .
It installs `pip`, builds `.gitignore` and then installs `poetry` using `pip`. 
You can install libraries or compile code by customizing or adding new targets. 

We include a `git-first-commit` target that uses `GIT_USER` and `GIT_REPO` to 
initiate github, add a remote repo and do a first commit.
```bash 
make git-first-commit
```

`make clean` is for deleting the files built by `make`. 