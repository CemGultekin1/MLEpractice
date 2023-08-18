.ONESHELL:

.DEFAULT_GOAL := all
.PHONY : all

WRITERS := "Cem Gultekin, Goktug Asci"
EMAILS := "cgultekin95@gmail.com, gasci@gmail.com"
PROJECT_NAME := "Build By Make"
PROJECT_DESCRIPTION := "An setup example"

GIT_REPO = "MLEpractice"
GIT_USER = "CemGultekin1"

BINBASH ='/bin/bash'

SRC := src.sh
GITIGNORE := .gitignore
GIT := git
READ_MD := READ.md
VENV := .venv
POETRY_LOCK := poetry.lock
POETRY_TOML := pyproject.toml
PIP := pip
POETRY := poetry

CLEAN_FILES = $(SRC) $(GITIGNORE) $(VENV) $(POETRY_LOCK) $(POETRY_TOML) $(READ_MD)

$(READ_MD):
	@echo $(info Writing $(READ_MD) file)
	@echo $(PROJECT_NAME) >> $(READ_MD);
	@echo $(WRITERS) >> $(READ_MD);
	@echo $(EMAILS) >> $(READ_MD);
	

$(VENV):
	@echo $(info Creating virtual environment $(VENV))
	@python3 -m venv $(VENV);

$(GITIGNORE):
	@echo $(info Creating $(GITIGNORE))
	@touch $(GITIGNORE);
	@echo ".*" >> $(GITIGNORE);

$(SRC): $(VENV)
	@echo $(info Environment variables are sourced in $(SRC))
	@touch $(SRC);
	@echo "#!$(BINBASH)" >> $(SRC);
	@echo "export PYTHONPATH=$$(pwd)" >> $(SRC);


$(PIP):$(VENV) $(SRC) 
	@echo $(info Installing $(PIP) to the virtual environment $(VENV))
	@$(BINBASH) -c '\
		source "$(VENV)/bin/activate";\
		$(PIP) install --upgrade $(PIP) --quiet;\
		'
$(POETRY): $(PIP)
	@echo $(info Installing $(POETRY) to the virtual environment $(VENV))
	@$(BINBASH) -c '\
		source "$(VENV)/bin/activate";\
		source $(SRC);\
		$(PIP) install $(POETRY) --quiet;\
		$(POETRY) init --no-interaction --author $(WRITERS) --description $(PROJECT_DESCRIPTION) --quiet;\
		$(POETRY) install --no-root --quiet;'

git-first-commit: $(READ_MD) $(GITIGNORE) $(POETRY) 
	git init
	git add .
	git commit -m "first commit"
	git branch -M main
	git remote add origin https://github.com/$(GIT_USER)/$(GIT_REPO).git
	git push -u origin main

all: $(READ_MD) $(POETRY) 

clean:
	rm -rf $(CLEAN_FILES);

