OPENSCAD=/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD

OUTDIR=build
SRCS=atx_psu_case_dps3005.scad

OPTIONS=--render
BUILD_ARGS=-m make

all: atx_psu_case_dps3005_all

atx_psu_case_dps3005_variants=$(shell  jq '.parameterSets | keys[]' atx_psu_case_dps3005.json)

atx_psu_case_dps3005_all: atx_psu_case_dps3005 atx_psu_case_dps3005_3posts atx_psu_case_dps3005_4posts
atx_psu_case_dps3005: ${OUTDIR}/atx_psu_case_dps3005.stl
atx_psu_case_dps3005_3posts: ${OUTDIR}/atx_psu_case_dps3005_3posts.stl
atx_psu_case_dps3005_4posts: ${OUTDIR}/atx_psu_case_dps3005_4posts.stl

${OUTDIR}/atx_psu_case_dps3005.stl: atx_psu_case_dps3005.scad ${OUTDIR}
	${OPENSCAD} ${OPTIONS} ${BUILD_ARGS} -o $@ -o ${@:.stl=.png} $<

${OUTDIR}/atx_psu_case_dps3005_%.stl: atx_psu_case_dps3005.scad ${OUTDIR}
	${OPENSCAD} ${OPTIONS} ${BUILD_ARGS} \
		-P ${@:${OUTDIR}/atx_psu_case_dps3005_%=%} -p ${<:%.scad=%.json} \
		-o $@.stl -o $@.png $<

${OUTDIR}:
	mkdir ${OUTDIR}

clean:
	rm -rf ${OUTDIR}

.PHONY: all
.PHONY: clean 

