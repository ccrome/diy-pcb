all:
	docker build -t gerb2stl .

run:
	touch `pwd`/output.stl
#	docker run --rm -it -v`pwd`/examples/moduleDriver-F_Cu.gtl:/in.gerber:ro -v `pwd`/output.stl:/output.stl:rw  gerb2stl
#	docker run --rm -it -v `pwd`/examples:/examples gerb2stl
	docker run --rm -it -v `pwd`/gerber2stl.py:/app/gerber2stl.py -v`pwd`/app.py:/app/app.py -p8050:8050 gerb2stl

