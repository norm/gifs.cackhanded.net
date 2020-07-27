.PHONY: all clean cleanthumbs

all:
	@PATH="./bin:${PATH}" make -f Makefile.gifs
	@PATH="./bin:${PATH}" flourish generate -v

clean:
	@make -f Makefile.gifs clean

cleanthumbs:
	@make -f Makefile.gifs cleanthumbs
