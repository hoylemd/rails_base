EXEC=bundle exec
RAKE=$(EXEC) rake

install: Gemfile
	bundle Install
	$(RAKE) db:migrate

test: FORCE
	$(RAKE) test

server:
	$(EXEC) rails server

help:
	cat .make_help

FORCE:
