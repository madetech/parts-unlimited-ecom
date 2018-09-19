.PHONY: down
down:
		docker-compose down

.PHONY: build
build:
		docker-compose build

.PHONY: serve
serve: down build
		docker-compose run --rm --service-ports web bundle exec rerun -- rackup -o 0.0.0.0

.PHONY: test
test: down build
		docker-compose run --rm web ./bin/run_tests.sh

.PHONY: test-ci
test-ci: down build
		docker-compose run --rm web ./bin/run_ci_tests.sh
