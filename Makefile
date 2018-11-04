PYTHON=venv/bin/python
PDFLATEX=pdflatex

SECONDARY: build/.created \
	build/titanic/.created build/titanic/data.csv build/titanic/data.hd5 build/titanic/timing.png build/titanic/iterations.png \
	build/titanic/km/.created build/titanic/km/model.joblib build/titanic/km/elbow.png \
	build/titanic/gmm/.created build/titanic/gmm/model.joblib build/titanic/gmm/elbow.png \
	build/titanic/rf/.created build/titanic/rf/model.joblib build/titanic/rf/chart.png \
	build/redwine/.created build/redwine/data.csv build/redwine/data.hd5 build/redwine/timing.png build/redwine/iterations.png \
	build/redwine/km/.created build/redwine/km/model.joblib build/redwine/km/elbow.png \
	build/redwine/gmm/.created build/redwine/gmm/model.joblib build/redwine/gmm/elbow.png \
	build/redwine/rf/.created build/redwine/rf/model.joblib build/redwine/rf/chart.png

venv/bin/python: requirements.txt
	test -d venv || virtualenv -p python3 venv
	venv/bin/pip install -Ur requirements.txt
	touch venv/bin/python

%/.created:
	mkdir -p $(dir $@)
	touch $@

*.py: venv/bin/python

build/%/data.csv: build/%/.created
	curl -o $@ https://s3-us-west-2.amazonaws.com/jonmpqts-7641/$*.csv
	touch -m $@

build/%/data.hd5: build/%/data.csv %-preprocess.py
	$(PYTHON) $*-preprocess.py build/$*/data.csv $@

build/%/km/model.joblib: build/%/km/.created build/%/data.hd5 %-km.json km.py
	$(PYTHON) km.py build/$*/data.hd5 $*-km.json $@

build/%/gmm/model.joblib: build/%/gmm/.created build/%/data.hd5 %-gmm.json gmm.py
	$(PYTHON) gmm.py build/$*/data.hd5 $*-gmm.json $@

build/%/km/elbow.png: build/%/km/.created build/%/data.hd5 build/%/km/model.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py build/$*/data.hd5 build/$*/km/model.joblib $@

build/%/gmm/elbow.png: build/%/gmm/.created build/%/data.hd5 build/%/gmm/model.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py build/$*/data.hd5 build/$*/gmm/model.joblib $@

build/%/timing.png: build/%/km/model.joblib build/%/gmm/model.joblib timing-plot.py
	$(PYTHON) timing-plot.py build/$*/km/model.joblib build/$*/gmm/model.joblib $@

build/%/iterations.png: build/%/km/model.joblib build/%/gmm/model.joblib iterations-plot.py
	$(PYTHON) iterations-plot.py build/$*/km/model.joblib build/$*/gmm/model.joblib $@

build/%/rf/model.joblib: build/%/rf/.created build/%/data.hd5 rf.py
	$(PYTHON) rf.py build/$*/data.hd5 $@

build/%/rf/chart.png: build/%/rf/model.joblib rf-chart.py
	$(PYTHON) rf-chart.py build/$*/rf/model.joblib $@

build/analysis.pdf: \
	build/.created \
	ml-pr3-analysis/analysis.tex \
	build/titanic/km/elbow.png \
	build/titanic/gmm/elbow.png \
	build/redwine/km/elbow.png \
	build/redwine/gmm/elbow.png \
	build/titanic/timing.png \
	build/titanic/iterations.png \
	build/redwine/timing.png \
	build/redwine/iterations.png \
	build/titanic/rf/chart.png \
	build/redwine/rf/chart.png
	$(PDFLATEX) -output-directory=build ml-pr3-analysis/analysis.tex
