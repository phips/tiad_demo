.PHONY: test run

test:
	@PYTHONPATH=. nosetests --with-xunit -vdw test

build:
	pip install -r requirements.txt

run:
	@./run.py
