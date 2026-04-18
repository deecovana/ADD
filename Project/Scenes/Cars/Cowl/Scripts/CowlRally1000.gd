extends VehicleBody3D

var speedtometer_label
var REVERSE =  false

## Next values used for reconfiguring the Vehicle3Ds values
var car_bounce = 0.25
var car_rough = false
var car_absorb = false
var car_friction = 0.0

@export_category("Vehicle Constants")
## Values for curve Fanta_Curve_1000
## Real maximum 240 @!!!
@export var vehicle_mass = 1000.0
@export var MAX_POWER = 6600.0
@export var MAX_SPEED = 64.0
@export var grav_scale = 1.0

@export_category("Vector3 Centers")
## (-Z) value (meters) - Move Center Of Mass backward, (-Y): up
@export var CENTER_OF_MASS = Vector3(0.0,0.4,0.3)
@export var CENTER_OF_AERO = Vector3(0.0,0.8,-0.6)

## Additional Forces
@export_category("Body Aero")
## Reset standart values
var car_linear_damp = 0.0
var car_angular_damp = 0.0
## Setup AirDrag
@export var airDensity = 1.1
@export var bodySquare = 2.0
@export var bodySquareFill = 0.8
@export var bodyDrag = 1.2

## !!!> RALLY verssion
## Setup AirDynamic Force
@export var bodyAeroDyn = 0.8
## Add Linear Friction
## Constant and Linear friction 
@export var bodyLinearFricConst = 750.0
@export var bodyLinearFricLin = 7.5
## <!!! RALLY verssion

@export_category("Global Controler's speed")
## Control's move_toward speed
# Use 0..10 for keyboard or controller
# Use 100 for racing wheels
@export var control_speed = 5

@export_category("Steering")
## Maximum Steering angle in Radians
@export var MAX_STEER  = 0.5
## @NEW To Use speed steering value
@export var SPEED_STEER = true
## Speed Steer Koefficient
@export var SPEED_STEER_CO = 0.125
## Maximum Steering speed
@export var steer_control_speed = 1.4
@export var steer_restore_speed = 1.6
## Steering wheel visual rotation: 420deg / MAX_STEER
@export var rotate_wheel_sens_max = 320.0
var rotate_wheel_sens

@export_category("Braking")
@export var use_wheel_brake = true
## Maximum Braking speed
@export var brake_control_speed = 0.5
## Vehicle3D body braking force
## Applied with Use Wheel Brake = false
@export var vehicle_brake_force = 100.0
## Wheel3D braking force and balance
@export var wheel_brake_force = 100.0
## wheel_brake_force multiplier
@export var front_brake_force = 1.1
## wheel_brake_force multiplier
@export var rear_brake_force = 1.0
## Brake toward speed
@export var pedal_brake_speed = 1.25
## hand_brake_force multiplier
@export var hand_brake_force = 1.25

@export_category("Suspension")
## Next values used for reconfiguring the Wheel3Ds values

## Front wheels friction slip ratio ## 0.65
#@export var fric_slip_front = 1.0 
## Because of 60 FPS
@export var fric_slip_front = 1.1
## Because of 30 FPS
## Rear wheels friction slip ratio ## 0.65
#@export var fric_slip_rear = 1.0
## Because of 60 FPS
@export var fric_slip_rear = 1.1
## Because of 30 FPS

## Handbrake Rear wheels Friction demultiplier
@export var fric_slip_rear_hb_mult = 1.75
## Relax must higher than Compression 

## Rest, Travel, Stiff, MaxV
## !!!> RALLY version
@export var damp_compr_front = 2.0
@export var damp_relax_front = 2.5
@export var damp_compr_rear = 2.0
@export var damp_relax_rear = 2.5
@export var rest_front = 0.24
@export var rest_rear = 0.26
@export var travel_front = 0.34
@export var travel_rear = 0.40
@export var stiff_front = 45
@export var stiff_rear = 36
@export var max_force_front = 18000
@export var max_force_rear = 14000
## <!!! RALLY version

@export_category("Coasting")
## Coasting starting value
@export var coast_init = 0.4
## Coasting lerp speed
@export var engine_coast = 0.1

