$fn=75;
// font_name = "Cascadia Mono:style=Italic";
font_name = "Courier New";
eps = 0.1;

// I have one too many letters...
wheel_chars = "aeotipugby.jwzvqx;_:='\"?!¼½¶§º²³[](#)&Q@±+¢%#$*78645021X3K9W/,Y.M(OJAIEDTCNSLR)PHZBFUH-V,kflhdscmrn";
angle_step = 360 / len(wheel_chars);

hub_dia = 45;



union() {
  hub();

  // Tines
  for(i = [0:len(wheel_chars)]) {
    rotate([0, 0, angle_step * i]) {
      translate([0, hub_dia/2, 0]) {
        tine(wheel_chars[i], i == 0);
      }
    }
  }
}


module hub(hole_code = [true, true, false, false]) {
  hub_thickness = 1.5; // mm
  center_hole_dia = 6; // mm

  locating_hole_angle  = 220;
  locating_hole_offset = 50; //mm

  locating_hole_dia = 7; // mm;

  hole_code_angle   = 160;
  hole_code_offset  = 50; // mm


  // Hole codes are 45º apart.

  difference() {
    // The bump on the diameter is to make sure it connects to the spokes.
    cylinder(hub_thickness, d=hub_dia + 0.1, center = true);

    // Center hole
    cylinder(hub_thickness + eps, d=center_hole_dia, center = true);

    // Locating hole
    rotate([0, 0, locating_hole_angle]) {
      translate([0, locating_hole_offset, 0]) {
        cylinder(hub_thickness + eps, d=locating_hole_dia, center = true);
      }
    }

    // Hole Code
    for(i = [0:3]) {
      if(hole_code[i]) {
        rotate([0, 0, hole_code_angle - i * 20]) {
          translate([0, locating_hole_offset, 0]) {
            cylinder(hub_thickness + eps, d=locating_hole_dia, center = true);
          }
        }
      }
    }
  }

}


module tine(char, is_home = false) {
  type_thickness = 1.0; // mm

  home_indicator_height = 2.5; // mm
  tine_thickness = 0.5; // mm
  tine_length    = 25; // mm
  flat_length    = 6;  // mm
  flat_width     = 2.78;  // mm
  start_width    = 1.3;   // mm
  end_width      = 1.3;   // mm


  linear_extrude(tine_thickness) {
    // stem
    polygon([
      [-start_width/2, 0],
      [start_width/2, 0],
      [end_width/2, tine_length],
      [-end_width/2, tine_length]
    ]);

    // flat
    translate([0, tine_length + flat_length / 2]) {
      square([flat_width, flat_length], true);

      if(is_home) {
        translate([0, flat_length/2]) {
          polygon([
            [-flat_width/2, 0],
            [flat_width/2, 0],
            [0, home_indicator_height]
          ]);
        }
      }
    }
  }

  // letter
  translate([0, tine_length + flat_length/3, tine_thickness]) {
    color("gray") {
      linear_extrude(type_thickness) {
        mirror([1, 0, 0]) {
          text(char,
            font = font_name,
            size = 3,
            halign = "center",
            valign = "baseline");
        }
      }
    }
  }
}