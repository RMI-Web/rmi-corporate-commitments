install:
	npm ci
	cd functions && npm ci

data:
	mkdir -p public
	mkdir -p functions/data
	node ./functions/split-data.js
	node ./functions/utils/overall-chart.js

build:
	mkdir -p public
	npm run static
	npm run build

overall:
	node ./functions/utils/overall-chart.js

clean:
	# Removes all generated stuff
	rm -rf public
	rm -rf functions/data
	rm -rf src/icons/chart-overall.svg
	rm -rf src/config/companies.json
	rm -rf src/config/sectorLookup.json
	rm -rf src/config/sectors.json
	rm -rf src/config/sectorsMicrocopy.json

test:
	npm run test