@export_category("GearBox States and values")
@export var scale_curve: Curve
## UI's Scale graph curve values
var scale_array : Array
## Engine Inertia value must be calculated from MAX_POWER etc.
@export var engine_inertia_value = 0.15
## GearBox states and values 
enum States { ACCELERATING, BRAKING, COASTING, REVERSING, CHILLING}
@export var engine_state: States = States.CHILLING
enum Indices { Rear, Neutral, 
	First, Second, Third, Fourth, Fifth, Sixth, 
	Seventh, Eighth, Ninth, Tenth, Infinity }
@export var engine_index: Indices = Indices.Neutral

## Arrays for Settings

## 1. Long for TRACK
# var engine_index_up = [-1.0, 0.0, 1.0, 
	# 60.0, 110.0, 150.0, 170.0, 180.0, 200.0, 220.0, 
	# 300.0, 300.0, 300.0, 300.0, 300.0]
# var engine_index_down = [-1.0, 0.0, 1.0, 
	# 55.0, 105.0, 145.0, 165.0, 175.0, 195.0, 205.0, 
	# 300.0, 300.0, 300.0, 300.0, 300.0]
# var eng_min_rpm = [         0.20, 0.5,
	# 0.20, 0.40, 0.425, 0.45, 0.475, 0.50, 0.50, 
	# 1.0, 1.0, 1.0, 1.0, 1.0, ]
	
## 2. Short for 200 9 gears (rally+)
#var engine_index_up = [-1.0, 0.0, 1.0, 
	#50.0, 90.0, 130.0, 160.0, 185.0, 205.0, 
	#220.0, 230.0, 240.0, 300.0, 300.0, 300.0]
#var engine_index_down = [-1.0, 0.0, 1.0, 
	#40.0, 80.0, 120.0, 150.0, 175.0, 195.0, 
	#210.0, 220.0, 230.0, 299.0, 299.0, 299.0]
#var eng_min_rpm = [         0.30, 0.0,
	#0.30, 0.40, 0.50, 0.60, 0.66, 0.70, 
	#0.70, 0.70, 0.70, 0.70, 0.70, 0.70]
## 3. Short for 240 6 gears (rally)
#var engine_index_up = [-1.0, 0.0, 1.0, 
	#50.0, 100.0, 140.0, 180.0, 210.0, 240.0, 
	#300.0, 300.0, 300.0, 300.0, 300.0, 300.0]
#var engine_index_down = [-1.0, 0.0, 1.0, 
	#40.0, 90.0, 130.0, 170.0, 200.0, 220.0, 
	#240.0, 299.0, 299.0, 299.0, 299.0, 299.0]
#var eng_min_rpm = [         0.30, 0.0,
	#0.30, 0.40, 0.50, 0.55, 0.60, 0.65, 
	#0.70, 0.70, 0.70, 0.70, 0.70, 0.70]
	
## 3. Short for 160 6th gear (rally 1000) Tested
var engine_index_up = [-1.0, 0.0, 1.0, 
	50.0, 80.0, 110.0, 130.0, 145.0, 160.0, 
	170.0, 180.0, 300.0, 300.0]
var engine_index_down = [-1.0, 0.0, 1.0, 
	40.0, 60.0, 90.0, 115.0, 135.0, 150.0, 
	165.0, 175.0, 300.0, 300.0]
var eng_min_rpm = [    0.25, 0.0,
	0.40, 0.45, 0.49, 0.53, 0.55, 0.62, 
	0.68, 0.68, 1.00, 1.00]

## 4. Shorter for 5500's engine with 0.9 peak (RALLY2)
# 140 7th gear (rally 2) Tested
# var engine_index_up = [-1.0, 0.0, 1.0, 
	# 50.0, 80.0, 105.0, 115.0, 125.0, 135.0, 
	# 170.0, 180.0, 300.0, 300.0]
# var engine_index_down = [-1.0, 0.0, 1.0, 
	# 45.0, 75.0, 100.0, 110.0, 120.0, 130.0, 
	# 165.0, 175.0, 300.0, 300.0]
# var eng_min_rpm = [    0.25, 0.0,
	# 0.40, 0.45, 0.49, 0.53, 0.56, 0.56, 
	# 0.68, 0.68, 1.00, 1.00]


#############################################
## -- FROM THIS LINE must be imlpemented as CLASS -- ##
#############################################

