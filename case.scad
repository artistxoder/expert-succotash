// ============================================================================
// RED ARDUINO GAS DETECTION + CLIMATE MONITORING CASE - K7 MINI OPTIMIZED
// ============================================================================
// For: Arduino Uno + MQ-2 Gas Sensor + DHT11 Temp/Humidity + Buzzer + LED + OLED + Button
// Features: Gas detection alarm system with climate monitoring
// 100% SCREW-FREE DESIGN - Snap-fits and friction mounts only!
// Optimized for K7 Mini 3D Printer - Red PLA Filament
// ============================================================================

// Print quality optimization
$fn = 60; // Smooth curves for K7 Mini

// Global manufacturing tolerance for friction fits and clearances
tolerance = 0.2; // mm

// Small epsilon value to ensure clean cuts and avoid co-planar faces
// This is critical for manifold geometry for clean STL exports.
epsilon = 0.001; // mm

// --- RENDER CONTROL: Set ONLY ONE to 'true' at a time for printing ---
// To print the main case: Set RENDER_MAIN_CASE = true; RENDER_LID = false;
// To print the lid: Set RENDER_MAIN_CASE = false; RENDER_LID = true;
RENDER_MAIN_CASE = true;  // Set to true to render the main case
RENDER_LID       = false; // Set to true to render the lid

// ============================================================================
// COMPONENT SPECIFICATIONS
// ============================================================================

// Arduino Uno dimensions
arduino_width = 68.6; 	// mm
arduino_depth = 53.4; 	// mm
arduino_height = 1.6; 	// mm

// 0.96" OLED Display (128x64 pixels)
oled_width = 27.0; 		// mm
oled_height = 27.0; 		// mm 
oled_thickness = 4.0; 	// mm including PCB
oled_screen_width = 21.7; // mm (actual display area)
oled_screen_height = 11.2; // mm

// MQ-2 Gas Sensor (main detection component)
mq2_diameter = 20.0; 	// mm (sensor housing)
mq2_height = 16.0; 		// mm
mq2_pcb_width = 32.0; 	// mm (PCB dimensions)
mq2_pcb_depth = 20.0; 	// mm

// DHT11 Temperature/Humidity Sensor 
dht11_width = 16.0; 	// mm
dht11_depth = 12.0; 	// mm
dht11_height = 5.5; 	// mm

// Active Buzzer (alarm component)
buzzer_diameter = 12.0; // mm (typical active buzzer)
buzzer_height = 9.0; 	// mm

// LED + Resistor (visual alarm)
led_diameter = 5.0; 	// mm (standard LED)
led_height = 8.0; 		// mm
resistor_length = 6.0; 	// mm (220Ω resistor)

// Mini breadboard (for connections)
breadboard_width = 55; 	// mm
breadboard_depth = 35; 	// mm
breadboard_height = 8.5; // mm

// Button dimensions (for a common 6x6mm tact switch)
button_hole_diameter = 6.5; // Diameter of the round hole in the case top for the button plunger
button_pcb_width = 6.0;   // Width of the button's PCB
button_pcb_depth = 6.0;   // Depth of the button's PCB
button_pcb_thickness = 1.5;  // Thickness of the button's PCB
button_housing_clearance = 5.0; // Clearance needed below PCB for button housing/pins

// Case dimensions (K7 Mini bed optimized)
case_width = 98; 		// mm (Reduced from 130mm to fit 100mm bed with margin)
case_depth = 100; 		// mm (Fits 100mm bed)
case_height = 50; 		// mm (Fits 100mm bed)
wall_thickness = 2.5; 	// mm (perfect for 0.4mm nozzle)
corner_radius = 4; 		// mm

// ============================================================================
// COMPONENT POSITIONS
// ============================================================================

// Arduino mounting holes (standard Uno pattern)
arduino_hole_offsets = [
	[2.54, 15.24], 	// mm from board's bottom-left corner
	[15.24, 50.8],
	[66.04, 35.56],
	[66.04, 7.62]
];

// Arduino base offset within the case
arduino_base_offset_x = (case_width - arduino_width) / 2; // Centered
arduino_base_offset_y = 45; 	// mm from case edge (room for breadboard)

