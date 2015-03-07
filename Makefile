.PHONY: test run

test:
	@PYTHONPATH=. nosetests --with-xunit -vdw test

run:
	@./run.py
