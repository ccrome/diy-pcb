all:
	docker build -t gerb2stl .

run:
	docker run --rm -it gerb2stl
