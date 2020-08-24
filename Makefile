.PHONY: all clean cleanthumbs example-fonts gifwrapped generate rebuild push publish test

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

example-fonts:
	mkdir -p fonts
	curl -L -o fonts/assistant-semibold.ttf 'https://github.com/google/fonts/blob/master/ofl/assistant/Assistant-SemiBold.ttf?raw=true'
	curl -L -o fonts/assistant-extrabold.ttf 'https://github.com/google/fonts/blob/master/ofl/assistant/Assistant-ExtraBold.ttf?raw=true'
	curl -L -o fonts/lato-regular.ttf 'https://github.com/google/fonts/blob/master/ofl/lato/Lato-Regular.ttf?raw=true'
