.PHONY: all baked_css clean clean-test dev_css fonts google-fonts local-fonts gifwrapped generate pull_history push_history rebuild push publish remove removethumbs test

all: gifs

404: clean
	@flourish generate -v /404

new404: 404
	@flourish upload --invalidate

clean:
	@rm -rf output

clean-test:
	@rm -rf temp

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

test: google-fonts
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

pull_history:
	@gh gist view 341abe028fa444a3015cf5736ee9f452 --raw -f post_history.txt > post_history.txt

push_history:
	@gh gist edit 341abe028fa444a3015cf5736ee9f452 -f post_history.txt post_history.txt

fonts:
	@make -s -f Makefile.fonts

google-fonts:
	@make -s -f Makefile.fonts google

local-fonts:
	@make -s -f Makefile.fonts local
