.PHONY: ci
ci:
	git pull
	npm install
	npm run lint
	npm run test-with-build

.PHONY: test
test:
	git pull
	npm install
	npm run lint
	npm test