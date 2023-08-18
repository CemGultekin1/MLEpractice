.ONESHELL:

.DEFAULT_GOAL := all
.PHONY : all

WRITERS := "Cem Gultekin, Goktug Asci"
EMAILS := "cgultekin95@gmail.com, gasci@gmail.com"
PROJECT_NAME := "MLEpractice"
PROJECT_DESCRIPTION := "A setup example"
GIT_REPO = "MLEpractice"
GIT_USER = "CemGultekin1"

BINBASH =/bin/bash

SRC := src.sh

# virtual environemnt name
VENV := .venv

PIP := pip

POETRY := poetry
# created poetry files
POETRY_LOCK := poetry.lock 
POETRY_TOML := pyproject.toml 


#Folders
FOLDERS = data src build examples libs


#Github
GITIGNORE := .gitignore
GIT := git
NON_GIT_FOLDERS := $(VENV) data build # must be elements from FOLDERS

CLEANABLES = $(SRC) $(GITIGNORE) $(VENV) $(POETRY_LOCK) $(POETRY_TOML) $(README_MD) 


$(FOLDERS):
	mkdir $@

$(VENV):
	@echo $(info Creating virtual environment $(VENV))
	@python3 -m venv $(VENV);


$(GITIGNORE): $(FOLDERS)
	@echo $(info Creating $(GITIGNORE));
	@rm -rf $(GITIGNORE);
	@$(foreach file, $(NON_GIT_FOLDERS), echo $(file) >> $(GITIGNORE);)


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
		$(PIP) install numpy dask-sql SQLAlchemy --quiet;\
		$(PIP) install $(POETRY) --quiet;\
		$(PIP) freeze > requirements.txt;\
		$(POETRY) init --no-interaction --author $(WRITERS) --description $(PROJECT_DESCRIPTION) --quiet;\
		$(POETRY) add $$(cat requirements.txt ) --quiet;\
		$(POETRY) install --no-root --quiet;'



git-first-commit: $(GITIGNORE) $(POETRY) 
	@echo $(info Sets up a)
	git init
	git add .
	git commit -m "first commit"
	git branch -M main
	git remote add origin https://github.com/$(GIT_USER)/$(GIT_REPO).git
	git push -u origin main



all: $(GITIGNORE)  $(POETRY) $(FOLDERS)

clean:
	rm -rf $(CLEANABLES);

