// ============================================================================
// RED ARDUINO GAS DETECTION + CLIMATE MONITORING CASE - K7 MINI OPTIMIZED
// ============================================================================
// For: Arduino Uno + MQ-2 Gas Sensor + DHT11 Temp/Humidity + Buzzer + LED
// Features: Gas detection alarm system with climate monitoring
// 100% SCREW-FREE DESIGN - Snap-fits and friction mounts only!
// Optimized for K7 Mini 3D Printer - Red PLA Filament
//
// IMPROVEMENTS IN THIS VERSION:
// - Global `tolerance` variable for easy adjustment of part fit.
// - Reusable `rounded_box` module for cleaner main case and lid definitions.
// - More robust and parametric snap-fit mounting posts for Arduino.
// - Enhanced cable management features.
// - Improved lid snap-fit tabs for better retention.
// - More dynamic and parametric ventilation patterns.
// - Consistent use of variables for dimensions and positions.
// ============================================================================

// Print quality optimization
$fn = 60; // Smooth curves for K7 Mini

// Global manufacturing tolerance for friction fits and clearances
// Adjust this value based on your printer's calibration and filament.
// Positive value for making holes larger, negative for making pins smaller.
tolerance = 0.2; // mm

// ============================================================================
// COMPONENT SPECIFICATIONS
// ============================================================================

// Arduino Uno dimensions
arduino_width = 68.6;   // mm
arduino_depth = 53.4;   // mm
arduino_height = 1.6;   // mm

// 0.96" OLED Display (128x64 pixels) - Optional display
oled_width = 27.0;      // mm
oled_height = 27.0;     // mm  
oled_thickness = 4.0;   // mm including PCB
oled_screen_width = 21.7; // mm (actual display area)
oled_screen_height = 11.2; // mm

// MQ-2 Gas Sensor (main detection component)
mq2_diameter = 20.0;    // mm (sensor housing)
mq2_height = 16.0;      // mm
mq2_pcb_width = 32.0;   // mm (PCB dimensions)
mq2_pcb_depth = 20.0;   // mm

// DHT11 Temperature/Humidity Sensor  
dht11_width = 16.0;     // mm
dht11_depth = 12.0;     // mm
dht11_height = 5.5;     // mm

// Active Buzzer (alarm component)
buzzer_diameter = 12.0; // mm (typical active buzzer)
buzzer_height = 9.0;    // mm

// LED + Resistor (visual alarm)
led_diameter = 5.0;     // mm (standard LED)
led_height = 8.0;       // mm
resistor_length = 6.0;  // mm (220Ω resistor)

// Mini breadboard (for connections)
breadboard_width = 55;   // mm
breadboard_depth = 35;   // mm
breadboard_height = 8.5; // mm

// Case dimensions (K7 Mini bed optimized)
case_width = 130;       // mm (wider for alarm components)
case_depth = 100;       // mm
case_height = 50;       // mm (taller for buzzer clearance)
wall_thickness = 2.5;   // mm (perfect for 0.4mm nozzle)
corner_radius = 4;      // mm

// ============================================================================
// COMPONENT POSITIONS (Based on your pin assignments, improved for modularity)
// ============================================================================

// Arduino mounting holes (standard Uno pattern)
arduino_hole_offsets = [
    [2.54, 15.24],    // mm from board's bottom-left corner
    [15.24, 50.8],
    [66.04, 35.56],
    [66.04, 7.62]
];

// Arduino base offset within the case
arduino_base_offset_x = 20;  // mm from case edge
arduino_base_offset_y = 45;  // mm from case edge (room for breadboard)

// OLED position (left side, optional display)
oled_cutout_offset_x = 10;        // mm from case front face (Y-axis)
oled_cutout_offset_z = case_height/2 - oled_height/2; // Z-center of case height

// Breadboard area (front of Arduino for connections)
breadboard_pos_x = arduino_base_offset_x;
breadboard_pos_y = 8;   // mm from case front edge (Y-axis)