var eng_ind_rpm = [] ## calculated from engine_index.max()
var s_scale_rpm = 1.0

## OnReady variables
var acceleration_power = 0.0
var matching_power = 0.0
var ACCELERATING = 0.0
var linear_vel = 0.0

var scene: Node3D
var UI: MarginContainer
var Analometer: Control
var rem_linear_velocity = Vector3.ZERO
var cam: Camera3D
var cam1: Marker3D
var cam2: Marker3D
var cam3: Marker3D
var gimbal = Node3D
enum CamStates {Gimbal, Cam1, Cam2, Cam3}
var cam_state: CamStates

func _ready() -> void:
	scene = get_parent()
	cam = $Cam
	cam1 = $Cam1
	cam2 = $Cam2
	cam3 = $Cam3
	gimbal = scene.find_child("CameraGimbal")
	cam_state = CamStates.Gimbal
	
	UI = $UI
	Analometer = UI.get_analometer()
	rotate_wheel_sens = (rotate_wheel_sens_max
		/ rad_to_deg(MAX_STEER))
	
	## Setup Vehicle3D values
	mass = vehicle_mass
	gravity_scale = grav_scale
	linear_damp = car_linear_damp
	angular_damp = car_angular_damp
	
	## Appply the Vehicle3Ds "physics_material_override" values
	# 1. Create a new material instance
	var pmo_values = PhysicsMaterial.new()
	# 2. Configure properties
	pmo_values.friction = car_friction
	pmo_values.rough = car_rough
	pmo_values.bounce = car_bounce
	pmo_values.friction = car_friction
	# 3. Apply the override
	physics_material_override = pmo_values
	
	## Setup Wheel3Ds Front and Rear values
	## Grip
	$Wheel3DFL.wheel_friction_slip = fric_slip_front
	$Wheel3DFR.wheel_friction_slip = fric_slip_front
	$Wheel3DRL.wheel_friction_slip = fric_slip_rear
	$Wheel3DRR.wheel_friction_slip = fric_slip_rear
	### Damper
	$Wheel3DFL.damping_compression = damp_compr_front
	$Wheel3DFR.damping_compression = damp_compr_front
	$Wheel3DRL.damping_compression = damp_compr_rear
	$Wheel3DRR.damping_compression = damp_compr_rear
	$Wheel3DFL.damping_relaxation = damp_relax_front
	$Wheel3DFR.damping_relaxation = damp_relax_front
	$Wheel3DRL.damping_relaxation = damp_relax_rear
	$Wheel3DRR.damping_relaxation = damp_relax_rear
	### Rest
	$Wheel3DFL.wheel_rest_length = rest_front
	$Wheel3DFR.wheel_rest_length = rest_front
	$Wheel3DRL.wheel_rest_length = rest_rear
	$Wheel3DRR.wheel_rest_length = rest_rear
	### Travel
	$Wheel3DFL.suspension_travel = travel_front
	$Wheel3DFR.suspension_travel = travel_front
	$Wheel3DRL.suspension_travel = travel_rear
	$Wheel3DRR.suspension_travel = travel_rear
	### Stiffness
	$Wheel3DFL.suspension_stiffness = stiff_front
	$Wheel3DFR.suspension_stiffness = stiff_front
	$Wheel3DRL.suspension_stiffness = stiff_rear
	$Wheel3DRR.suspension_stiffness = stiff_rear
	### Maximum Suspension force
	$Wheel3DFL.suspension_max_force = max_force_front
	$Wheel3DFR.suspension_max_force = max_force_front
	$Wheel3DRL.suspension_max_force = max_force_rear
	$Wheel3DRR.suspension_max_force = max_force_rear

	
	## Set Center of Mass from CenterOfMass Node
	## Move it Forward to oversteer
	## Backward for understeer but less rear slip
	center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = CENTER_OF_MASS
	## Set Continuous Collision Detection
	continuous_cd = true
	
	## @NEW Engine Index RPM to use
	for rpm in engine_index_up:
		var calc_rpm = MAX_SPEED * 3.6 / rpm
		if calc_rpm > 1 and calc_rpm < 10:
			eng_ind_rpm.append(calc_rpm)
			## Calculate Min.RPM OR use predefined array
			#eng_min_rpm.append(eng_ind_rpm.max()/calc_rpm)
	
	Analometer.set_min_tac(Analometer.get_min_rad()) 
	Analometer.set_min_rot(Analometer.get_min_rad()) 
	Analometer.set_max_tac(Analometer.get_max_rad() * 0.5) ## double max
	Analometer.set_max_rot(MAX_POWER)
	## Init PFG screen
	for i in 100:
		scale_array.append(scale_curve.sample_baked(i/100.0))
	UI.call_draw_curve(scale_array)
	
