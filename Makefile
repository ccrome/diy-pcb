all:
	docker build -t gerb2stl .

run:
	touch `pwd`/output.stl
	docker run --rm -it -v`pwd`/examples/moduleDriver-F_Cu.gtl:/in.gerber:ro -v `pwd`/output.stl:/output.stl:rw  gerb2stl
#	docker run --rm -it -v `pwd`/examples:/examples gerb2stl
