PATH  := node_modules/.bin:$(PATH)
SHELL := /bin/bash

node_modules: package.json
	echo "--> Installing dependencies ..."
	npm -q install

docs: node_modules
	branch=$$(git rev-parse --abbrev-ref HEAD);							\
	echo $${branch};																				\
	out=$$(mktemp -d);																			\
	gitbook build . "$${out}" --log error --format website;	\
	git stash;																							\
	git checkout -B gh-pages;																\
	rm -rf ./*;																							\
	mv $${out}/* ./;																				\
	git add -A .;																						\
	git commit -m "Automated documentation update";					\
	git checkout $${branch};																\
	git stash pop

.SILENT: docs node_modules