func _physics_process(delta: float) -> void:
	## Switch Lights
	if Input.is_action_just_pressed("lightsFar"):
		$FarLigh.visible = !$FarLigh.visible
	if Input.is_action_just_pressed("lightsClose"):
		$CloseLightLeft.visible = !$CloseLightLeft.visible
		$CloseLightRight.visible = !$CloseLightRight.visible
	if Input.is_action_just_pressed("lightsAll"):
		$FarLigh.visible = !$FarLigh.visible
		$CloseLightLeft.visible = !$CloseLightLeft.visible
		$CloseLightRight.visible = !$CloseLightRight.visible
		
	## Change active camera onboard/gimbal State Machine
	if Input.is_action_just_pressed("cameras"):
		var fov = cam.fov
		if cam_state == CamStates.Gimbal:
			cam_state = CamStates.Cam1
			fov = cam1.get_meta("FOV")
			cam.fov = fov
			cam.position = cam1.position
			cam.rotation = cam1.rotation
			gimbal.camera.current = false
			cam.current = true
		elif cam_state == CamStates.Cam1:
			cam_state = CamStates.Cam2
			fov = cam2.get_meta("FOV")
			cam.fov = fov
			cam.position = cam2.position
			cam.rotation = cam2.rotation
			gimbal.camera.current = false
			cam.current = true
		elif cam_state == CamStates.Cam2:
			cam_state = CamStates.Cam3
			fov = cam3.get_meta("FOV")
			cam.fov = fov
			cam.position = cam3.position
			cam.rotation = cam3.rotation
			gimbal.camera.current = false
			cam.current = true
		else:
			cam_state = CamStates.Gimbal
			cam.current = false
			gimbal.camera.current = true
			
	linear_vel = abs(get_local_velocity().z)
	var alt_control = Input.is_action_pressed("alt_control")
	var steer_control_speed_ = steer_control_speed
	if alt_control:
		steer_control_speed_ = steer_control_speed / 2
	
	## Reverse in the simpliest way
	if Input.is_action_just_pressed("reverse"):
		REVERSE = !REVERSE
	
	## To Use speed steering value 
	## @NEW with Alternative Control
	var m_MAX_STEER = MAX_STEER
	if SPEED_STEER and not alt_control:
		m_MAX_STEER = (MAX_SPEED / linear_vel) \
						* SPEED_STEER_CO * MAX_STEER
		m_MAX_STEER = clamp(m_MAX_STEER, 0.0, MAX_STEER)
	## @NEW add m_MAX steering speed modifier
	var m_MAX = m_MAX_STEER / MAX_STEER
	
	## Use controller's axes, joy or key input
	var _steering = Input.get_axis("steer_right", "steer_left") * m_MAX_STEER
	var _ACCELERATING = Input.get_axis("brake", "accelerate")
	## Simulate axes if keys are used
	if Input.is_action_pressed("steer_right")\
		or Input.is_action_pressed("steer_left"):
			steering = move_toward(steering, _steering, 
			steer_control_speed_ * delta * m_MAX)
	## @NEW Using Alt Control
	elif not alt_control: 
		## Move linearly
		steering = move_toward(steering, 0.0 , 
			steer_control_speed_ * delta * m_MAX * steer_restore_speed)
	## Using Brake
	if Input.is_action_pressed("brake"):
		if ACCELERATING > 0: ACCELERATING = 0
		ACCELERATING = move_toward(ACCELERATING, _ACCELERATING, 
			brake_control_speed * control_speed * delta)
	elif Input.is_action_pressed("accelerate"):
		ACCELERATING = move_toward(ACCELERATING, _ACCELERATING, 
			control_speed * delta)
	else:
		_ACCELERATING = move_toward(_ACCELERATING, 0.0, 
			control_speed * delta)
		ACCELERATING = move_toward(ACCELERATING, 0.0, 
			control_speed * delta)
								   
	## Set acceleration state @CHANGED
	if _ACCELERATING > 0:
		engine_state = States.ACCELERATING
	## Else: Braking key
	elif _ACCELERATING < 0:
		if engine_state != States.BRAKING:
			## Decrease engine power on state changed
			engine_force = engine_force * coast_init
		engine_state = States.BRAKING
		
	## Else: Coasting 
	else: 
		if engine_state != States.COASTING:
			## Decrease engine power on state changed
			engine_force = engine_force * coast_init
		engine_state = States.COASTING
	
	## Chilling state is Accelerating with Power 0 and speed near 0
	if (abs(linear_vel) < 1.0
		and engine_state != States.BRAKING):
		engine_state = States.CHILLING
		
	## Braking
	var print_brake_force = 0.0
	if engine_state == States.BRAKING:
		## Slow engine USING LERP!
		engine_force = lerp(engine_force, 0.0, control_speed * delta)
		## Braking with Vehicle3D
		if not use_wheel_brake:
			var set_vehicle_brake_force = - (
				ACCELERATING * vehicle_brake_force )
			change_vehicle_brake(set_vehicle_brake_force, delta)
			print_brake_force = set_vehicle_brake_force
		## Braking with Wheels
		else:
			var set_wheel_brake_force = - (
				ACCELERATING * vehicle_brake_force )
			change_wheel_brake(set_wheel_brake_force, 
				front_brake_force, rear_brake_force)
			print_brake_force = set_wheel_brake_force
	else: 
		change_vehicle_brake(0.0, delta)
		change_wheel_brake(0.0, 0.0, 0.0)
		
	## Coasting next
	if engine_state == States.COASTING:
		## Engine coasting toward down USING LERP!
		engine_force = lerp(engine_force, 0.0, engine_coast * delta)

	## Calculate custom forces
	## AeroDragfric_
	var aeroDrag_force_applied: Vector3 = (- linear_velocity.normalized()) * (
		( bodyDrag * airDensity * bodySquare * bodySquareFill )
		* linear_velocity.length_squared())
	## AeroDynamic 
	var aeroDyn_force_applied: Vector3 = Vector3.DOWN * (
		bodyAeroDyn * linear_velocity.length_squared())
	## LinearFriction Force
	var constFricForse = 0.0
	if linear_vel > 0.01: 
		constFricForse = bodyLinearFricConst
	var linearFric_force_applied:Vector3 = (
		- linear_velocity.normalized() * 
		( constFricForse
		+ bodyLinearFricLin * linear_vel
		))
	
	## Apply Custom Forces to the CENTERS!
	apply_central_force(aeroDrag_force_applied)
	apply_central_force(linearFric_force_applied)
	apply_central_force(aeroDyn_force_applied)

	## Using HandBrake at any time
	if Input.is_action_pressed("handbrake"):
		## Function?
		var set_brake_force = \
			hand_brake_force * vehicle_brake_force
		if use_wheel_brake:
			## Now using handbrake rear friction multiplier
			set_fric_slip_rear(fric_slip_rear / fric_slip_rear_hb_mult)
			change_wheel_brake(set_brake_force, 
				front_brake_force, rear_brake_force)
		else:
			change_vehicle_brake(set_brake_force, delta)
	else: 
		## Now restore handbrake rear friction
		set_fric_slip_rear(fric_slip_rear)
		
	## @TODO move to function!!! GearBox switcher
	## If not playing switching sound
	engine_index = get_engine_index((linear_vel))
	## @NEW engine's gearbox coefficients applied to curve's values
	## Prepare vars
	## For current index, get curve's Y value using RPM as X
	## Speed evaluates in (0 < (speed - ind_low) < (speed - ind_cur) < 1)
	var speed_cur = linear_vel * 3.6 ## kph
	var s_start = engine_index_up[engine_index]
	var s_final = engine_index_up[engine_index + 1]
	## @NEW s_scale_rpm to use new scaled values and curves
	var s_scale_rpm_normal = (
		speed_cur - s_start) / (s_final - s_start) ## up from 0 to 1
	## Get final RPM from normalized
	## First get minimum RPM for the current gear
	## Calculate Min.RPM OR use predefined array
	#var s_scale_rpm_min = (eng_min_rpm.max() + eng_min_rpm[eng_ind]) / \
		#(eng_min_rpm.max() * 2)
	var s_scale_rpm_min = eng_min_rpm[engine_index]
	## Second calculate scale_RPM
	## Using inertial moving
	var s_scale_rpm_moving = s_scale_rpm_min + s_scale_rpm_normal * (1.0 - s_scale_rpm_min)
	## Fix Inf bug
	s_scale_rpm_moving = clamp(s_scale_rpm_moving, 0.0, 1.0)
	s_scale_rpm = lerp(s_scale_rpm, s_scale_rpm_moving, engine_inertia_value)
	## @FINAL Update engine_force using RPM
	engine_force = scale_curve.sample_baked(s_scale_rpm) * MAX_POWER * ACCELERATING


	## Update UI visuals
	UI.set_speedometer_label(
		"%8s:%8s" % [
			States.keys()[engine_state], 
			Indices.keys()[engine_index]]
		)
	
	if false and !scene.DEBUG_SHOW: ## Forced output
		UI.logs_clr_text()
		UI.logs_add_text("\n SPEED.Z(speed_cur): %6.2f" % speed_cur)
		UI.logs_add_text("\n engine_force......: %8.2f" % engine_force)
		UI.logs_add_text("\n rpm_moving.: %8.2f" % engine_force)
		UI.logs_add_text("\n s_scale_rpm: %8.2f" % s_scale_rpm)
		UI.show_info()
		
	## Reverse last
	# Set Reverse, Update, Neutral, Drive[x] Gear
	var engine_index_text
	if engine_index == 0 or REVERSE:
		engine_index_text = 'R'
		
		## @FIX RESTORED Reverse processing 
		engine_state = States.REVERSING
		#Limit REVERSE
		if abs(speed_cur) > engine_index_down[3]:
			engine_force = 0
		## Else Rear Gear has 50% of maximum power
		else:
			engine_force = - clamp(abs(engine_force), 0, MAX_POWER * 0.5)

	elif engine_index == 1:
		engine_index_text = 'N'
	else:
		engine_index_text = str(engine_index - 1)
	UI.set_digital_speed(str(roundi(speed_cur)))
	UI.set_digital_gear(engine_index_text)
	
	rotate_speed_pt(linear_vel * 3.6)
	rotate_speed_ps(get_delta_velocity(delta), delta)
	
	rotate_tacho_pt(s_scale_rpm)
	rotate_tacho_ps(abs(engine_force))
	rotate_wheel()
	set_brake_pedal(print_brake_force)
	set_accelerate_pedal(ACCELERATING * 100)
	var loc_vel = get_local_velocity()
	var deg_vel = rad_to_deg(loc_vel.angle_to(-Vector3.FORWARD))
	set_rotate_alpha(angular_velocity.y, deg_vel, abs(loc_vel.x))

func set_fric_slip_rear(_fric_slip_rear) -> void:
	$Wheel3DRL.wheel_friction_slip = _fric_slip_rear
	$Wheel3DRR.wheel_friction_slip = _fric_slip_rear

## Apply Vehicle Brake toward
func change_vehicle_brake(brake_force, delta) -> void:
	brake = move_toward(brake, brake_force, brake_control_speed * delta)

## Apply Wheels Brake toward
## Using HandBrake
func change_wheel_brake(brake_force, front_brake_power, \
	rear_brake_power) -> void:
	$Wheel3DFL.brake = brake_force * front_brake_power
	$Wheel3DFR.brake = brake_force * front_brake_power
## Using HandBrake at any time don't remove acceleration
	if engine_state != States.ACCELERATING:
		$Wheel3DRL.brake = brake_force * rear_brake_power
		$Wheel3DRR.brake = brake_force * rear_brake_power

func engine_match_power(input_speed:float, match_curve:Curve) -> float:
		var normalized_speed = input_speed / MAX_SPEED
		var match_power = match_curve.sample_baked(normalized_speed) \
			* MAX_POWER
		return match_power

## Get Engine Index accordong to GearBox Values
func get_engine_index(current_speed: float) -> int:
	var current_index = engine_index
	var speed_index := 0
	var i := 0
	if engine_state == States.REVERSING:
		speed_index = 0
	elif engine_state == States.ACCELERATING:
		for spd in engine_index_up:
			if (current_speed * 3.6) > spd: 
				speed_index = i
			i += 1
	else:
		for spd in engine_index_down:
			if (current_speed * 3.6) > spd: 
				speed_index = i
			i += 1
	## If GearBox switching sound is not playing
	if $Gear.playing:
		speed_index = current_index
	return speed_index

