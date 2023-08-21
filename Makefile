.ONESHELL:

.DEFAULT_GOAL := all
.PHONY : all

AUTHOR := Cem Gultekin
EMAIL := cgultekin95@gmail.com
PROJECT_NAME := MLEpractice
PROJECT_DESCRIPTION := A setup example


BINBASH := /bin/bash

SRC := src.sh

PYTHON := python3

# virtual environemnt name
VENV := .venv

PIP := pip

POETRY := poetry

# created poetry files
POETRY_LOCK := poetry.lock
POETRY_TOML := pyproject.toml


#Folders
FOLDERS = data src build examples libs notebooks

#Dependencies
# REQIREMENTS_TXT = requirements.txt

#Github
GIT_REPO = "MLEpractice"
GIT_USER = "CemGultekin1"
GITIGNORE := .gitignore
GIT_IGNORE_FOLDERS := $(VENV) data build # must be elements from FOLDERS

CLEANABLES = $(SRC) $(GITIGNORE) $(VENV)  #$(POETRY_LOCK) $(POETRY_TOML) 


$(FOLDERS):
	mkdir $@

$(VENV):
	@echo $(info Creating virtual environment $(VENV))
	@$(PYTHON) -m venv $(VENV);


$(GITIGNORE): $(FOLDERS)
	@echo $(info Creating $(GITIGNORE));
	@rm -rf $(GITIGNORE);
	@$(foreach file, $(GIT_IGNORE_FOLDERS), echo $(file) >> $(GITIGNORE);)


$(SRC): $(VENV)
	@echo $(info Environment variables are sourced in $(SRC))
	@touch $(SRC);
	@echo "#!$(BINBASH)" >> $(SRC);
	@echo "export PYTHONPATH=$$(pwd)" >> $(SRC);


$(PIP):$(VENV) $(SRC) 
	@echo $(info Updating $(PIP))
	@$(BINBASH) -c '\
		source "$(VENV)/bin/activate";\
		source $(SRC);\
		$(PIP) install --upgrade $(PIP) --quiet;\
		'
$(POETRY): $(PIP)
	@echo $(info Installing $(POETRY))
	@$(BINBASH) -c '\
		source "$(VENV)/bin/activate";\
		source $(SRC);\
		$(PIP) install $(POETRY) --quiet;\
		'

default-dependencies : $(POETRY)
	rm -rf $(POETRY_LOCK) $(POETRY_TOML)
	@echo $(info Creating default $(POETRY_LOCK) and $(POETRY_TOML))
	@$(BINBASH) -c '\
		source "$(VENV)/bin/activate";\
		source $(SRC);\
		$(POETRY) init --no-interaction --author "$(AUTHOR)" --description "$(PROJECT_DESCRIPTION)" --quiet;\
		$(POETRY) add requests numpy pandas boto3;\
		$(POETRY) add torch@2.0.0;\
		$(POETRY) add torchvision@0.15.1;\
		$(POETRY) add awscli;\
		$(POETRY) install --no-root --quiet;'

aws-configure:
	@$(BINBASH) -c '\
		source "$(VENV)/bin/activate";\
		source $(SRC);\
		aws configure;\
	'

install-dependencies: 
	@echo $(info Installing from $(POETRY_LOCK) and $(POETRY_TOML))
	@$(BINBASH) -c '\
		source "$(VENV)/bin/activate";\
		source $(SRC);\
		$(POETRY) install;'

delete-poetry-files: 
	@rm -rf $(POETRY_LOCK) $(POETRY_TOML)

pip-list:
	@$(BINBASH) -c '\
		source "$(VENV)/bin/activate";\
		source $(SRC);\
		$(PIP) list;\
	'
git-first-commit: $(GITIGNORE) $(POETRY) 
	@echo $(info Sets up a)
	git init
	git add .
	git commit -m "first commit"
	git branch -M main
	git remote add origin https://github.com/$(GIT_USER)/$(GIT_REPO).git
	git push -u origin main



all: $(GITIGNORE) $(FOLDERS) $(POETRY)

clean:
	rm -rf $(CLEANABLES)