extends VehicleBody3D

var speedtometer_label
var REVERSE =  false

## Next values used for reconfiguring the Vehicle3Ds values
var car_bounce = 0.5
var car_rough = false
var car_absorb = false
var car_friction = 0.0

@export_category("Vehicle Constants")
## Values for curve Fanta_Curve_1000
## Real maximum 240 @!!!
@export var vehicle_mass = 1000.0
@export var MAX_POWER = 6600.0
@export var MAX_SPEED = 65.0
@export var grav_scale = 1.0

@export_category("Vector3 Centers")
## (-Z) value (meters) - Move Center Of Mass backward, (-Y): up
@export var CENTER_OF_MASS = Vector3(0.0,0.0,0.33)
@export var CENTER_OF_AERO = Vector3(0.0,0.3333,0.33)

## Additional Forces
@export_category("Body Aero")
## Reset standart values
var car_linear_damp = 0.0
var car_angular_damp = 0.0
## Setup AirDrag
@export var airDensity = 1.1
@export var bodySquare = 2.0
@export var bodySquareFill = 0.8
@export var bodyDrag = 1.25
## Setup AirDynamic Force
@export var bodyAeroDyn = 0.4

## Add Linear Friction
## Constant and Linear friction
@export var bodyLinearFricConst = 1200.0
@export var bodyLinearFricLin = 12.0
## Squared friction ## 0.0 Because AroDrag used
@export var bodyLinearFricSq = 0.0 ## 0.05

@export_category("Control's move speed")
## Control's move_toward speed
# Use 0..10 for keyboard or controller
# Use 100 for racing wheels
@export var control_speed = 3.3

@export_category("Steering Values")
## Maximum Steering angle in Radians
@export var MAX_STEER  = 0.35
## @NEW To Use speed steering value
@export var SPEED_STEER = true
## Speed Steer Koefficient
@export var SPEED_STEER_CO = 0.133
## Maximum Steering speed
@export var steer_control_speed = 0.75
@export var steer_restore_speed = 1.5
## Steering wheel visual rotation: 420deg / MAX_STEER
@export var rotate_wheel_sens_max = 320.0
var rotate_wheel_sens

@export_category("Braking Values")
@export var use_wheel_brake = true
## Maximum Braking speed
@export var brake_control_speed = 0.5
## Vehicle3D body braking force
## Applied with Use Wheel Brake = false
@export var vehicle_brake_force = 150.0
## Wheel3D braking force and balance
@export var wheel_brake_force = 150.0
## wheel_brake_force multiplier
@export var front_brake_force = 1.1
## wheel_brake_force multiplier
@export var rear_brake_force = 0.9
## Brake toward speed
@export var pedal_brake_speed = 1.5
## hand_brake_force multiplier
@export var hand_brake_force = 2.0

@export_category("Coasting")
## Coasting starting value
@export var coast_init = 0.4
## Coasting lerp speed
@export var engine_coast = 0.1

@export_category("Suspension")
## Next values used for reconfiguring the Wheel3Ds values
## Front wheels friction slip ratio ## 0.65
@export var fric_slip_front = 1.3 ## Because its like a Soap on U track!
## Rear wheels friction slip ratio ## 0.65
@export var fric_slip_rear = 1.4 ## Because its like a Soap on U track!
## @HACK Acceleration multiplier for rear slip. Used if NOT accelerating.
@export var fric_slip_rear_hb_mult = 1.8
## Relax must higher than Compression 
@export var damp_compr_front = 6.0
@export var damp_relax_front = 4.0
@export var damp_compr_rear = 4.0
@export var damp_relax_rear = 3.0
## Rest, Travel, Stiff, MaxV
@export var rest_front = 0.10
@export var rest_rear = 0.12
@export var travel_front = 0.12
@export var travel_rear = 0.16
@export var stiff_front = 65
@export var stiff_rear = 55
@export var max_force_front = 6500
@export var max_force_rear = 5500

@export var scale_curve: Curve
var scale_array : Array

@export_category("States and gears")
enum States { ACCELERATING, BRAKING, COASTING, REVERSING, CHILLING}
@export var engine_state: States = States.CHILLING
enum Indices {Rear, Neutral, 
	First, Second, Third, Fourth, Fifth, Sixth, Infinity}
@export var engine_index: Indices = Indices.Neutral
var engine_index_up = [-1.0, 0.0, 
	1.0, 60.0, 120.0, 160.0, 200.0, 220.0, 260.0]
var engine_index_down = [-1.0, 0.0, 
	1.0, 50.0, 110.0, 150.0, 190.0, 210.0, 250.0]
var acceleration_power = 0.0
var matching_power = 0.0
var ACCELERATING = 0.0
var eng_ind_rpm = []
var scale_rpm = 1.0

var root: Node3D
var UI: CanvasLayer
var Analometer: Control
var rem_linear_velocity = Vector3.ZERO

func _ready() -> void:
	UI = $UI
	Analometer = UI.get_analometer()
	rotate_wheel_sens = (rotate_wheel_sens_max
		/ rad_to_deg(MAX_STEER))
	
	## Setup Vehicle3D values
	mass = vehicle_mass
	gravity_scale = grav_scale
	linear_damp = car_linear_damp
	angular_damp = car_angular_damp
	
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

	Analometer.set_min_tac(Analometer.get_min_rad()) 
	Analometer.set_max_tac(Analometer.get_max_rad() / eng_ind_rpm.max())
	Analometer.set_min_rot(Analometer.get_min_rad()) 
	Analometer.set_max_rot(MAX_POWER)
	## Init PFG screen
	for i in 100:
		scale_array.append(scale_curve.sample_baked(i/100.0))
	UI.call_draw_curve(scale_array)
	