// MQ-2 Gas Sensor (Pin A0) - CRITICAL: Needs maximum air exposure
mq2_pos_x = breadboard_pos_x + 25; // Relative to breadboard
mq2_pos_y = breadboard_pos_y + 15;
mq2_pos_z = case_height - wall_thickness; // Top mount for best gas detection

// DHT11 Sensor (Pin 3) - Side mount for ambient air readings
dht11_pos_x = case_width - wall_thickness; // Right side wall
dht11_pos_y = case_depth/2; // Centered vertically on side
dht11_pos_z = case_height/2; // Centered horizontally on side

// Buzzer (Pin 8) - Top front for maximum sound output
buzzer_pos_x = case_width/4;
buzzer_pos_y = 15;
buzzer_pos_z = case_height - wall_thickness; // On top face

// LED (Pin 9) - Front panel for visibility
led_pos_x = 15; // From left edge (X-axis)
led_pos_y = -wall_thickness; // On front face (Y-axis)
led_pos_z = case_height/2; // Centered vertically

// ============================================================================
// REUSABLE GEOMETRIC PRIMITIVES
// ============================================================================

// Module to create a rounded box with consistent corners
module rounded_box(w, d, h, r) {
    // Uses hull of 4 cylinders to create rounded corners, then linear extrudes
    hull() {
        translate([r, r, 0]) cylinder(r=r, h=h);
        translate([w-r, r, 0]) cylinder(r=r, h=h);
        translate([r, d-r, 0]) cylinder(r=r, h=h);
        translate([w-r, d-r, 0]) cylinder(r=r, h=h);
    }
}

// ============================================================================
// MAIN CASE BODY
// ============================================================================

module main_case() {
    difference() {
        // Outer shell with rounded corners using the reusable module
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
// Arguments: d_post - diameter of the main post
//            d_hole - diameter of the hole for screw/standoff
//            h_post - height of the post
//            d_clip - diameter of the top clip
//            h_clip - height of the top clip
module snap_fit_post(d_post, d_hole, h_post, d_clip, h_clip) {
    difference() {
        cylinder(d=d_post, h=h_post);
        // Center hole for Arduino mounting hole, extended for full cut
        cylinder(d=d_hole + tolerance, h=h_post + 1);
    }
    // Snap-fit top with flexible tabs
    translate([0, 0, h_post]) {
        difference() {
            cylinder(d=d_clip, h=h_clip);
            // Cross slots for flexibility (K7 Mini can print these)
            // Use small negative offset for depth to ensure full cut
            translate([-d_clip/2 + 0.5, -0.3, -0.5]) // Adjusted for better centering
                cube([d_clip - 1, 0.6, h_clip + 1]);
            translate([-0.3, -d_clip/2 + 0.5, -0.5]) // Adjusted for better centering
                cube([0.6, d_clip - 1, h_clip + 1]);
        }
    }
}

module arduino_mounting() {
    mount_height = 8;     // mm standoff height
    
    // Snap-fit Arduino mounting posts using the reusable module
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
    
    // Arduino support ledges (holds board securely) - Adjusted Z for better support
    translate([arduino_base_offset_x - 2, arduino_base_offset_y - 2, wall_thickness + mount_height - 1.5])
        cube([arduino_width + 4, 2, 2]);
    
    translate([arduino_base_offset_x - 2, arduino_base_offset_y + arduino_depth, wall_thickness + mount_height - 1.5])
        cube([arduino_width + 4, 2, 2]);
    
    // Wire routing channel under Arduino - Slightly larger for easier routing
    translate([arduino_base_offset_x - 3, arduino_base_offset_y - 3, wall_thickness])
        cube([arduino_width + 6, 2, 3]);
}

// ============================================================================
// FRICTION-FIT BREADBOARD MOUNT
// ============================================================================

module breadboard_mount() {
    // Friction-fit platform (no adhesive needed!)
    translate([breadboard_pos_x - 2, breadboard_pos_y - 2, wall_thickness]) {
        // Base platform
        cube([breadboard_width + 4, breadboard_depth + 4, 2]);
        
        // Friction-fit side rails (0.2mm tolerance for perfect fit)
        // Adjusted slightly for consistent application of global tolerance
        translate([1, 1, 2])
            cube([2 + tolerance, breadboard_depth + 2, 4]); // Wider for friction
        translate([breadboard_width + 1 - tolerance, 1, 2]) // Offset for friction
            cube([2 + tolerance, breadboard_depth + 2, 4]);
        
        // End stops prevent sliding
        translate([3, 1 + tolerance, 2]) // Offset for friction
            cube([breadboard_width - 2, 2 + tolerance, 4]);
        translate([3, breadboard_depth + 1 - tolerance, 2]) // Offset for friction
            cube([breadboard_width - 2, 2 + tolerance, 4]);
    }
    
    // Snap-fit wire management posts (organized wiring for gas detection system)
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
                // Wire routing slots (snap wires in place) - adjusted for clarity
                translate([-1, -3, 8])
                    cube([2, 6, 8]);
                translate([-3, -1, 8])
                    cube([6, 2, 8]);
                // Flexible top for easy wire insertion
                translate([0, 0, 12])
                    cylinder(d1=6, d2=4, h=3);
            }
        }
    }
    
    // Integrated jumper wire channels (larger for easier access)
    translate([breadboard_pos_x + breadboard_width + 2, breadboard_pos_y, wall_thickness])
        cube([6, breadboard_depth, 3]);
    
    translate([breadboard_pos_x, breadboard_pos_y + breadboard_depth + 2, wall_thickness])
        cube([breadboard_width, 6, 3]);
}

// ============================================================================
// OPTIONAL OLED DISPLAY MOUNT (For visual readings)
// ============================================================================

module oled_mount() {
    mount_thickness = wall_thickness;
    
    // Left side cutout for OLED (using tolerance for snug friction fit)
    translate([-1, oled_cutout_offset_x, oled_cutout_offset_z]) {
        // OLED module cutout with tolerance
        cube([mount_thickness + 2, oled_width + tolerance, oled_height + tolerance]);
        
        // Screen viewing area (recessed for flush mounting)
        translate([-0.5, (oled_width - oled_screen_width)/2, (oled_height - oled_screen_height)/2])
            cube([mount_thickness + 3, oled_screen_width, oled_screen_height]);
    }
    
    // Internal friction-fit mounting system
    // Positioning relative to the case's inner wall and OLED cutout
    translate([wall_thickness, oled_cutout_offset_x - 1, oled_cutout_offset_z - 1]) {
        // Bottom support ledge with retention lip
        difference() {
            cube([oled_thickness + 3, oled_width + 2, 3]);
            translate([1, 1, 1])
                cube([oled_thickness + 1, oled_width, 3]);
        }
        
        // Side guides with flex cuts for easy insertion (using tolerance)
        difference() {
            cube([oled_thickness + 3, 2, oled_height + 2 + tolerance]); // Increased height for tolerance
            translate([2, 1, oled_height/2 + tolerance/2]) // Adjusted for tolerance
                cube([oled_thickness, 0.5, 2]);
        }
        
        translate([0, oled_width + tolerance, 0]) { // Shifted for tolerance
            difference() {
                cube([oled_thickness + 3, 2, oled_height + 2 + tolerance]);
                translate([2, 1, oled_height/2 + tolerance/2])
                    cube([oled_thickness, 0.5, 2]);
            }
        }
        
        // Top retention clip
        translate([1, 1, oled_height - 1 + tolerance]) // Adjusted for tolerance
            cube([oled_thickness + 1, oled_width, 2]);
    }
}

// ============================================================================
// MQ-2 GAS SENSOR MOUNT (Pin A0 - CRITICAL FOR GAS DETECTION)
// ============================================================================

module mq2_sensor_mount() {
    // Top ventilation grille for MQ-2 (MAXIMUM air exposure for gas detection)
    translate([mq2_pos_x, mq2_pos_y, mq2_pos_z]) {
        // Main sensor access hole with tolerance
        cylinder(d=mq2_diameter + 4 + tolerance, h=wall_thickness + 2, center=true);
        
        // Protective mesh pattern (prevents debris, maximizes airflow)
        // Moved to a sub-module for potential reuse or easier modification
        module protective_mesh(spacing, hole_d, radius_limit) {
            for(i = [-3:3]) {
                for(j = [-3:3]) {
                    if(sqrt(i*i + j*j) <= radius_limit) {
                        translate([i*spacing, j*spacing, 0])
                            cylinder(d=hole_d, h=wall_thickness + 2, center=true);
                    }
                }
            }
        }
        
        // Apply mesh pattern over the main hole
        protective_mesh(spacing=2.5, hole_d=1.2, radius_limit=3.2);
    }
    
    // Enhanced airflow slots around MQ-2 (gas detection needs maximum air circulation)
    // Made more parametric with variable count and slot dimensions
    num_slots = 8;
    slot_angle = 360 / num_slots;
    slot_length = 12;
    slot_width = 4;
    slot_offset = mq2_diameter/2 + 5;
    
    for(i = [0:num_slots-1]) {
        rotate([0, 0, i * slot_angle])
            translate([slot_offset, -slot_width/2, mq2_pos_z - wall_thickness - 1])
                cube([slot_length, slot_width, wall_thickness + 2]);
    }
    
    // Warning label area around sensor
    translate([mq2_pos_x - 15, mq2_pos_y - 8, case_height - wall_thickness + 0.5])
        linear_extrude(0.5)
            text("GAS", size=4, halign="center", valign="center");
}

// ============================================================================
// DHT11 CLIMATE SENSOR MOUNT (Pin 3 - AMBIENT CONDITIONS)
// ============================================================================

module dht11_sensor_mount() {
    // Right side cutout for DHT11 (ambient air access) - using tolerance
    translate([dht11_pos_x, dht11_pos_y - dht11_depth/2 - 1, dht11_pos_z - dht11_height/2 - 1]) {
        // Sensor cutout with tolerance
        cube([wall_thickness + 2, dht11_depth + 2 + tolerance, dht11_height + 2 + tolerance]);
        
        // Horizontal airflow slots for accurate ambient readings
        for(i = [-2:2]) {
            translate([0, -1 + i*2, -2])
                cube([wall_thickness + 2, 1, dht11_height + 6]);
        }
    }
    
    // Internal snap-fit bracket (no screws needed!) - using tolerance
    translate([case_width - wall_thickness - 8, dht11_pos_y - 6, wall_thickness + 8]) {
        difference() {
            cube([6, 12, 12]);
            // DHT11 friction-fit slot (using tolerance)
            translate([2, 4, 4])
                cube([dht11_width + tolerance, dht11_depth + tolerance, dht11_height + tolerance]);
            // Wire access channel
            translate([3, 2, 2])
                cube([3, 8, 3]);
            // Flex cuts for easy insertion
            translate([1, 6, 8])
                cube([8, 0.5, 3]);
        }
        
        // Retention clips (snap over sensor) - adjusted for tolerance
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
    // Top sound port for buzzer (maximum audio output)
    translate([buzzer_pos_x, buzzer_pos_y, buzzer_pos_z]) {
        // Main sound hole with tolerance
        cylinder(d=buzzer_diameter - 1 + tolerance, h=wall_thickness + 2, center=true);
        
        // Sound amplification pattern (horn-like design)
        // More rings for potentially better amplification
        for(ring = [1:4]) { // Increased rings from 3 to 4
            translate([0, 0, -0.5])
                difference() {
                    cylinder(d=buzzer_diameter - 1 + ring*2, h=1);
                    cylinder(d=buzzer_diameter - 1 + (ring-1)*2, h=1);
                }
        }
    }
    
    // Internal buzzer mount (snap-fit holder) - using tolerance
    translate([buzzer_pos_x, buzzer_pos_y, case_height - buzzer_height - wall_thickness - 3]) {
        difference() {
            cylinder(d=buzzer_diameter + 4, h=buzzer_height + 2);
            // Buzzer cavity (tight fit) - using tolerance
            translate([0, 0, 1])
                cylinder(d=buzzer_diameter + tolerance, h=buzzer_height + 2);
            // Wire access holes - made slightly larger
            translate([buzzer_diameter/2 + 1.5, 0, 0])
                cylinder(d=2.5, h=buzzer_height + 3);
            translate([-buzzer_diameter/2 - 1.5, 0, 0])
                cylinder(d=2.5, h=buzzer_height + 3);
        }
        
        // Retention clips
        for(angle = [0:120:240]) {
            rotate([0, 0, angle])
                translate([buzzer_diameter/2 + 1, 0, buzzer_height/2])
                    cube([2, 1, 3], center=true);
        }
    }
    
    // Sound direction indicators
    translate([buzzer_pos_x - 8, buzzer_pos_y + 8, case_height - wall_thickness + 0.5])
        linear_extrude(0.5)
            text("♪", size=6, halign="center", valign="center");
}

// ============================================================================
// LED ALARM MOUNT (Pin 9 - VISUAL ALARM)
// ============================================================================

module led_mount() {
    // Front panel LED window (bright visual alarm) - using tolerance
    translate([0, led_pos_x - led_diameter/2 - tolerance/2, led_pos_z - led_diameter/2 - tolerance/2]) {
        // LED hole with tolerance
        rotate([0, 90, 0])
            cylinder(d=led_diameter + tolerance, h=wall_thickness + 2);
        
        // Light diffusion chamber (spreads LED light)
        translate([wall_thickness - 1, 0, 0])
            rotate([0, 90, 0])
                cylinder(d1=led_diameter + tolerance, d2=led_diameter + 4, h=3);
    }
    
    // Internal LED holder with resistor space
    translate([wall_thickness + 2, led_pos_x, led_pos_z]) {
        difference() {
            cube([12, 8, 8], center=true);
            // LED cavity with tolerance
            rotate([0, 90, 0])
                cylinder(d=led_diameter + tolerance, h=led_height + 2, center=true);
            // Resistor slot (220Ω) - adjusted for resistor length
            translate([2, 0, -2])
                cube([resistor_length + 2, 2, 2], center=true);
            // Wire routing
            translate([4, 0, 2])
                cube([6, 1, 2], center=true);
        }
    }
    
    // Alarm indicator
    translate([5, led_pos_x - 4, led_pos_z + 6])
        linear_extrude(0.5)
            text("!", size=4, halign="center", valign="center");
}

// ============================================================================
// ENHANCED VENTILATION (Critical for gas detection accuracy)
// ============================================================================

module ventilation_system() {
    vent_diameter = 4; // mm
    vent_spacing_x = 15;
    vent_spacing_y = 12;
    
    // Left side ventilation (intake air for sensors) - more systematic placement
    for(i = [0:floor((case_height - 2*wall_thickness - vent_diameter)/vent_spacing_x) - 1]) {
        for(j = [0:floor((case_depth - 2*wall_thickness - vent_diameter)/vent_spacing_y) - 1]) {
            translate([-1, wall_thickness + 5 + j*vent_spacing_y, wall_thickness + 5 + i*vent_spacing_x])
                rotate([0, 90, 0])
                    cylinder(d=vent_diameter, h=wall_thickness + 2);
        }
    }
    
