PYTHON=venv/bin/python
PDFLATEX=pdflatex

SECONDARY: data/.created models/.created output/.created

venv/bin/python: requirements.txt
	test -d venv || virtualenv -p python3 venv
	venv/bin/pip install -Ur requirements.txt
	touch venv/bin/python

%/.created:
	mkdir -p $(dir $@)
	touch $@

*.py: venv/bin/python

data/%.csv: data/.created
	curl -o $@ https://s3-us-west-2.amazonaws.com/jonmpqts-7641/$*.csv
	touch -m $@

data/%.hd5: data/%.csv %-preprocess.py
	$(PYTHON) $*-preprocess.py data/$*.csv $@

models/%-km.joblib: models/.created data/%.hd5 %-km.json km.py
	$(PYTHON) km.py data/$*.hd5 $*-km.json $@

models/%-gmm.joblib: models/.created data/%.hd5 %-gmm.json gmm.py
	$(PYTHON) gmm.py data/$*.hd5 $*-gmm.json $@

output/%-km-elbow.png: output/.created data/%.hd5 models/%-km.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py data/$*.hd5 models/$*-km.joblib $@

output/%-gmm-elbow.png: output/.created data/%.hd5 models/%-gmm.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py data/$*.hd5 models/$*-gmm.joblib $@

output/analysis.pdf: output/.created ml-pr3-analysis/analysis.tex
	$(PDFLATEX) -output-directory=output ml-pr3-analysis/analysis.tex
