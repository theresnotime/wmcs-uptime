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

.PHONY: ci-no-git
ci-no-git:
	npm install
	npm run lint
	npm run test-with-build

.PHONY: start-pm2
start-pm2:
	git fetch --prune
	git pull
	export NODE_ENV=production
	npm install --verbose
	npm run build
	pm2 start server/server.js --name wmcs-uptime --update-env --deep-monitoring --log ~/wmcs-uptime.log

.PHONY: deploy-pm2
deploy-pm2:
	git fetch --prune
	git pull
	export NODE_ENV=production
	npm install --verbose
	npm run build
	pm2 restart wmcs-uptime --update-env