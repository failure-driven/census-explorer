usage:
	bin/makefile/usage

fresh: clean dev_env build start
	echo "TODO fresh"

clean:
	echo "TODO clean out any build and data artefacts"

build:
	bin/makefile/full-build

start: check_tools
	rackup

deploy:
	echo "TODO deploy to production"

# Development

check_tools:
	bin/makefile/check-tools

dev_env: check_tools
	bin/makefile/dev-env

prettier:
	bin/makefile/prettier

