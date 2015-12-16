EXEC=bundle exec
RAKE=$(EXEC) rake

install: Gemfile
	bundle Install

migrate:
	$(RAKE) db:migrate

unit: FORCE
	$(RAKE) test

test: unit

server:
	$(EXEC) rails server

lint:
	rubocop > errors.rubocop

help:
	cat .make_help

FORCE:
