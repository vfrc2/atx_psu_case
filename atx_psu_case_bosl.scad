include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = $preview ? 8 : 32;

psu_width = 86;
psu_height = 150;
psu_wall_thickness = 2.5;
psu_rounding = 2;

psu_depth = 40+15;

module psu_cover(depth = 40, inner_lip = 15, bolts_inset = 0.4) {
  psu_cutout_width=psu_width - 2 * psu_wall_thickness;
  psu_cutout_height=psu_height - 2 * psu_wall_thickness;

  module bolts_pair() {
    mirror_copy([1, 0, 0])
      translate([psu_cutout_width / 2 + bolts_inset, depth - inner_lip / 2 +1.5, 0])
        rotate([90, 0, 90])
          screw_hole(spec="M3", head="socket", length=10, teardrop=true, atype="head", anchor="head_bot");
  }

  union() {
    // Body
    difference() {
      // Outter shell
      cuboid(
        [
          psu_width,
          depth,
          psu_height,
        ], anchor=FRONT, rounding=psu_rounding
      );
      // cutout
      back(psu_wall_thickness)
        cuboid(
          [
            psu_cutout_width,
            depth * 2,
            psu_cutout_height,
          ], anchor=FRONT
        );
      // bolts
      translate([0, 0, psu_height / 3]) bolts_pair();
      translate([0, 0, -psu_height / 3]) bolts_pair();
    }

    // Lip
    back(psu_wall_thickness)
      difference() {
        cuboid(
          [
            psu_cutout_width+.2,
            depth - inner_lip,
            psu_cutout_height+0.2,
          ], anchor=FRONT
        );
        back(-1)
          cuboid(
            [
              psu_cutout_width - psu_wall_thickness * 2,
              depth,
              psu_cutout_height - psu_wall_thickness * 2,
            ], anchor=FRONT
          );
      }
  }
}

psu_cover(psu_depth);
