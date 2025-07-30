include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = $preview ? 8 : 32;

psu_width = 86;
psu_height = 150;
psu_wall_thickness = 2.5;
psu_rounding = 2;

psu_depth = 40 + 15;
// psu_depth = 1000;

// DPS3005 cutout size
cutout_width = 75.8;
cutout_height = 39;

module psu_cover(depth = 40, inner_lip = 15, bolt_min_depth = 0.6, front_cut=false, vent = 0, vent_size=0, anchor = CENTER, spin = 0, orient = TOP) {
  wt = psu_wall_thickness;
  attachable(
    anchor, spin, orient, size=[
      psu_width,
      depth,
      psu_height,
    ]
  ) {
    tag_scope()
      diff() {
        cuboid(
          [
            psu_width + wt * 2,
            depth,
            psu_height + wt * 2,
          ], rounding=psu_rounding
        ) {
          tag("remove")
            align(BACK, overlap=front_cut ? depth + psu_wall_thickness: depth - psu_wall_thickness)
              cuboid(
                [psu_width - wt * 2, depth, psu_height - wt * 2]
              );
          tag("remove")
            align(BACK, overlap=inner_lip)
              cuboid(
                [psu_width, depth, psu_height]
              );

          tag("remove") {
            vent_size = vent_size > 0 ? vent_size: min(depth/2,psu_height/5);
            echo(vent_size);
            distance = (psu_height - psu_wall_thickness * 6) / vent;
            for (i = [0:1:vent - 1])
              translate([0, 0, -psu_height / 2 + distance / 2 + psu_wall_thickness * 3 + distance * i])
                rotate([45])
                  cube([psu_width * 2, vent_size, 3], center=true);
          }

          align(BACK, overlap=inner_lip / 2)
            attach([LEFT, RIGHT], BOTTOM, align=[TOP, BOTTOM], inset=psu_height / 10, overlap=wt - bolt_min_depth)
              screw_hole(
                spec="M3",
                head="socket", length=10, teardrop=true, atype="head", anchor="head_bot",
                orient=LEFT,
                counterbore=psu_wall_thickness * 2
              );
        }
      }
    ;
    children();
  }
}

diff() {
  psu_cover(psu_depth, vent=4) {
    position(FRONT+TOP) down((psu_width - cutout_width) / 2)
        tag("remove") cuboid([cutout_width, psu_wall_thickness * 3, cutout_height], anchor=TOP);
    position(FRONT) cyl(50);
  }
}

back(150) mirror([0,1,0]) psu_cover(20, front_cut=true);
