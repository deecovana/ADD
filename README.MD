# @deecovana ADD GitHub repo 

## Play with Terrains and shaders
- Added 2 more Blender terrains 
  - Needs to snap borders
- Compared and fixed Rally and Rally2
  - Tested Compared on 3x3 maps
- Added Height-based shader
  - Texture-based shader working wrong
  - Textured shader brighter BUT WITHOUT TEXTURES!!!

## New @deecovana account
- deecovana@gmail.com 

## 03.26 FUCK !!! GITHUB LFS error for @deecovan !!! Need to start NEW repo on NEW hosting !!!
- repository exceeded its LFS budget. The account responsible for the budget should increase it to restore access.
  - Rename repo to ADD-0326
  - Start new ADD repo

## 03.24 Major update: Added FOG!
- DarkSkyFog Scene and Environment changed
  - Background Energy 1.25
  - AmbientLight 2.0, Contribution 0.5
  - Tonemap ACES
  - Fog disabled
  - VFog enabled, all settings changed
  - CameraAttributes changed, Explosure 1.25
  - @TODO need to be enabled in @SETTINGS
- Camera and Light updated too:
  - Camera Far changed to 2000m
  - FOV 40
  - DOF Blur -1 (adaptive) 500m and FAR 1000m
- CameraGimbal script vars changed
  - MINs, MAXs, step, FOV, ZOOM etc
  - @TODO need to be enabled in @SETTINGS
- tagged @TAG shots

## 03.23 2x2.2_Curve1.002L and R ready, tested
- Curve1 starting part updated, exits added

## 03.23 Start implement Particles
- brake, bad

## 03.23 Major Improvements on Audio and Light
- Added Engines Bus with Reverb
  - Changed Output and Max values
- Changed DarkSky loops
  - Added Quadratic values
  - Added Energy values variables
  - Changed Export variables
- Changed RALLY2 Lights and Sounds
  - @TODO copy to RALLY and TRACK version

## 03.23 Try add Curve to 04 segment
- Add 2_Complex/Export/2x2.2_4_Curve
- Add 2_Complex/Export/2x2.2_Complex2
- Tested. Looks great!
- @BUG displaying Rear Gear

## 03.20
- Added COWL Rally2 car
  - Shorter for 5500's engine with 0.9 peak
  - Tested 161 kph 71th gear
- Added 2x2 2_Complex GLBs
- Modify COWL Track for 60fps
  - Tested track time 1:17

- Updated lights 
  - Tested 30 fps

## 03.17 Continue with HQ 1920x
- Appply the Vehicle3Ds physics_material_override values
- Use 60 fps
- Use shadows
- Apply FIXES in COWL.TRACK:
  - Vehicle Camera's positions and FOV's (MetaData)
  - Vehicle Reversing indicator (engine_index == 0 or REVERSE)
  - Vehicle Lights (Distance and Linear)
  - Global Light Explosure in timerLight.gd
- TRACK version tests: MORE STABLE Rear susp. is HARDER!!!
- Tagged @TAG COWL-TRACK: Tested: OK!

## 03.17 Add Spa City Short, Tested - Ok!
- Track
- Materials
- Objects
- Tested - Ok!

## 03-16 2x2 1km^2 square tested LOOKS GREAT!!!
- Manual merged branches: spiral and initial
- 03.16.26 Tested all tracks. Need MANUAL merge with INITIAL
  - Merged Spiral and Square(1km) into Merge
  - Merged into Initial
- COWL Long for TRACK 220 7th gear Tested

## 26.02.22 New car TT
- Regenerate Rally Square 
  - Add Snow 200m
  - Another generator
  - Tested
- Nash TT Rally looks GREAT!
  - Right cirle rally 06:26
- TT slowly on Spiral Rally +30 sec!!!

## Why physics are differenr on shaded/flat meshes?
- Ready to deploy assets for Rally.snow: 
  - Flat Smooth Mix 
- Need to understand:
  - Why physics are differenr on shaded/flat meshes?
- Leave Smooth and Mix (Flat road coverage) to test
  - Flat mountains are terrible
- Delete Snow Shaders and shader material
  - due to overpower
- Remake Snow Square 4x4 km

## Smooth models and Shader Materials
- Add High and Low settings and files
- Export 1st sector Smooth and test
- Modified files.high 
  - Set fric_slip=1.0 Because 60FPS and are more accurate
- Moved blender files to LFS

## 26.02.17 New Snows new Borders
- Added New Blender Landscapes and settings
- Added New GLBs 
- Tested borders 
  - Bumping and need tobe separate
- Added 3rd segment with borders
  - Up to 4km forward and back
  - 2:37, up to 170kph
- Fixed Restore function
- Tested Snow shader 
  - Need Smooth models

## 26.02.15 New repo ADD
- initial 80mb
- Improved UI
- Added submodule GodotAppData 
- Updated hotkey scripts
- Updated .godot files Low and High
- Added Snow Sand Square, and Rally with shader material
- Fixed Rear gear
- Cache cleared .godot deleted All 3 looks good on High 60 FPS

* Fix Snow track
  * res://Scenes/Tracks/Square/Materials/ice_material_3d.tres
  * Fixed One Start Half of SnowRally

* Start Ice track

# v4-6-add-free GitHub repo 

## 26.02.14 Restore trashed Git files
- Finished Cowl Rally setup
  - Toe in
  - Caster
  - Parts positions
  - Lights
- Prepare complete Ice Rally track

## 26.02.13 Restore trashed Git files
- Just try to restore after bad merge
- CowlTrack, Skies, tracks restored CowlRally bugged
- CowlRally restored
- Save project with High, noTAA and noTAAnoENVSHADOW

- Save Rally Cowl and Track as separate cars. 
- Test and modify Lights and Shadows
  - DarkSkyDark for Rally 600m 
  - Rally car
  - DarkSkyDark
- Gearbox and Curve optimized for 145-210 kph
- Tested Rally track, lell than 7 minutes long

## 26.02.12 Improve Rally 
- Update Cowl Rally suspension, geametry, gearbox, sound and:
  - Separate Run sounds Left and Right
  - Add Handbrake Rear wheels Friction demultiplier
  - Add separate L and R sound sources for Pow and Run
  - Add Cowl Wings to Rally
  - Update Suspension due to radious
  - Optimise Pow sounds using Accelerating and Scale
- Continue Square Base 300m 
  - Delete mountains 
  - Update ground Add cactuses and stones

## 26.02.11 Fixing and creating the Rally 
- Whats wrong with Wheels???

## 25.02.10 Collisions are broken in Godot
- Fixed with square and Boolea modifier

## 25.02.09 Normalize Lights for Cowls
- Enabed TAA and shadows 
- Normalized central and wheel lights

## 25.02.09 Slim note installed to work
- Clone repo
- Rename project and repo to 4.6
- Fix Shadow Blinkin: 
  - Set DirectionalLight3D shadow mode to Stable
- Merge branch squares into initial
- try to run 4.6
- Started, tested, saved
  - GPU usage 50% at 60 FPS with TAA Hull HD 1920x 
  - Looks Great!

# v4-51-add-free GitHub repo 

## 25.02.01 Cactuses
- Added New Mountains
  - Need more separate small mountains in each block
- Added Cactuses
  - Looks good

## 25.31.1 Add more Tiles
- Add New tiles to implement
  - Start refactor
  - Add Cental, Triways and missing elements Clean up
  - Clean up, delete Square 200
  - Add new elements to Square 300

- Finished Sky with Dynamic Sun
  - added Minimums
  - balanced sin/cos
  - seems like little error in light/sun rotation
  - updated Sun and Sky textures

## 25.30.1 Begin Squares 
- New 4m ground (decimate 50% from 1m) 
- New Forward Lines
- Tested 3km Forward with Sun
- Testing 7min. Corners track to add more Tiles
- Horsa Back 06:45

- Create LightTimer in DarkSky environment scene
  - Test and improve Light
- 1x1x200m with 3 materials seems
- Create proto 200m Height0 track
- Exported first group 
- Built first 2m base

## 25.29.1 Start Cource selector with Loader
- Pre-test Cowls cars on AirBag track 
  - Looks like similar timings
- Add AirBag and AirBack to loader
- Continue loader branch

## 25.29.1 Start Implement Settings 
- Added OnBoard cameras with C key switcher
- Updated Cowl cabine to use cameras
- Updated Cowl wheels to use Kamber and Toe
- Finished polishing Cowl Back
  - Cowl Back and Base tested, seems similar in time
- Added 4 Rams to Cowl Base
  - Tested for 1:09
  - Synchronized settings:
    - Curves
    - Wheels and rams
- Added Engine Mass and Inertia
- Applied Custom Forces to the CENTERS
- Tested similar Cowls: 1:05 both

## 25.28.1 New GearBox
- @NEW engine's gearbox coefficients applied to curve's values
  - Changed linear_velocity to local_velocity.z
  - @NEW s_scale_rpm to use new scaled values and curves
  - Calculated scale_RPM
  - Fixed Sixth Gear
  - Tested Cowl Base new GearBox
  - Cowl Back modified according to new gearbox

## 25.27.1
- Tested AirBag track 
- Update Horsa setup 1:00 RCR lap 
- Added New SkyMaps
- Added two Cowls (constructor) Base and Back versions
  - Base and Back versions
