.PHONY: ci
ci:
	git fetch --prune
	git pull
	npm install
	npm run lint
	npm run test-with-build

.PHONY: test
test:
	git fetch --prune
	git pull
	npm install
	npm run lint
	npm test

.PHONY: dev
dev:
	git fetch --prune
	git pull
	npm install
	npm run build
	node server/server.js