// OLED position (for front panel of main case)
oled_pos_x = (case_width / 2) - (oled_width / 2); // Centered horizontally on the front face
oled_pos_y = -wall_thickness;                   // On front face (Y-axis), to cut through the wall
oled_pos_z = case_height/2;                     // Centered vertically on case height

// Breadboard area (front of Arduino for connections)
breadboard_pos_x = arduino_base_offset_x; // Retained relative positioning
breadboard_pos_y = 8; 	// mm from case front edge (Y-axis)

// MQ-2 Gas Sensor (Pin A0) - CRITICAL: Needs maximum air exposure
mq2_pos_x = breadboard_pos_x + 25; // Relative to breadboard, fine for new width
mq2_pos_y = breadboard_pos_y + 15;
mq2_pos_z = case_height - wall_thickness; // Top mount for best gas detection

// DHT11 Sensor (Pin 3) - Side mount for ambient air readings
dht11_pos_x = case_width - wall_thickness; // Right side wall (auto-adjusts with case_width)
dht11_pos_y = case_depth/2; // Centered vertically on side
dht11_pos_z = case_height/2; // Centered horizontally on side

// Buzzer (Pin 8) - Top front for maximum sound output
buzzer_pos_x = case_width/4; // Adjusted to new case_width
buzzer_pos_y = 15;
buzzer_pos_z = case_height - wall_thickness; // On top face

// LED (Pin 9) - Front panel for visibility
led_pos_x = 15; // From left edge (X-axis), keeping 15mm offset
led_pos_y = -wall_thickness; // On front face (Y-axis)
led_pos_z = case_height/2; // Centered vertically

// Button position - on top, towards the front, centered
button_pos_x = case_width / 2;
button_pos_y = wall_thickness + 12; // A bit from the front edge
button_pos_z_top_surface = case_height - wall_thickness; // Z-coordinate of the top surface of the case

// ============================================================================
// REUSABLE GEOMETRIC PRIMITIVES
// ============================================================================

// Module to create a rounded box with consistent corners
module rounded_box(w, d, h, r) {
	hull() {
		translate([r, r, 0]) cylinder(r=r, h=h);
		translate([w-r, r, 0]) cylinder(r=r, h=h);
		translate([r, d-r, 0]) cylinder(r=r, h=h);
		translate([w-r, d-r, 0]) cylinder(r=r, h=h);
	}
}

// Protective mesh pattern (reusable module)
module protective_mesh(spacing, hole_d, radius_limit) {
	for(i = [-3:3]) {
		for(j = [-3:3]) {
			if(sqrt(i*i + j*j) <= radius_limit) {
				translate([i*spacing, j*spacing, 0])
					cylinder(d=hole_d, h=wall_thickness + 2 + epsilon, center=true); // Ensure deep cut
			}
		}
	}
}

// ============================================================================
// MAIN CASE BODY STRUCTURE
// ============================================================================

module main_case_structure() {
	difference() {
		// Outer shell with rounded corners
		rounded_box(case_width, case_depth, case_height, corner_radius);
		
		// Inner cavity, offset by wall thickness
		translate([wall_thickness, wall_thickness, wall_thickness])
			rounded_box(case_width - 2*wall_thickness, case_depth - 2*wall_thickness, case_height, corner_radius);
	}
}

// ============================================================================
// SNAP-FIT ARDUINO MOUNT (NO SCREWS!)
// ============================================================================

// Reusable snap-fit post module
module snap_fit_post(d_post, d_hole, h_post, d_clip, h_clip) {
	difference() {
		cylinder(d=d_post, h=h_post);
		// Center hole for Arduino mounting hole - ensure deep cut
		cylinder(d=d_hole + tolerance, h=h_post + 1 + epsilon); 
	}
	// Snap-fit top with flexible tabs
	translate([0, 0, h_post]) {
		difference() {
			cylinder(d=d_clip, h=h_clip);
			// Cross slots for flexibility - ensure deep cut
			translate([-d_clip/2 + 0.5, -0.3, -0.5 - epsilon])
				cube([d_clip - 1, 0.6, h_clip + 1 + 2*epsilon]);
			translate([-0.3, -d_clip/2 + 0.5, -0.5 - epsilon])
				cube([0.6, d_clip - 1, h_clip + 1 + 2*epsilon]);
		}
	}
}

module arduino_mounting() {
	mount_height = 8; 	// mm standoff height
	
