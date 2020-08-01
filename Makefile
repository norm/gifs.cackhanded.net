.PHONY: all clean cleanthumbs gifwrapped publish

all:
	@PATH="./bin:${PATH}" make -f Makefile.gifs

clean:
	@make -f Makefile.gifs clean

cleanthumbs:
	@make -f Makefile.gifs cleanthumbs

gifwrapped:
	@PATH="./bin:${PATH}" make -f Makefile.gifs gifwrapped

generate:
	@flourish generate -v

publish: generate gifwrapped
	@flourish upload
