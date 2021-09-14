.PHONY: all baked_css clean dev_css example-fonts gifwrapped generate rebuild push publish remove removethumbs test

all: gifs

404: clean
	@flourish generate -v /404

new404: 404
	@flourish upload --invalidate

clean:
	@rm -rf output

reset:
	@./script/reset_gifs

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
	@flourish upload --invalidate --max-invalidations 50

upload_css:
	@flourish upload

rebuild: gifs clean baked_css upload_css generate upload dev_css

stash:
	@git stash --include-untracked

push:
	@git push origin main

publish: stash push rebuild gifwrapped unstash
	@flourish upload

test:
	@./script/test

test_generated:
	@./script/test_generated_site

test_future:
	@flourish generate -v --include-future
	@./script/test_generated_site

unstash:
	@git stash pop

next: gifwrapped
	@clear
	@./script/next 60 high
	@echo ''
	@./script/next

example-fonts:
	mkdir -p fonts
	curl -L -o fonts/assistant-semibold.ttf https://raw.githubusercontent.com/google/fonts/main/ofl/assistant/static/Assistant-SemiBold.ttf
	curl -L -o fonts/assistant-bold.ttf https://raw.githubusercontent.com/google/fonts/main/ofl/assistant/static/Assistant-Bold.ttf
	curl -L -o fonts/assistant-extrabold.ttf https://raw.githubusercontent.com/google/fonts/main/ofl/assistant/static/Assistant-ExtraBold.ttf
	curl -L -o fonts/lato-regular.ttf https://raw.githubusercontent.com/google/fonts/main/ofl/lato/Lato-Regular.ttf
