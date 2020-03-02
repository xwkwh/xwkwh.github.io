.PHONY: all test template vendor pkg docker
run:
	hexo g
	hexo s
deploy:
	hexo g
	hexo d