func rotate_speed_pt(speedf: float) -> void:
	var speedr = 0.0
	var min_rad = Analometer.get_min_rad() 
	var max_rad = Analometer.get_max_rad() 
	var max_spd = Analometer.get_max_spd()
	speedr = min_rad + (
		(max_rad-min_rad) / max_spd
		) * speedf
	Analometer.rotate_speed_pt(speedr)
	
func rotate_speed_ps(deltavf: float, delta) -> void:
	var deltavr = 0.0
	var min_rad = Analometer.get_min_rad() 
	var max_rad = Analometer.get_max_rad() 
	var max_dev = Analometer.get_max_dev() 
	var speed_ps = Analometer.get_speed_ps() 
	deltavr = min_rad + (
		(max_rad - min_rad) / max_dev
		) * deltavf
	Analometer.rotate_speed_ps(
		lerp(speed_ps, deltavr, delta * control_speed))
	
func rotate_tacho_pt(tacerpm: float) -> void:
	var tachor = 0.0
	var min_rad = Analometer.get_min_rad() 
	var max_rad = Analometer.get_max_rad() 
	var max_tac = Analometer.get_max_tac() 
	tachor = min_rad + (
		max_rad - min_rad) * (tacerpm / max_tac)
	Analometer.rotate_tacho_pt(tachor)
		
