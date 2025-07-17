// === Parameters ===
psu_width = 86;
psu_height = 150;
psu_front_depth = 58;
psu_front_cutout = 10;
psu_back_depth = 30;
psu_back_padding = 5;

psu_wall_thickness = 3;

psu_bolt = 3;
psu_bolt_counter = 5.5;
psu_bolt_depth = 2;
psu_bolt_padding = 10;

tolerance = 0.2;

// DPS3005 cutout size
cutout_width = 75.8;
cutout_height = 39;

// Banana post
post_d = 6;
post_padding = psu_height / 5;
post_count = 2;

// DC/DC
dcdc_bold_d = 4+tolerance;
dcdc_stage = 9;
dcdc_stage_height = 5;
dcdc_width = 55.5 + 3;
dcdc_height = 23.5 + 3;

chamfer_r = 1;

$fn = $preview ? 8 : 32;

module psu_bolt(depth = 10) {
  union() {
    cylinder(depth * 2, d=psu_bolt + tolerance);
    translate([0, 0, psu_bolt_depth]) rotate([180]) cylinder(depth * 2, d=psu_bolt_counter + tolerance);
  }
}

module psu_double_bolt() {
  translate([-psu_width / 2 - psu_wall_thickness, 0, 0]) rotate([0, 90, 0]) psu_bolt();
  translate([psu_width / 2 + psu_wall_thickness, 0, 0]) rotate([0, 90, 180]) psu_bolt();
}

module psu_cutout(depth = 10) {
  shH = psu_height / 2 - psu_height / 12;
  lhH = psu_height / 2 - psu_height / 24;
  rotate([0, -90])
    linear_extrude(height=psu_width * 2, center=true)
      polygon(points=[[-shH, 0], [shH, 0], [lhH, depth], [-lhH, depth]]);
}

module psu_panel(depth, cutout = 0) {
  w2 = 2 * psu_wall_thickness;
  t2 = 2 * tolerance;
  h_2 = psu_height / 2;
  difference() {
    cutout_padding = (depth + cutout + psu_wall_thickness) / 2 - cutout;
    minkowski() {
      difference() {
        cube(
          [
            psu_width - chamfer_r * 2 + w2,
            depth + cutout + psu_wall_thickness - chamfer_r*2,
            psu_height - chamfer_r * 2 + w2,
          ], center=true
        );
        if (cutout > 0) {
          translate([0, cutout_padding, 0]) psu_cutout(cutout + 3);
        }
      }
      sphere(r=chamfer_r);
    }
    translate([0, depth/2-cutout/2, 0]) {
      cube(
        [
          psu_width + t2,
          cutout_padding,
          psu_height + t2,
        ], center=true
      );
    }
    translate([0, psu_wall_thickness, 0]) {
      cube(
        [
          psu_width - w2,
          depth + cutout + psu_wall_thickness + 1,
          psu_height - w2,
        ], center=true
      );
    }

    translate([0, depth/2 - cutout/2, psu_height / 2 - psu_bolt_counter]) psu_double_bolt();
    translate([0, depth/2 - cutout/2, -psu_height / 2 + psu_bolt_counter]) psu_double_bolt();
  }
}

module dcdc_post() {
  difference() {
    cylinder(dcdc_stage_height, d=dcdc_stage);
    cylinder(dcdc_stage_height + 3, d=dcdc_bold_d);
  }
}

// Front panel
difference() {
  union() {
    psu_panel(psu_front_depth, psu_front_cutout);

    // Standoffs
    translate([-dcdc_width / 2, -psu_front_depth / 2, -dcdc_height / 2])
      rotate([90, 0, 180]) dcdc_post();
    translate([-dcdc_width / 2, -psu_front_depth / 2, dcdc_height / 2])
      rotate([90, 0, 180]) dcdc_post();
    translate([+dcdc_width / 2, -psu_front_depth / 2, -dcdc_height / 2])
      rotate([90, 0, 180]) dcdc_post();
    translate([+dcdc_width / 2, -psu_front_depth / 2, dcdc_height / 2])
      rotate([90, 0, 180]) dcdc_post();
  }

  // Ventilation cutout
  cutouts = 10;
  distance = (psu_height - psu_wall_thickness * 6) / cutouts;
  for (i = [0:1:cutouts - 1])
    translate([0, 0, -psu_height / 2 + distance / 2 + psu_wall_thickness * 3 + distance * i]) rotate([45]) cube([psu_width * 2, psu_width / 4, 3], center=true);

  // DPS3005 cut out
  translate(
    [
      0,
      -psu_front_depth / 2, //psu_height - cutout_height - (psu_width - cutout_width) + psu_wall_thickness - tolerance,
      psu_height / 2 - cutout_height / 2 - psu_wall_thickness,
    ]
  )
    rotate([90])
      cube([cutout_width + tolerance, cutout_height + tolerance, psu_wall_thickness * 10], center=true);

  // Banana posts
  post_distance = psu_width / post_count;
  for (i = [0:1:post_count - 1])
    translate([-psu_width/2,0,0]) 
    translate(
      [
       post_distance/2+post_distance * i,
        0,
        -psu_height / 2 + post_padding,
      ]
    )
      rotate([90])
        cylinder(psu_wall_thickness * 10, d=post_d + tolerance);
}

// Back Panel
translate([0, 150, 0])
  rotate([0, 0, 180])
    difference() {
      psu_panel(psu_back_depth / 2, 0);
      cube([psu_width - psu_back_padding, psu_back_depth * 2, psu_height - psu_back_padding], center=true);
    }



//// Utols
translate(
  [
    0,
    -psu_front_depth / 2 - psu_front_cutout / 2 - psu_wall_thickness / 2,
    0,
  ]
)
  cube([100, 45, 10])

    *difference() {
      cube([120, 60, psu_wall_thickness]);
      translate([120 / 2 - cutout_width / 2, 60 / 2 - cutout_height / 2, -1])
        cube([cutout_width + tolerance, cutout_height + tolerance, psu_wall_thickness * 2]);
    }