	// Snap-fit Arduino mounting posts
	for(hole = arduino_hole_offsets) {
		translate([arduino_base_offset_x + hole[0], arduino_base_offset_y + hole[1], wall_thickness]) {
			snap_fit_post(
				d_post=6, 
				d_hole=2.8, 
				h_post=mount_height, 
				d_clip=5, 
				h_clip=2
			);
		}
	}
	
	// Arduino support ledges
	translate([arduino_base_offset_x - 2, arduino_base_offset_y - 2, wall_thickness + mount_height - 1.5])
		cube([arduino_width + 4, 2, 2]);
	
	translate([arduino_base_offset_x - 2, arduino_base_offset_y + arduino_depth, wall_thickness + mount_height - 1.5])
		cube([arduino_width + 4, 2, 2]);
	
	// Wire routing channel under Arduino
	translate([arduino_base_offset_x - 3, arduino_base_offset_y - 3, wall_thickness])
		cube([arduino_width + 6, 2, 3]);
}

// ============================================================================
// FRICTION-FIT BREADBOARD MOUNT
// ============================================================================

module breadboard_mount() {
	// Friction-fit platform
	translate([breadboard_pos_x - 2, breadboard_pos_y - 2, wall_thickness]) {
		// Base platform
		cube([breadboard_width + 4, breadboard_depth + 4, 2]);
		
		// Friction-fit side rails
		translate([1, 1, 2])
			cube([2 + tolerance, breadboard_depth + 2, 4]);
		translate([breadboard_width + 1 - tolerance, 1, 2])
			cube([2 + tolerance, breadboard_depth + 2, 4]);
		
		// End stops prevent sliding
		translate([3, 1 + tolerance, 2])
			cube([breadboard_width - 2, 2 + tolerance, 4]);
		translate([3, breadboard_depth + 1 - tolerance, 2])
			cube([breadboard_width - 2, 2 + tolerance, 4]);
	}
	
	// Wire management posts
	wire_post_positions = [
		[breadboard_pos_x - 5, breadboard_pos_y - 5],
		[breadboard_pos_x + breadboard_width + 5, breadboard_pos_y - 5],
		[breadboard_pos_x - 5, breadboard_pos_y + breadboard_depth + 5],
		[breadboard_pos_x + breadboard_width + 5, breadboard_pos_y + breadboard_depth + 5]
	];
	
	for(pos = wire_post_positions) {
		translate([pos[0], pos[1], wall_thickness]) {
			difference() {
				cylinder(d=6, h=15);
				// Wire routing slots - ensure deep cut
				translate([-1, -3, 8 - epsilon])
					cube([2, 6, 8 + 2*epsilon]);
				translate([-3, -1, 8 - epsilon])
					cube([6, 2, 8 + 2*epsilon]);
				// Flexible top
				translate([0, 0, 12])
					cylinder(d1=6, d2=4, h=3);
			}
		}
	}
	
	// Wire channels
	translate([breadboard_pos_x + breadboard_width + 2, breadboard_pos_y, wall_thickness])
		cube([6, breadboard_depth, 3]);
	
	translate([breadboard_pos_x, breadboard_pos_y + breadboard_depth + 2, wall_thickness])
		cube([breadboard_width, 6, 3]);
}

// ============================================================================
// MQ-2 GAS SENSOR MOUNT (Pin A0 - CRITICAL FOR GAS DETECTION)
// ============================================================================

module mq2_sensor_mount() {
	// Top ventilation grille for MQ-2
	translate([mq2_pos_x, mq2_pos_y, mq2_pos_z]) {
		// Main sensor access hole with tolerance - ensure deep cut
		cylinder(d=mq2_diameter + 4 + tolerance, h=wall_thickness + 2 + epsilon, center=true);
		
		// Apply mesh pattern
		// Cut mesh patterns cleanly
		translate([0, 0, -wall_thickness/2]) { // Position cutters relative to surface
            protective_mesh(spacing=2.5, hole_d=1.2, radius_limit=3.2);
        }
	}
	
	// Enhanced airflow slots around MQ-2 - ensure deep cut
	num_slots = 8;
	slot_angle = 360 / num_slots;
	slot_length = 12;
	slot_width = 4;
	slot_offset = mq2_diameter/2 + 5;
	
