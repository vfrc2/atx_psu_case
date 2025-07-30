OPENSCAD?=openscad

OUTDIR=build
SRCS=${wildcard *.scad}

OPTIONS=--render
BUILD_ARGS=-m make

all: $(SRCS:%.scad=%_all)

define build_variant_alias
.PHONY: $(1:%.scad=%)_${2}
$(1:%.scad=%)_${2}: ${OUTDIR}/$(1:%.scad=%)_${2}.stl
endef

define buid_src
$(1:%.scad=%)_variants=$(shell  jq -r '.parameterSets | keys[]' $(1:%.scad=%.json))

$(1:%.scad=%): ${OUTDIR}/$(1:%.scad=%).stl

$(1:%.scad=%)_all: $(1:%.scad=%) $$($(1:%.scad=%)_variants:%=$(1:%.scad=%)_%)

$$(foreach var,$$($(1:%.scad=%)_variants),$$(eval $$(call build_variant_alias,$(1),$$(var))))

$${OUTDIR}/$(1:%.scad=%).stl: $(1) $${OUTDIR}
	$${OPENSCAD} $${OPTIONS} $${BUILD_ARGS} \
	-o $$@ \
	-o $${@:.stl=.png} \
	$$<

$${OUTDIR}/$(1:%.scad=%)_%.stl: $(1) $${OUTDIR}
	$${OPENSCAD} $${OPTIONS} $${BUILD_ARGS} \
		-P $$* -p $${<:%.scad=%.json} \
		-o $$@ \
		-o $${@:.stl=.png} \
		$$<
endef

$(foreach src,$(SRCS),$(eval $(call buid_src,$(src))))

${OUTDIR}:
	mkdir ${OUTDIR}

clean:
	rm -rf ${OUTDIR}

.PHONY: all
.PHONY: clean 