func _physics_process(delta: float) -> void:
	## @NEW using Alternative Control
	## @TODO add boolean to settings
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
		m_MAX_STEER = (MAX_SPEED / linear_velocity.length()) \
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
	if (abs(linear_velocity.length()) < 1.0
		and engine_state != States.BRAKING):
		engine_state = States.CHILLING

	## Process Engine States
	## ACCELERATING first
	if (engine_state == States.ACCELERATING or 
		engine_state == States.CHILLING):
		acceleration_power = MAX_POWER * ACCELERATING
		## Remove REVERSE
		engine_force = abs(engine_force)
		## Match force to scale_curve
		matching_power = engine_match_power(
			linear_velocity.length(), scale_curve)
		## Apply ACCELERATING USING LERP!
		engine_force = lerp(
			engine_force, 
			clamp(matching_power, 0, matching_power), 
			control_speed * delta) 
		## Apply REVERSE
		if REVERSE:
			engine_force = -abs(engine_force)
		
	## Than Braking
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
	## AeroDrag
	var aeroDrag_force_applied: Vector3 = (- linear_velocity.normalized()) * (
		( bodyDrag * airDensity * bodySquare * bodySquareFill )
		* linear_velocity.length_squared())
	## AeroDynamic 
	var aeroDyn_force_applied: Vector3 = Vector3.DOWN * (
		bodyAeroDyn * linear_velocity.length_squared())
	## @NEW LinearFriction Force
	var constFricForse = 0.0
	if linear_velocity.length() > 0.01: 
		constFricForse = bodyLinearFricConst
	var linearFric_force_applied:Vector3 = (
		- linear_velocity.normalized() * 
		( constFricForse
		+ bodyLinearFricLin * linear_velocity.length()
		+ bodyLinearFricSq * linear_velocity.length_squared()))
	
	## Apply Custom Forces
	apply_central_force(aeroDrag_force_applied)
	apply_force(aeroDyn_force_applied, CENTER_OF_AERO)
	apply_central_force(linearFric_force_applied)

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
		
	## Update Engine Index
	engine_index = get_engine_index((linear_velocity.length()))
	## Update RPM value
	var eng_ind = clamp(engine_index-2, 0, eng_ind_rpm.size()-1)
	scale_rpm = 1.0 + ( 2.0 * ## Why?
		(linear_velocity.length()  / MAX_SPEED)
		* (eng_ind_rpm[eng_ind] / eng_ind_rpm.max())
	)
	## @NeW try to use RPM as engine_force !IT WORKS!
	engine_force = scale_curve.sample_baked((
		scale_rpm - 1.0)) * MAX_POWER * ACCELERATING
		
	## Reverse last
	if REVERSE:
		engine_state = States.REVERSING
		## Rear Gear has 30% of maximum power
		engine_force = - clamp(abs(engine_force), 0, MAX_POWER * 0.3)

	## Update UI
	UI.set_speedometer_label(
		"%8s:%8s" % [
			States.keys()[engine_state].substr(0,8), 
			Indices.keys()[engine_index].substr(0,8)]
		)
	rotate_speed_pt(linear_velocity.length() * 3.6)
	rotate_speed_ps(get_delta_velocity(delta), delta)
	
	rotate_tacho_pt(scale_rpm - 1)
	rotate_tacho_ps(abs(engine_force))
	rotate_wheel()
	set_brake_pedal(print_brake_force)
	set_accelerate_pedal(ACCELERATING * 100)
	var loc_vel = get_local_velocity()
	var deg_vel = rad_to_deg(loc_vel.angle_to(-Vector3.FORWARD))
	set_rotate_alpha(angular_velocity.y, deg_vel, abs(loc_vel.x))
	
	## @DEBUG UI logs
	UI.logs_clr_text()
	UI.logs_add_text("\n Horsa 1000")
	UI.logs_add_text("\n ACCELERATING.: %6.2f" % ACCELERATING)
	UI.logs_add_text("\n Braking......: %6.2f" % print_brake_force)
	UI.logs_add_text("\n Linear Veloc.: %8.2f" % linear_velocity.length())
	UI.logs_add_text("\n Spd.Max Steer: %8.2f" % m_MAX_STEER)
	UI.logs_add_text("\n Steering.....: %8.2f" % steering)
	UI.logs_add_text("\n engine_force.: %8.2f" % engine_force)
	UI.logs_add_text("\n aeroDrag_appl: %8.2f" % aeroDrag_force_applied.length())
	UI.logs_add_text("\n aeroDyn_appl.: %8.2f" % aeroDyn_force_applied.length())
	UI.logs_add_text("\n linearFricApp: %8.2f" % linearFric_force_applied.length())
	
	## Car fell off course!
	if position.y < -50:
		UI.show_message("Car is out! Reload with [F5]")
		
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
func get_engine_index(_speed: float) -> int:
	var speed_index := 0
	var i := 0
	if engine_state == States.REVERSING:
		speed_index = 0
	elif engine_state == States.ACCELERATING:
		for spd in engine_index_up:
			if (_speed * 3.6) > spd: 
				speed_index = i
			i += 1
	else:
		for spd in engine_index_down:
			if (_speed * 3.6) > spd: 
				speed_index = i
			i += 1
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
	tachor = min_rad + (max_rad - min_rad) * (tacerpm / max_tac)
	Analometer.rotate_tacho_pt(tachor)
		
func rotate_tacho_ps(tacwrpm: float) -> void:
	var tachor = 0.0
	var min_rad = Analometer.get_min_rad() 
	var max_rad = Analometer.get_max_rad() 
	var max_rot = Analometer.get_max_rot() 
	tachor = min_rad + (max_rad - min_rad) * (tacwrpm / max_rot)
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
