OPENSCAD=/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD

all: build preview

BUILD_DIR=output

SRCS=atx_psu_case_bosl.scad atx_psu_case_dps3005.scad

OPTIONS=

PREVIEW_OPTIONS=

build: ${BUILD_DIR} $(SRCS:%.scad=${BUILD_DIR}/%.stl)
preview: ${BUILD_DIR} $(SRCS:%.scad=${BUILD_DIR}/%.png)

${BUILD_DIR}/%.stl: %.scad
	${OPENSCAD} -m make -o $@ ${OPTIONS} $<

${BUILD_DIR}/%.png: %.scad
	${OPENSCAD} -m make -o $@ ${OPTIONS} ${PREVIEW_OPTIONS} $<

output:
	mkdir output

.PHONY: clean all
clean:
	rm -rf output