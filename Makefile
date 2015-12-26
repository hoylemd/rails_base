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
	cat errors.rubocop

deploy:
	heroku maintenance:on
	git co master
	git push heroku master
	heroku run rake db:migrate
	heroku maintenance:off

start:
	dev_scripts/start_branch

merge:
	dev_scripts/merge_me

todo:
	ack '/TODO/i' ./*

finish: merge deploy

help:
	cat .make_help

FORCE:
