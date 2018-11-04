PYTHON=venv/bin/python
PDFLATEX=pdflatex
BIBTEX=bibtex

SECONDARY: build/.created \
	build/titanic/.created build/titanic/data.csv build/titanic/data.hd5 build/titanic/timing.png build/titanic/iterations.png build/titanic/histogram.png \
	build/titanic/km/.created build/titanic/km/model.joblib build/titanic/km/elbow.png \
	build/titanic/gmm/.created build/titanic/gmm/model.joblib build/titanic/gmm/elbow.png \
	build/titanic/rf/.created build/titanic/rf/model.joblib build/titanic/rf/chart.png build/titanic/rf/data.hd5 \
	build/titanic/km/rf/.created build/titanic/km/rf/model.joblib build/titanic/km/rf/elbow.png \
	build/titanic/gmm/rf/.created build/titanic/gmm/rf/model.joblib build/titanic/gmm/rf/elbow.png \
	build/titanic/pca/.created build/redwine/data.hd5 build/titanic/pca/chart.png \
	build/titanic/km/pca/.created build/titanic/km/pca/model.joblib build/titanic/km/pca/elbow.png \
	build/titanic/gmm/pca/.created build/titanic/gmm/pca/model.joblib build/titanic/gmm/pca/elbow.png \
	build/titanic/ica/.created build/titanic/ica/data.hd5 build/titanic/ica/chart.png \
	build/titanic/rp/.created build/titanic/rp/data.hd5 build/titanic/rp/chart.png \
	build/titanic/km/rp/.created build/titanic/km/rp/model.joblib build/titanic/km/rp/elbow.png \
	build/titanic/gmm/rp/.created build/titanic/gmm/rp/model.joblib build/titanic/gmm/rp/elbow.png \
	build/redwine/.created build/redwine/data.csv build/redwine/data.hd5 build/redwine/timing.png build/redwine/iterations.png build/redwine/histogram.png \
	build/redwine/km/.created build/redwine/km/model.joblib build/redwine/km/elbow.png \
	build/redwine/gmm/.created build/redwine/gmm/model.joblib build/redwine/gmm/elbow.png \
	build/redwine/rf/.created build/redwine/rf/model.joblib build/redwine/rf/chart.png build/redwine/rf/data.hd5 \
	build/redwine/km/rf/.created build/redwine/km/rf/model.joblib build/redwine/km/rf/elbow.png \
	build/redwine/gmm/rf/.created build/redwine/gmm/rf/model.joblib build/redwine/gmm/rf/elbow.png \
	build/redwine/pca/.created build/redwine/data.hd5 build/redwine/pca/chart.png \
	build/redwine/km/pca/.created build/redwine/km/pca/model.joblib build/redwine/km/pca/elbow.png \
	build/redwine/gmm/pca/.created build/redwine/gmm/pca/model.joblib build/redwine/gmm/pca/elbow.png \
	build/redwine/ica/.created build/redwine/ica/data.hd5 build/redwine/ica/chart.png \
	build/redwine/rp/.created build/redwine/rp/data.hd5 build/redwine/rp/chart.png \
	build/redwine/km/rp/.created build/redwine/km/rp/model.joblib build/redwine/km/rp/elbow.png \
	build/redwine/gmm/rp/.created build/redwine/gmm/rp/model.joblib build/redwine/gmm/rp/elbow.png

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

build/%/histogram.png: build/.created build/%/data.csv %-histogram.py
	$(PYTHON) $*-histogram.py build/$*/data.csv $@

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

build/%/rf/data.hd5: build/%/rf/model.joblib build/%/data.hd5 rf-dataset.py
	$(PYTHON) rf-dataset.py build/$*/rf/model.joblib build/$*/data.hd5 $@

build/%/km/rf/model.joblib: build/%/km/rf/.created build/%/rf/data.hd5 %-km.json km.py
	$(PYTHON) km.py build/$*/rf/data.hd5 $*-km.json $@

build/%/km/rf/elbow.png: build/%/data.hd5 build/%/km/rf/model.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py build/$*/rf/data.hd5 build/$*/km/rf/model.joblib $@

build/%/gmm/rf/model.joblib: build/%/gmm/rf/.created build/%/rf/data.hd5 %-gmm.json gmm.py
	$(PYTHON) gmm.py build/$*/rf/data.hd5 $*-gmm.json $@

build/%/gmm/rf/elbow.png: build/%/data.hd5 build/%/gmm/rf/model.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py build/$*/rf/data.hd5 build/$*/gmm/rf/model.joblib $@

build/%/pca/chart.png: build/%/pca/.created build/%/data.hd5 pca-chart.py
	$(PYTHON) pca-chart.py build/$*/data.hd5 $@

build/%/pca/data.hd5: build/%/pca/.created build/%/data.hd5 %-pca.json pca-dataset.py
	$(PYTHON) pca-dataset.py build/$*/data.hd5 $*-pca.json $@

build/%/km/pca/model.joblib: build/%/km/pca/.created build/%/pca/data.hd5 %-km.json km.py
	$(PYTHON) km.py build/$*/pca/data.hd5 $*-km.json $@