func rotate_tacho_ps(tacwrpm: float) -> void:
	var tachor = 0.0
	var min_rad = Analometer.get_min_rad() 
	var max_rad = Analometer.get_max_rad() 
	var max_rot = Analometer.get_max_rot() 
	tachor = min_rad + (
		max_rad - min_rad) * (tacwrpm / max_rot)
	Analometer.rotate_tacho_ps(tachor)
	
func rotate_wheel() -> void:
	UI.rotate_wheel(-steering * rotate_wheel_sens)

func get_delta_velocity(delta) -> float:
	## Remember last velocity
	var rem_vel = rem_linear_velocity
	rem_linear_velocity = linear_velocity
	var cur_vel = linear_velocity
	## Gat Vector diff
	var delta_vel = cur_vel - rem_vel
	return (delta_vel.length() * 3.6) / delta
	
func randomis(v: Vector3, mult) -> Vector3:
	return v + mult * Vector3(
		(randf()-0.49)/10,(randf()-0.49)/10,(randf()-0.49)/10)

func set_brake_pedal(val) -> void:
	UI.set_brake_pedal(val)
	
func set_accelerate_pedal(val) -> void:
	UI.set_accelerate_pedal(val)
	
func set_rotate_alpha(rot_y: float, deg_vel: float, loc_vel: float) -> void:
	var print_ry = ""
	var values = -rot_y * 3
	for i in int(abs(values)+1):
		if values < 0:
			print_ry += "<"
		else:
			print_ry += ">"
	UI.set_rotate_alpha(rot_y, print_ry, "%2.1fd(%2.1f)" % [deg_vel, loc_vel])
	
func get_local_velocity() -> Vector3:
	var global_velocity = linear_velocity 
	# Or body.linear_velocity for RigidBody
	# Using transform.basis.inverse() to transform from global to local space
	var local_velocity = transform.basis.inverse() * global_velocity
	# Alternatively, for 3D, you can use the transposed basis (since it's orthogonal)
	# var local_velocity = transform.basis.transposed() * global_velocity
	## print("Global Velocity: ", global_velocity)
	## print("Local Velocity (Local X, Y, Z): ", local_velocity)
	# local_velocity.z would be forward/backward relative to the object
	# local_velocity.x would be left/right
	# local_velocity.y would be up/down (if not relying purely on global Y)
	return local_velocity
