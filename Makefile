PYTHON=venv/bin/python

venv: venv/bin/active

venv/bin/active: requirements.txt
	test -d venv || virtualenv -p python3 venv
	venv/bin/pip install -Ur requirements.txt
	touch venv/bin/active

%/.created:
	mkdir -p $(dir $@)
	touch $@

*.py: venv

data/%.csv: data/.created
	curl -o $@ https://s3-us-west-2.amazonaws.com/jonmpqts-7641/$*.csv
	touch -m $@