build/%/km/pca/elbow.png: build/%/data.hd5 build/%/km/pca/model.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py build/$*/pca/data.hd5 build/$*/km/pca/model.joblib $@

build/%/gmm/pca/model.joblib: build/%/gmm/pca/.created build/%/pca/data.hd5 %-gmm.json gmm.py
	$(PYTHON) gmm.py build/$*/pca/data.hd5 $*-gmm.json $@

build/%/gmm/pca/elbow.png: build/%/data.hd5 build/%/gmm/pca/model.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py build/$*/pca/data.hd5 build/$*/gmm/pca/model.joblib $@

build/%/ica/chart.png: build/%/ica/.created build/%/data.hd5 ica-chart.py
	$(PYTHON) ica-chart.py build/$*/data.hd5 $@

build/%/ica/data.hd5: build/%/ica/.created build/%/data.hd5 %-ica.json ica-dataset.py
	$(PYTHON) ica-dataset.py build/$*/data.hd5 $*-ica.json $@

build/%/km/ica/model.joblib: build/%/km/ica/.created build/%/ica/data.hd5 %-km.json km.py
	$(PYTHON) km.py build/$*/ica/data.hd5 $*-km.json $@

build/%/km/ica/elbow.png: build/%/data.hd5 build/%/km/ica/model.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py build/$*/ica/data.hd5 build/$*/km/ica/model.joblib $@

build/%/gmm/ica/model.joblib: build/%/gmm/ica/.created build/%/ica/data.hd5 %-gmm.json gmm.py
	$(PYTHON) gmm.py build/$*/ica/data.hd5 $*-gmm.json $@

build/%/gmm/ica/elbow.png: build/%/data.hd5 build/%/gmm/ica/model.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py build/$*/ica/data.hd5 build/$*/gmm/ica/model.joblib $@

build/%/rp/chart.png: build/%/rp/.created build/%/data.hd5 rp-chart.py
	$(PYTHON) rp-chart.py build/$*/data.hd5 $@

build/%/rp/data.hd5: build/%/rp/.created build/%/data.hd5 %-rp.json rp-dataset.py
	$(PYTHON) rp-dataset.py build/$*/data.hd5 $*-rp.json $@

build/%/km/rp/model.joblib: build/%/km/rp/.created build/%/rp/data.hd5 %-km.json km.py
	$(PYTHON) km.py build/$*/rp/data.hd5 $*-km.json $@

build/%/km/rp/elbow.png: build/%/data.hd5 build/%/km/rp/model.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py build/$*/rp/data.hd5 build/$*/km/rp/model.joblib $@

build/%/gmm/rp/model.joblib: build/%/gmm/rp/.created build/%/rp/data.hd5 %-gmm.json gmm.py
	$(PYTHON) gmm.py build/$*/rp/data.hd5 $*-gmm.json $@

build/%/gmm/rp/elbow.png: build/%/data.hd5 build/%/gmm/rp/model.joblib elbow-plot.py
	$(PYTHON) elbow-plot.py build/$*/rp/data.hd5 build/$*/gmm/rp/model.joblib $@

build/analysis.pdf: \
	build/.created \
	ml-pr3-analysis/analysis.tex \
	ml-pr3-analysis/Bibliography.bib \
	build/titanic/km/elbow.png \
	build/titanic/gmm/elbow.png \
	build/redwine/km/elbow.png \
	build/redwine/gmm/elbow.png \
	build/titanic/timing.png \
	build/titanic/iterations.png \
	build/redwine/timing.png \
	build/redwine/iterations.png \
	build/titanic/rf/chart.png \
	build/redwine/rf/chart.png \
	build/titanic/km/rf/elbow.png \
	build/redwine/km/rf/elbow.png \
	build/titanic/gmm/rf/elbow.png \
	build/redwine/gmm/rf/elbow.png \
	build/titanic/pca/chart.png \
	build/redwine/pca/chart.png \
	build/titanic/km/pca/elbow.png \
	build/redwine/km/pca/elbow.png \
	build/titanic/gmm/pca/elbow.png \
	build/redwine/gmm/pca/elbow.png \
	build/titanic/ica/chart.png \
	build/redwine/ica/chart.png \
	build/titanic/km/ica/elbow.png \
	build/titanic/gmm/ica/elbow.png \
	build/redwine/km/ica/elbow.png \
	build/redwine/gmm/ica/elbow.png \
	build/titanic/rp/chart.png \
	build/redwine/rp/chart.png \
	build/titanic/km/rp/elbow.png \
	build/titanic/gmm/rp/elbow.png \
	build/redwine/km/rp/elbow.png \
	build/redwine/gmm/rp/elbow.png \
	build/titanic/histogram.png \
	build/redwine/histogram.png
	$(PDFLATEX) -output-directory=build ml-pr3-analysis/analysis.tex
	cp ml-pr3-analysis/Bibliography.bib build
	cd build && $(BIBTEX) analysis
	$(PDFLATEX) -output-directory=build ml-pr3-analysis/analysis.tex
	$(PDFLATEX) -output-directory=build ml-pr3-analysis/analysis.tex
