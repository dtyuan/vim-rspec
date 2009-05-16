VERSION = `git tag | sort -r| head -n1`

zip:
	git archive --format=zip HEAD plugin/* syntax/* > vim-rspec-$(VERSION).zip
install:
	cp -v plugin/* $(VIMRUNTIME)/plugin/
	cp -v syntax/* $(VIMRUNTIME)/syntax/
