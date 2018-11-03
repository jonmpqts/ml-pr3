PYTHON=venv/bin/python

SECONDARY: data/.created models/.created output/.created

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

data/%.hd5: data/%.csv %-preprocess.py
	$(PYTHON) $*-preprocess.py data/$*.csv $@

models/%-km.joblib: models/.created data/%.hd5 %-km.json
	$(PYTHON) km.py data/$*.hd5 $*-km.json $@

models/%-gmm.joblib: models/.created data/%.hd5 %-gmm.json gmm.py
	$(PYTHON) gmm.py data/$*.hd5 $*-gmm.json $@

output/%-km-elbow.png: output/.created data/%.hd5 models/%-km.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py data/$*.hd5 models/$*-km.joblib $@

output/%-gmm-elbow.png: output/.created data/%.hd5 models/%-gmm.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py data/$*.hd5 models/$*-gmm.joblib $@