    // Right side ventilation (exhaust air for circulation)
    for(i = [0:floor((case_height - 2*wall_thickness - vent_diameter)/vent_spacing_x) - 1]) {
        for(j = [0:floor((case_depth - 2*wall_thickness - vent_diameter)/vent_spacing_y) - 1]) {
            translate([case_width + 1, wall_thickness + 5 + j*vent_spacing_y, wall_thickness + 5 + i*vent_spacing_x])
                rotate([0, 90, 0])
                    cylinder(d=vent_diameter, h=wall_thickness + 2);
        }
    }
    
    // Bottom ventilation for electronics cooling
    for(i = [0:floor((case_width - 2*wall_thickness - vent_diameter)/vent_spacing_x) - 1]) {
        for(j = [0:floor((case_depth - 2*wall_thickness - vent_diameter)/vent_spacing_y) - 1]) {
            translate([wall_thickness + 5 + i*vent_spacing_x, wall_thickness + 5 + j*vent_spacing_y, -1])
                cylinder(d=vent_diameter, h=wall_thickness + 2);
        }
    }
}

// ============================================================================
// CABLE MANAGEMENT (Organized wiring for reliable connections)
// ============================================================================

module cable_management() {
    // USB cable access (programming and power) - using tolerance
    translate([-1, arduino_base_offset_y + 35, case_height - 15])
        cube([wall_thickness + 2, 15 + tolerance, 12 + tolerance]);
    
    // Power jack access - using tolerance
    translate([-1, arduino_base_offset_y + 50, case_height - 12])
        cube([wall_thickness + 2, 10 + tolerance, 8 + tolerance]);
    
    // Rear sensor wire access (organized cable routing) - more distinct openings
    translate([case_width/3, case_depth + 1, wall_thickness + 8])
        rotate([90, 0, 0])
            hull() {
                cylinder(d=8 + tolerance, h=wall_thickness + 2);
                translate([20, 0, 0]) cylinder(d=8 + tolerance, h=wall_thickness + 2);
            }
    
    // Internal wire routing channels (prevents wire tangles) - wider and taller
    translate([arduino_base_offset_x + arduino_width + 2, arduino_base_offset_y, wall_thickness])
        cube([5, arduino_depth, 20]); // Increased width and height
    
    translate([arduino_base_offset_x, arduino_base_offset_y + arduino_depth + 2, wall_thickness])
        cube([arduino_width, 5, 20]); // Increased width and height
        
    // Dedicated power wire channel (5V and GND distribution) - wider and taller
    translate([arduino_base_offset_x - 8, arduino_base_offset_y + 10, wall_thickness])
        cube([6, arduino_depth - 20, 15]); // Increased width and height
}

// ============================================================================
// SNAP-FIT LID WITH STATUS INDICATORS
// ============================================================================

module snap_fit_lid() {
    lid_thickness = 2.5;
    
    difference() {
        // Main lid body using rounded_box
        rounded_box(case_width, case_depth, lid_thickness, corner_radius);
        
        // Arduino status LED window - using tolerance
        translate([arduino_base_offset_x + 50, arduino_base_offset_y + 15, -1])
            cylinder(d=4 + tolerance, h=lid_thickness + 2);
        
        // Project label area (recessed for professional labeling)
        translate([case_width/2 - 35, case_depth/2 - 12, lid_thickness - 0.8])
            cube([70, 24, 1]);
        
        // Ventilation pattern in lid (enhanced for gas circulation) - dynamic placement
        vent_lid_spacing_x = 15;
        vent_lid_spacing_y = 12;
        vent_lid_diameter = 3;
        
        for(i = [0:floor((case_width - 2*wall_thickness - vent_lid_diameter)/vent_lid_spacing_x) - 1]) {
            for(j = [0:floor((case_depth - 2*wall_thickness - vent_lid_diameter)/vent_lid_spacing_y) - 1]) {
                translate([wall_thickness + 10 + i*vent_lid_spacing_x, wall_thickness + 10 + j*vent_lid_spacing_y, -1])
                    cylinder(d=vent_lid_diameter, h=lid_thickness + 2);
            }
        }
        
        // Buzzer sound ports (additional top venting) - using tolerance
        translate([buzzer_pos_x, buzzer_pos_y, -1])
            cylinder(d=buzzer_diameter - 2 + tolerance, h=lid_thickness + 2);
        
        // MQ-2 sensor access (critical for gas detection) - using tolerance
        translate([mq2_pos_x, mq2_pos_y, -1])
            cylinder(d=mq2_diameter + 6 + tolerance, h=lid_thickness + 2);
    }
    
