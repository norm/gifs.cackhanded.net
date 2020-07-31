.PHONY: all clean cleanthumbs gifwrapped

all:
	@PATH="./bin:${PATH}" make -f Makefile.gifs
	@PATH="./bin:${PATH}" flourish generate -v

clean:
	@make -f Makefile.gifs clean

cleanthumbs:
	@make -f Makefile.gifs cleanthumbs

gifwrapped:
	@PATH="./bin:${PATH}" make -f Makefile.gifs gifwrapped