	for(i = [0:num_slots-1]) {
		rotate([0, 0, i * slot_angle])
			translate([mq2_pos_x + slot_offset, mq2_pos_y - slot_width/2, mq2_pos_z - wall_thickness - 1 - epsilon]) // Start slightly before wall
				cube([slot_length, slot_width, wall_thickness + 2 + 2*epsilon]); // Cut through wall
	}
	
	// Warning label area
	translate([mq2_pos_x - 15, mq2_pos_y - 8, case_height - wall_thickness + 0.5])
		linear_extrude(0.5)
			text("GAS", size=4, halign="center", valign="center");
}

// ============================================================================
// DHT11 CLIMATE SENSOR MOUNT (Pin 3 - AMBIENT CONDITIONS)
// ============================================================================

module dht11_sensor_mount() {
	// Right side cutout for DHT11 - ensure deep cut
	translate([dht11_pos_x - epsilon, dht11_pos_y - dht11_depth/2 - 1, dht11_pos_z - dht11_height/2 - 1]) {
		// Sensor cutout with tolerance
		cube([wall_thickness + 2 + 2*epsilon, dht11_depth + 2 + tolerance, dht11_height + 2 + tolerance]);
		
		// Airflow slots - ensure deep cut
		for(i = [-2:2]) {
			translate([0, -1 + i*2, -2 - epsilon]) // Start slightly before wall
				cube([wall_thickness + 2 + 2*epsilon, 1, dht11_height + 6 + 2*epsilon]); // Cut through wall
		}
	}
	
	// Internal snap-fit bracket
	translate([case_width - wall_thickness - 8, dht11_pos_y - 6, wall_thickness + 8]) {
		difference() {
			cube([6, 12, 12]);
			// DHT11 friction-fit slot - ensure deep cut
			translate([2 - epsilon, 4 - epsilon, 4 - epsilon])
				cube([dht11_width + tolerance + 2*epsilon, dht11_depth + tolerance + 2*epsilon, dht11_height + tolerance + 2*epsilon]);
			// Wire access channel - ensure deep cut
			translate([3 - epsilon, 2 - epsilon, 2 - epsilon])
				cube([3 + 2*epsilon, 8 + 2*epsilon, 3 + 2*epsilon]);
			// Flex cuts - ensure deep cut
			translate([1 - epsilon, 6, 8 - epsilon])
				cube([8 + 2*epsilon, 0.5, 3 + 2*epsilon]);
		}
		
		// Retention clips
		translate([2, 4 + tolerance/2, 8.5])
			cube([dht11_width + tolerance, 1, 1]);
		translate([2, 9 - tolerance/2, 8.5])
			cube([dht11_width + tolerance, 1, 1]);
	}
	
	// Label area
	translate([case_width - 20, dht11_pos_y - 3, dht11_pos_z + 8])
		rotate([0, 0, 90])
			linear_extrude(0.5)
				text("T/H", size=3, halign="center", valign="center");
}

// ============================================================================
// BUZZER MOUNT (Pin 8 - AUDIO ALARM)
// ============================================================================

module buzzer_mount() {
	// Top sound port for buzzer - ensure deep cut
	translate([buzzer_pos_x, buzzer_pos_y, buzzer_pos_z]) {
		cylinder(d=buzzer_diameter - 1 + tolerance, h=wall_thickness + 2 + epsilon, center=true);
		
		// Sound amplification pattern
		for(ring = [1:4]) {
			translate([0, 0, -0.5 - epsilon]) // Start slightly before wall
				difference() {
					cylinder(d=buzzer_diameter - 1 + ring*2, h=1 + 2*epsilon); // Cut deeper
					cylinder(d=buzzer_diameter - 1 + (ring-1)*2, h=1 + 2*epsilon); // Cut deeper
				}
		}
	}
	
