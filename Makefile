EXEC=bundle exec
RAKE=$(EXEC) rake

install: Gemfile
	bundle Install
	$(RAKE) db:migrate

test: FORCE
	$(RAKE) test

integration-tests: FORCE

smoke: FORCE

test-all: FORCE

server:
	$(EXEC) rails server

help:
	cat .make_help

FORCE:
