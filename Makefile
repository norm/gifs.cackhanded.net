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
	@find output -name new -exec rm {} \;

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

test: fonts videos
	@./script/test

test_generated:
	@./script/test_generated_site

test_future:
	@flourish generate -v --include-future
	@find output -name new -exec rm {} \;
	@./script/test_generated_site

unstash:
	@git stash pop

next:
	@clear
	@./script/next 33 am high
	@echo ''
	@./script/next 33 pm high
	@echo ''
	@./script/next filling

fonts:
	mkdir -p fonts
	curl -L -o fonts/assistant-semibold.ttf https://raw.githubusercontent.com/google/fonts/89c9db01508963eb8b48a171c8baf2ef750c5bd9/ofl/assistant/static/Assistant-SemiBold.ttf
	curl -L -o fonts/assistant-bold.ttf https://raw.githubusercontent.com/google/fonts/89c9db01508963eb8b48a171c8baf2ef750c5bd9/ofl/assistant/static/Assistant-Bold.ttf
	curl -L -o fonts/assistant-extrabold.ttf https://raw.githubusercontent.com/google/fonts/89c9db01508963eb8b48a171c8baf2ef750c5bd9/ofl/assistant/static/Assistant-ExtraBold.ttf
	curl -L -o fonts/lato-regular.ttf https://raw.githubusercontent.com/google/fonts/main/ofl/lato/Lato-Regular.ttf

videos:
	mkdir videos
	youtube-dl -o "videos/HU2ftCitvyQ.mp4" -f "bestvideo[ext=mp4]" HU2ftCitvyQ