	// Internal buzzer mount
	translate([buzzer_pos_x, buzzer_pos_y, case_height - buzzer_height - wall_thickness - 3]) {
		difference() {
			cylinder(d=buzzer_diameter + 4, h=buzzer_height + 2);
			// Buzzer cavity - ensure deep cut
			translate([0, 0, 1 - epsilon])
				cylinder(d=buzzer_diameter + tolerance, h=buzzer_height + 2 + 2*epsilon);
			// Wire access holes - ensure deep cut
			translate([buzzer_diameter/2 + 1.5, 0, 0 - epsilon])
				cylinder(d=2.5, h=buzzer_height + 3 + 2*epsilon);
			translate([-buzzer_diameter/2 - 1.5, 0, 0 - epsilon])
				cylinder(d=2.5, h=buzzer_height + 3 + 2*epsilon);
		}
		
		// Retention clips
		for(angle = [0:120:240]) {
			rotate([0, 0, angle])
				translate([buzzer_diameter/2 + 1, 0, buzzer_height/2])
					cube([2, 1, 3], center=true);
		}
	}
	
	// Sound indicator
	translate([buzzer_pos_x - 8, buzzer_pos_y + 8, case_height - wall_thickness + 0.5])
		linear_extrude(0.5)
			text("♪", size=6, halign="center", valign="center");
}

// ============================================================================
// LED ALARM MOUNT (Pin 9 - VISUAL ALARM)
// ============================================================================

module led_mount() {
	// Front panel LED window
	translate([case_width - led_pos_x, led_pos_y - led_diameter/2 - tolerance/2, led_pos_z - led_diameter/2 - tolerance/2]) {
		// LED hole - ensure deep cut
		rotate([0, 90, 0])
			cylinder(d=led_diameter + tolerance, h=wall_thickness + 2 + epsilon);
		
		// Light diffusion chamber - ensure deep cut
		translate([wall_thickness - 1 - epsilon, 0, 0])
			rotate([0, 90, 0])
				cylinder(d1=led_diameter + tolerance, d2=led_diameter + 4, h=3 + 2*epsilon);
	}
	
	// Internal LED holder
	translate([case_width - wall_thickness - 2, led_pos_x, led_pos_z]) {
		difference() {
			cube([12, 8, 8], center=true);
			// LED cavity - ensure deep cut
			rotate([0, 90, 0])
				cylinder(d=led_diameter + tolerance, h=led_height + 2 + 2*epsilon, center=true);
			// Resistor slot - ensure deep cut
			translate([2 - epsilon, 0, -2 - epsilon])
				cube([resistor_length + 2 + 2*epsilon, 2 + 2*epsilon, 2 + 2*epsilon], center=true);
			// Wire routing - ensure deep cut
			translate([4 - epsilon, 0, 2 - epsilon])
				cube([6 + 2*epsilon, 1 + 2*epsilon, 2 + 2*epsilon], center=true);
		}
	}
	
	// Alarm indicator
	translate([case_width - 5, led_pos_x - 4, led_pos_z + 6])
		linear_extrude(0.5)
			text("!", size=4, halign="center", valign="center");
}

// ============================================================================
// OLED DISPLAY MOUNT
// ============================================================================
module oled_mount() {
    // Front panel cutout for OLED screen
    translate([oled_pos_x, oled_pos_y - epsilon, oled_pos_z - oled_height/2 - epsilon]) {
        // Cutout slightly larger than the screen for bezel clearance
        cube([oled_width + tolerance, oled_thickness + 2 * epsilon + wall_thickness, oled_height + tolerance]);
    }

    // Internal support ledges for OLED PCB
    translate([oled_pos_x, wall_thickness - 1, oled_pos_z - oled_height/2 - 2]) { // Position behind cutout, slightly below
        // Bottom ledge to support the OLED from underneath
        cube([oled_width, wall_thickness + 2, 1.5]); // Width of OLED, thickness for support, small height
    }

    // Optional side retention clips (friction fit)
    translate([oled_pos_x - 1, wall_thickness - 1, oled_pos_z - oled_height/2 + 2]) {
        cube([1.5, wall_thickness + 2, oled_height - 4]); // Left clip
    }
    translate([oled_pos_x + oled_width - 0.5, wall_thickness - 1, oled_pos_z - oled_height/2 + 2]) {
        cube([1.5, wall_thickness + 2, oled_height - 4]); // Right clip
    }
}

// ============================================================================
// MOMENTARY PUSH BUTTON MOUNT
// ============================================================================
module button_mount() {
    // 1. Cutout for the button plunger in the top surface of the case
    translate([button_pos_x, button_pos_y, button_pos_z_top_surface - epsilon]) {
        cylinder(d = button_hole_diameter + tolerance, h = wall_thickness + 2 * epsilon, center = true);
    }

    // 2. Internal mount for the button PCB, designed to sit directly below the top wall.
    // The top surface of this mount will be at (button_pos_z_top_surface - wall_thickness).
    // The button PCB will rest on the top surface of this mount.
    
    translate([button_pos_x, button_pos_y, button_pos_z_top_surface - wall_thickness - epsilon]) { // Start platform slightly below top inner edge
        difference() {
            // Main block for the button mount structure
            // X & Y dimensions are for the overall mount footprint
            // Z dimension is for the height of the mount structure, extending downwards
            cube([button_pcb_width + 4, button_pcb_depth + 4, button_pcb_thickness + button_housing_clearance + 2*epsilon], center=true);

            // Cutout for the button's PCB (friction fit)
            // This cube defines the cavity where the PCB will sit.
            // Adjusted size with tolerance for tight fit.
            translate([0, 0, button_pcb_thickness/2 + epsilon]) // Position for cutting the PCB slot, relative to mount's center
                cube([button_pcb_width + tolerance, button_pcb_depth + tolerance, button_pcb_thickness + 2*epsilon], center=true);
            
            // Cutout for the button's housing/pins that go *below* the PCB
            // This ensures clearance for the entire button component.
            translate([0, 0, -button_housing_clearance/2 - button_pcb_thickness/2 - epsilon]) // Position for cutting clearance below PCB
                cylinder(d = button_hole_diameter + tolerance, h = button_housing_clearance + 2*epsilon, center = true);
        }
    }

    // Add a simple label for the button functionality
    translate([button_pos_x + 10, button_pos_y, button_pos_z_top_surface + 0.5])
        linear_extrude(0.5)
            text("MODE", size=3, halign="left", valign="center");
}


// ============================================================================
// ENHANCED VENTILATION
// ============================================================================

module ventilation_system() {
	vent_diameter = 4; // mm
	vent_spacing_x = 15;
	vent_spacing_y = 12;
	
	// Left side ventilation - ensure deep cut
	for(i = [0:floor((case_height - 2*wall_thickness - vent_diameter)/vent_spacing_x) - 1]) {
		for(j = [0:floor((case_depth - 2*wall_thickness - vent_diameter)/vent_spacing_y) - 1]) {
			translate([-1 - epsilon, wall_thickness + 5 + j*vent_spacing_y, wall_thickness + 5 + i*vent_spacing_x]) // Start slightly outside
				rotate([0, 90, 0])
					cylinder(d=vent_diameter, h=wall_thickness + 2 + 2*epsilon); // Cut through wall completely
		}
	}
	
	// Right side ventilation - ensure deep cut
	for(i = [0:floor((case_height - 2*wall_thickness - vent_diameter)/vent_spacing_x) - 1]) {
		for(j = [0:floor((case_depth - 2*wall_thickness - vent_diameter)/vent_spacing_y) - 1]) {
			translate([case_width + 1 + epsilon, wall_thickness + 5 + j*vent_spacing_y, wall_thickness + 5 + i*vent_spacing_x]) // Start slightly outside
				rotate([0, 90, 0])
					cylinder(d=vent_diameter, h=wall_thickness + 2 + 2*epsilon); // Cut through wall completely
		}
	}
	
	// Bottom ventilation - ensure deep cut
	for(i = [0:floor((case_width - 2*wall_thickness - vent_diameter)/vent_spacing_x) - 1]) {
		for(j = [0:floor((case_depth - 2*wall_thickness - vent_diameter)/vent_spacing_y) - 1]) {
			translate([wall_thickness + 5 + i*vent_spacing_x, wall_thickness + 5 + j*vent_spacing_y, -1 - epsilon]) // Start slightly below
				cylinder(d=vent_diameter, h=wall_thickness + 2 + 2*epsilon); // Cut through wall completely
		}
	}
}

// ============================================================================
// CABLE MANAGEMENT
// ============================================================================

module cable_management() {
	// USB cable access - ensure deep cut
	translate([-1 - epsilon, arduino_base_offset_y + 35, case_height - 15])
		cube([wall_thickness + 2 + 2*epsilon, 15 + tolerance, 12 + tolerance]);
	
