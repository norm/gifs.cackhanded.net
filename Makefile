.PHONY: all clean cleanthumbs gifwrapped generate rebuild push publish test

all: gifs

gifs:
	@PATH="./bin:${PATH}" make -f Makefile.gifs

clean:
	@make -f Makefile.gifs clean

cleanthumbs:
	@make -f Makefile.gifs cleanthumbs

gifwrapped:
	@PATH="./bin:${PATH}" make -f Makefile.gifs gifwrapped

generate: gifs
	@flourish generate -v

rebuild: gifs stash
	@./script/rebuild
	@git stash pop

stash:
	git stash --include-untracked

push:
	@git push origin main

publish: push rebuild gifwrapped
	@flourish upload

test:
	@./script/test