    // Snap-fit tabs (K7 Mini optimized geometry) - more robust with defined dimensions
    tab_width = 8;
    tab_length = 3;
    tab_height = 4;
    
    // Function to create a single snap tab
    module snap_tab() {
        cube([tab_width, tab_length, tab_height]);
    }

    // Front tab
    translate([case_width/2 - tab_width/2, 0, lid_thickness])
        snap_tab();
    // Back tab
    translate([case_width/2 - tab_width/2, case_depth - tab_length, lid_thickness])
        snap_tab();
    // Right tab (rotated)
    translate([case_width - tab_length, case_depth/2 - tab_width/2, lid_thickness])
        rotate([0, 0, 90])
            snap_tab();
    // Left tab (rotated)
    translate([0, case_depth/2 - tab_width/2, lid_thickness])
        rotate([0, 0, 90])
            snap_tab();
    
    // Lid lip for tight seal (prevents gas leakage) - using tolerance
    // This creates a slight inset that fits into the case's inner wall
    translate([wall_thickness + tolerance, wall_thickness + tolerance, lid_thickness]) {
        difference() {
            // Outer shape of the lip (slightly larger than inner cavity of main case)
            rounded_box(case_width - 2*wall_thickness - 2*tolerance, case_depth - 2*wall_thickness - 2*tolerance, 3, corner_radius - tolerance);
            
            // Inner cutout to create the wall of the lip
            translate([tolerance, tolerance, -1])
                rounded_box(case_width - 2*wall_thickness - 4*tolerance, case_depth - 2*wall_thickness - 4*tolerance, 5, corner_radius - 2*tolerance);
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
            main_case();
            arduino_mounting();
            breadboard_mount();
        }
        
        // Cut all openings and mounts
        // Use color modifier for visualization during design, remove for final render
        // %oled_mount();           // Optional display (commented out for render, uncomment if needed)
        mq2_sensor_mount();     // Gas sensor (Pin A0)
        dht11_sensor_mount();   // Temp/Humidity (Pin 3)  
        buzzer_mount();         // Audio alarm (Pin 8)
        led_mount();            // Visual alarm (Pin 9)
        ventilation_system();   // Enhanced airflow
        cable_management();     // Organized wiring
    }
}

// ============================================================================
// K7 MINI PRINT LAYOUT
// ============================================================================

module print_layout() {
    // Main case (print bottom-down for best quality)
    complete_case();
    
    // Lid (separate for easier printing and better surface finish)
    // Translate the lid away from the main case for printing
    translate([case_width + 20, 0, 0])
        snap_fit_lid();
}

// ============================================================================
// RENDER FOR PRINTING
// ============================================================================

// Render both components for printing
print_layout();

// Alternative: Print individual parts (uncomment as needed for debugging or specific print jobs)
// complete_case();  // Main case only  
// snap_fit_lid();   // Lid only

/* ============================================================================
🚨 GAS DETECTION + CLIMATE MONITORING CASE 🌡️
============================================================================

📋 COMPONENT CONNECTIONS (Your Pin Assignments):
- Pin A0: MQ-2 Gas Sensor (analog input)
- Pin 3:  DHT11 Temperature/Humidity (digital)
- Pin 8:  Active Buzzer (alarm output)
- Pin 9:  LED + 220Ω Resistor (visual alarm)
- 5V:     Power for MQ-2 + DHT11
- GND:    Common ground for all components