	// Power jack access - ensure deep cut
	translate([-1 - epsilon, arduino_base_offset_y + 50, case_height - 12])
		cube([wall_thickness + 2 + 2*epsilon, 10 + tolerance, 8 + tolerance]);
	
	// Rear sensor wire access - ensure deep cut
	translate([case_width/3, case_depth + 1 + epsilon, wall_thickness + 8])
		rotate([90, 0, 0])
			hull() {
				cylinder(d=8 + tolerance, h=wall_thickness + 2 + 2*epsilon);
				translate([20, 0, 0]) cylinder(d=8 + tolerance, h=wall_thickness + 2 + 2*epsilon);
			}
	
	// Internal wire routing channels - ensure deep cut
	translate([arduino_base_offset_x + arduino_width + 2, arduino_base_offset_y, wall_thickness - epsilon])
		cube([5, arduino_depth, 20 + 2*epsilon]);
	
	translate([arduino_base_offset_x, arduino_base_offset_y + arduino_depth + 2, wall_thickness - epsilon])
		cube([arduino_width, 5, 20 + 2*epsilon]);
		
	// Power wire channel - ensure deep cut
	translate([arduino_base_offset_x - 8, arduino_base_offset_y + 10, wall_thickness - epsilon])
		cube([6, arduino_depth - 20, 15 + 2*epsilon]);
}

// ============================================================================
// SNAP-FIT LID WITH STATUS INDICATORS
// ============================================================================

module snap_fit_lid() {
	lid_thickness = 2.5;
	
	difference() {
		// Main lid body
		rounded_box(case_width, case_depth, lid_thickness, corner_radius);
		
		// Arduino status LED window - ensure deep cut
		translate([arduino_base_offset_x + 50, arduino_base_offset_y + 15, -1 - epsilon])
			cylinder(d=4 + tolerance, h=lid_thickness + 2 + 2*epsilon);
		
		// Project label area
		translate([case_width/2 - 35, case_depth/2 - 12, lid_thickness - 0.8])
			cube([70, 24, 1]);
		
		// Ventilation pattern in lid - ensure deep cut
		vent_lid_spacing_x = 15;
		vent_lid_spacing_y = 12;
		vent_lid_diameter = 3;
		
		for(i = [0:floor((case_width - 2*wall_thickness - vent_lid_diameter)/vent_lid_spacing_x) - 1]) {
			for(j = [0:floor((case_depth - 2*wall_thickness - vent_lid_diameter)/vent_lid_spacing_y) - 1]) {
				translate([wall_thickness + 10 + i*vent_lid_spacing_x, wall_thickness + 10 + j*vent_lid_spacing_y, -1 - epsilon])
					cylinder(d=vent_lid_diameter, h=lid_thickness + 2 + 2*epsilon);
			}
		}
		
		// Buzzer sound ports - ensure deep cut
		translate([buzzer_pos_x, buzzer_pos_y, -1 - epsilon])
			cylinder(d=buzzer_diameter - 2 + tolerance, h=lid_thickness + 2 + 2*epsilon);
		
		// MQ-2 sensor access - ensure deep cut
		translate([mq2_pos_x, mq2_pos_y, -1 - epsilon])
			cylinder(d=mq2_diameter + 6 + tolerance, h=lid_thickness + 2 + 2*epsilon);
	}
	
	// Snap-fit tabs
	tab_width = 8;
	tab_length = 3;
	tab_height = 4;
	
	// Front tab
	translate([case_width/2 - tab_width/2, 0, lid_thickness])
		cube([tab_width, tab_length, tab_height]);
	// Back tab
	translate([case_width/2 - tab_width/2, case_depth - tab_length, lid_thickness])
		cube([tab_width, tab_length, tab_height]);
	// Right tab
	translate([case_width - tab_length, case_depth/2 - tab_width/2, lid_thickness])
		cube([tab_length, tab_width, tab_height]);
	// Left tab
	translate([0, case_depth/2 - tab_width/2, lid_thickness])
		cube([tab_length, tab_width, tab_height]);
	
