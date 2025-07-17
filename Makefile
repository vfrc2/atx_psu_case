OPENSCAD=/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD

all: build preview

FILE_NAME=atx_psu_case_dps3005

OPTIONS=

build: output
	${OPENSCAD} -m make -o output/${FILE_NAME}.stl ${OPTIONS} ${FILE_NAME}.scad

preview: output
	${OPENSCAD} -m make -o output/${FILE_NAME}.png ${OPTIONS} ${FILE_NAME}.scad

output:
	mkdir output

clean:
	rm -rf build