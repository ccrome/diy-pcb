all:
	docker build -t gerb2stl .

run:
	docker run --rm -it -v `pwd`/examples:/examples gerb2stl