	// Lid lip for tight seal - ensure no co-planar faces on the difference
	translate([wall_thickness + tolerance, wall_thickness + tolerance, lid_thickness]) {
		difference() {
			rounded_box(case_width - 2*wall_thickness - 2*tolerance, case_depth - 2*wall_thickness - 2*tolerance, 3, corner_radius - tolerance);
			
			translate([tolerance - epsilon, tolerance - epsilon, -1 - epsilon]) // Ensure cutting object fully engulfs
				rounded_box(case_width - 2*wall_thickness - 4*tolerance + 2*epsilon, case_depth - 2*wall_thickness - 4*tolerance + 2*epsilon, 5 + 2*epsilon, corner_radius - 2*tolerance);
		}
	}
	
	// Project title embossed on lid
	translate([case_width/2, case_depth/2 - 6, lid_thickness])
		linear_extrude(0.8)
			text("GAS DETECTOR", size=4, halign="center", valign="center");
	
	translate([case_width/2, case_depth/2 + 2, lid_thickness])
		linear_extrude(0.8)
			text("& CLIMATE MONITOR", size=3, halign="center", valign="center");
}

// ============================================================================
// COMPLETE CASE ASSEMBLY
// ============================================================================

module complete_case() {
	difference() {
		union() {
			main_case_structure();
			arduino_mounting();
			breadboard_mount();
		}
		
		// Cut all openings and mounts
		mq2_sensor_mount(); 	// Gas sensor (Pin A0)
		dht11_sensor_mount(); 	// Temp/Humidity (Pin 3) 
		buzzer_mount(); 		// Audio alarm (Pin 8)
		led_mount(); 			// Visual alarm (Pin 9)
        oled_mount();           // OLED Display Cutout
        button_mount();         // NEW: Push Button Cutout and Mount
		ventilation_system(); 	// Enhanced airflow
		cable_management(); 	// Organized wiring
	}
}

// ============================================================================
// K7 MINI PRINT LAYOUT
// ============================================================================

module print_layout() {
    // Control which part to render. Set ONLY ONE to 'true' at a time for exporting.
    if (RENDER_MAIN_CASE) {
        // Main case (print bottom-down for best quality)
        complete_case();
    }
    
    if (RENDER_LID) {
        // Lid (separate for easier printing)
        // No translation needed here, as it will be the only object rendered and centered
        snap_fit_lid();
    }
}

// ============================================================================
// RENDER FOR PRINTING
// ============================================================================

// Render both components for printing
print_layout();

/* ============================================================================
🚨 GAS DETECTION + CLIMATE MONITORING CASE 🌡️
============================================================================

📋 COMPONENT CONNECTIONS (Your Pin Assignments):
- Pin A0: MQ-2 Gas Sensor (analog input)
- Pin 3:  DHT11 Temperature/Humidity (digital)
- Pin 8:  Active Buzzer (alarm output)
- Pin 9:  LED + 220Ω Resistor (visual alarm)
- 5V:     Power for MQ-2 + DHT11
- GND:    Common ground for all components
- New: Mode Button (connect to digital pin, e.g., Pin 2)

🎯 PRINTING TIPS FOR K7 MINI:
- Use 0.2mm layer height for best detail
- Print with red PLA as specified
- **No supports needed** - designed for overhang printing (verify with your slicer!)
- Estimated print time: 8-12 hours total (may vary based on slicer settings)
- Main case: ~6-8 hours, Lid: ~2-4 hours

🔧 ASSEMBLY:
1. Print both parts separately (Render and export one at a time using RENDER_MAIN_CASE / RENDER_LID flags)
2. Install Arduino using snap-fit posts (no screws!)
3. Mount breadboard with friction fit
4. Install sensors in designated mounts
5. Route wires through management channels
6. Snap lid on with integrated tabs

⚠️ TOLERANCE ADJUSTMENT:
- If parts are too tight: increase `tolerance` variable (e.g., 0.25)
- If parts are too loose: decrease `tolerance` variable (e.g., 0.15)
- Current setting: 0.2mm (good starting point)

🚨 IMPORTANT NOTE FOR K7 MINI:
- The **`case_width` has been adjusted to 98mm** to fit the K7 Mini's 100mm build plate. This leaves a 1mm margin on each side.
- For optimal slicing, ensure your slicer settings are tuned for **clean overhangs** given the detailed ventilation and snap-fit features.
- Since the K7 Mini typically does not have a heated bed, be mindful of potential **warping** for larger flat surfaces, especially with the main case. Ensure good bed adhesion (e.g., using glue stick or painter's tape).
============================================================================ */