- Updated Cowl parts to begin Constructor
- Updated Cowls for 0.55 RCR

## 25.25.1
- New track U0 
- Horsa rebalanced for 3:30

## 25.20.1
- New Ran sounds
- Horsa Updated Scripts and Sounds
- Added Cup track
- Fixed REVERSING in Fanta and Horsa
- Horsa improved:
  - Collisions from boxes
  - Bounce 0.5 Rought
- Tab area updated: 
  - Added collision_timer to awoid doubles

## 25.19.1
- New Fanta values
- Added New SkyBoxes
- Added Kenney Industrial, Commercial and Suburban
- Placed Builds, Trees, Fences

## 25.19.1
- @TODO 
  - Fix Braking errors
  - Add OnTop and Glass fixed cameras
  - Add digital Gears and Speed
  - Try FakeWheels to get wheel Alpha

## 25.1.11 GearBox values
- Engine sound ready 
- Improved Tachometer
- Added Racing Wheel
- Added GearBox: 
  - Speed Map for Gears
  - Curve with ratios from gears
- Normalized Curve, Max.Speed, Gears 
- Added Brake and Accelerate pedals
- Added body rotation 
- Added Alpha Angle and Velocity 
  - Used linear_velocity transform.basis
- Finished with Alpha

- Implemented GearBox values
  - Indicator first
  - Sound second
  * Gearbox Physics maybe later

## Fixed Fanta for stability
- Changed COM
- Changed Gimbal speed
- Changed Steer Return speed

## 25.1.10 Improve Gimbal 
- Remove FOV changes
- Fix Initial on Minimum

## 25.1.7 Start Corner Cuts
- 30 min each as minimum
- 0.01 - 0.06 cm works good
- 2m width works good

## Add Car loader on Spa Short
1. Add Tab and TabArea on Spa Short
  - Use Collision Layer 2!
2. Test Cars 
  - Normalize but leave differences
  - All cars near 74.00 medium
  - Tested Cars beat 74.00
  - Spa Long on keyboard CHERO 3.59.53
- Add Car Loader
- Modify Tab to use sectors

## 26.1.5 Improve Spa Long and Chero 6600
- Update physics
  - Remove squared linear friction
  - lower Steering higher Coasting
- Improve Spa Short
  - Use chanks
  - Apply All 6600's cars 

## 26.1.1 bad day
- Add Alt-Control 
- Modify controls 
- Drop engine on braking starts
- Change redundant lerp to move_tovard
- Add Additional Forces: bodyLinearFric
- Test Alt-Control
- Checkout Horsa script
- Chero tested on Spa Long 
  - looks good

## 25.12.30 Steering by Mouse was bad idea
- Or i cant implement it to be well usable

## 25.12.30 New track Spa Full (Short and Long)
- Short 2400m
- Long 7700m
- Less banana's height
- Colored banana

## 25.12.30 New car Chero 6600 (need to work more)
- Bad faces, maybe need to rotate verticles normals
- Bad angles, somewhere looks loke damaged body
- Without glasses and radiator
- Godot cant use generated collision, why?

## 25.12.29 Horsa 6600 tuned for Spa 
- Placed to all tracks
- Physics, Drag and Air tuned for Spa

## 25.12.28 New car Horsa 6600
- Body in Red color
- Front and Rear Wheels
- Update UI and Loader overlays
- Update Gimbal
- Fix Fanta 6600 in Spa
  - Copy to Horsa
  - @FIXED ZC's AeroDrag force rotating
- Taged @TAG F6600-copy

## Fanta 6600 AeroDrag
- To deploy: ZC's AeroDrag
- Also try to use cY like cX
  - Testing Using AerDyn Force

## Fanta 6600 update 
- New Body
- New Wheels
  - Also for F3300
- New parameters
  - \_ready and \_process from F3300
  - New parameters for 1t\*1g

## Continue Loader
- Preload and instatiate scenes
* Select car

## Add One track without loader
- Add Thor track
- Change structure
- Test with Razval/Skhozhd

## New skies with Sun
- Add Sun into Sunlight 

## Add Menus and Buttons
- Check signals, names, labels
- Test sequences

## Try Chunk Terrain with HeightMapShape3D

## Next add one Scene with one Car
- Minimal (table) scene
- One Fanta500
- Dashboard
  - Move car Dashboard and log into the Vehicle
  - Leave track info UI into the scene

## Add Blank with Loader and Theme
- Create own Theme
- Free fonts
- Light colors, prefered white BG# ADD GitHub repo 
# ADD GitHub repo 
# ADD GitHub repo (CC4 2026)
"# ADD @deecovana GitHub repo New 03.26.26" 
