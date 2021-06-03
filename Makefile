.PHONY: all baked_css clean dev_css example-fonts gifwrapped generate rebuild push publish remove removethumbs test

all: gifs

404: clean
	@flourish generate -v /404

new404: 404
	@flourish upload --invalidate

clean:
	@rm -rf output

gifs:
	@PATH="./bin:${PATH}" make -f Makefile.gifs

remake:
	@find source -name '*.toml' | entr -d sh -c 'make; echo ""'

remove:
	@make -f Makefile.gifs clean

removethumbs:
	@make -f Makefile.gifs cleanthumbs

gifwrapped: gifs
	@PATH="./bin:${PATH}" make -f Makefile.gifs gifwrapped

generate:
	@flourish generate -v

baked_css:
	@./script/update_css

dev_css: 
	@./script/reset_css

upload:
	@flourish upload --invalidate

upload_css:
	@flourish upload --invalidate

rebuild: gifs clean baked_css upload_css generate upload dev_css

stash:
	@git stash --include-untracked

push:
	@git push origin main

publish: stash push rebuild gifwrapped unstash
	@flourish upload

test:
	@./script/test

unstash:
	@git stash pop

next: gifwrapped
	@clear
	@./script/next 60 high
	@echo ''
	@./script/next un

example-fonts:
	mkdir -p fonts
	curl -L -o fonts/assistant-semibold.ttf 'https://github.com/google/fonts/blob/master/ofl/assistant/Assistant-SemiBold.ttf?raw=true'
	curl -L -o fonts/assistant-extrabold.ttf 'https://github.com/google/fonts/blob/master/ofl/assistant/Assistant-ExtraBold.ttf?raw=true'
	curl -L -o fonts/lato-regular.ttf 'https://github.com/google/fonts/blob/master/ofl/lato/Lato-Regular.ttf?raw=true'
