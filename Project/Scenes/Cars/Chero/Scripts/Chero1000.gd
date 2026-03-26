extends VehicleBody3D

var speedtometer_label
var REVERSE =  false

## Next values used for reconfiguring the Vehicle3Ds values
var car_friction = 0.0
var car_rough = true
var car_bounce = 0.5
var car_absorb = false

@export_category("Vehicle Constants")
## Values for curve Fanta_Curve_1000
## Real maximum 240
@export var vehicle_mass = 1000.0
@export var grav_scale = 1.0
@export var MAX_SPEED = 100.0
@export var MAX_POWER = 6600.0

@export_category("Vector3 Centers")
## (-Z) value (meters) - Move Center Of Mass backward, (-Y): up
@export var CENTER_OF_MASS = Vector3(0.0,-0.03,0.5)
@export var CENTER_OF_AERO = Vector3(0.0,0.3,0.4)

## Additional Forces
@export_category("Body Aero")
## Reset standart Drag and Friction values
var car_linear_damp = 0.0
var car_angular_damp = 0.0
## Setup AirDrag
@export var airDensity = 1.1
@export var bodySquare = 2.0
@export var bodySquareFill = 0.7
@export var bodyDrag = 1.1
## Setup AirDynamic Force
@export var bodyAeroDyn = 0.77

## Add Linear Friction
## Constant and Linear friction
@export var bodyLinearFricConst = 1150.0
@export var bodyLinearFricLin = 10.0
## Squared friction ## 0.0 Because AroDrag used
@export var bodyLinearFricSq = 0.0 ## 0.05

@export_category("Control's move speed")
## Control's move_toward speed
# Use 0..10 for keyboard or controller
# Use 100 for racing wheels
@export var control_speed = 3.5

@export_category("Steering Values")
## Maximum Steering angle in Radians
@export var MAX_STEER  = 0.35
## @NEW To Use speed steering value
@export var SPEED_STEER = true
## Speed Steer Coefficient
@export var SPEED_STEER_CO = 0.15
## Maximum Steering speed
@export var steer_control_speed = 0.45

@export_category("Braking Values")
@export var use_wheel_brake = true
## Maximum Braking speed
@export var brake_control_speed = 0.4
## Vehicle3D body braking force
## Applied with Use Wheel Brake = false
@export var vehicle_brake_force = 100.0
## Wheel3D braking force and balance
@export var wheel_brake_force = 100.0
## wheel_brake_force multiplier
@export var front_brake_force = 1.65
## wheel_brake_force multiplier
@export var rear_brake_force = 1.45
## Brake toward speed
@export var pedal_brake_speed = 1.6
## hand_brake_force multiplier
@export var hand_brake_force = 1.6

@export_category("Coasting")
## Coasting starting value
@export var coast_init = 0.33
## Coasting lerp speed
@export var engine_coast = 0.11

@export_category("Suspension")
## Next values used for reconfiguring the Wheel3Ds values
## Front wheels friction slip ratio ## 0.65
@export var fric_slip_front = 1.6
## Rear wheels friction slip ratio ## 0.65
@export var fric_slip_rear = 1.7
## @HACK Acceleration multiplier for rear slip. Used if NOT accelerating.
@export var fric_slip_rear_hb_mult = 1.5
## Relax must higher than Compression 
@export var damp_compr_front = 5.0
@export var damp_relax_front = 6.0
@export var damp_compr_rear = 3.5
@export var damp_relax_rear = 4.0
## Rest, Travel, Stiff, MaxV
@export var rest_front = 0.11
@export var rest_rear = 0.12
@export var travel_front = 0.12
@export var travel_rear = 0.14
@export var stiff_front = 90
@export var stiff_rear = 60
@export var max_force_front = 18000
@export var max_force_rear = 12000

@export var scale_curve: Curve
var scale_array : Array

enum States { ACCELERATING, BRAKING, COASTING, REVERSING, CHILL}
var engine_state = States.COASTING
enum engine_index_list {Rear, Neutral, First, Second, Third, Fourth, Fifth, Sixth, Seventh, Eighth}
var engine_index: int = 0
var acceleration_power = 0.0
var matching_power = 0.0
var accelerating = 0.0

var root: Node3D
var UI: CanvasLayer
var Analometer: Control
var rem_linear_velocity = Vector3.ZERO

func _ready() -> void:
	UI = $UI
	Analometer = UI.get_analometer()
	
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

	## Apply Max Power to tachometer
	Analometer.set_max_tac(MAX_POWER) 
	
	## Set Center of Mass from CenterOfMass Node
	## Move it Forward to oversteer
	## Backward for understeer but less rear slip
	center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = CENTER_OF_MASS
	
	## Init PFG screen
	for i in 100:
		scale_array.append(scale_curve.sample_baked(i/100.0))
	UI.call_draw_curve(scale_array)
	
func _physics_process(delta: float) -> void:
	
	## Reverse in the simpliest way
	if Input.is_action_just_pressed("reverse"):
		REVERSE = !REVERSE
	
	## To Use speed steering value
	var m_MAX_STEER = MAX_STEER
	if SPEED_STEER and not Input.is_action_pressed("alt_coltrol"):
		m_MAX_STEER = (MAX_SPEED / linear_velocity.length()) \
						* SPEED_STEER_CO * MAX_STEER
		m_MAX_STEER = clamp(m_MAX_STEER, 0.0, MAX_STEER)
	## Use controller's axes, joy or key input
	var _steering = Input.get_axis("steer_right", "steer_left") * m_MAX_STEER
	var _accelerating = Input.get_axis("brake", "accelerate")
	## Simulate axes if keys are used
	if Input.is_action_pressed("steer_right")\
		or Input.is_action_pressed("steer_left"):
			steering = move_toward(steering, _steering, 
			steer_control_speed * delta)
	## @NEW Using Alt Control
	elif not Input.is_action_pressed("alt_coltrol"): 
		## Move linearly
		steering = move_toward(steering, 0.0 , 
			steer_control_speed * delta)
	## Using Brake
	if Input.is_action_pressed("brake"):
		if accelerating > 0: accelerating = 0
		accelerating = move_toward(accelerating, _accelerating, 
			brake_control_speed * control_speed * delta)
	if Input.is_action_pressed("accelerate"):
		accelerating = move_toward(accelerating, _accelerating, 
			control_speed * delta)
								   
	## Set acceleration state @CHANGED
	if _accelerating > 0:
		engine_state = States.ACCELERATING
	## Else: Braking key
	elif _accelerating < 0:
		if engine_state != States.BRAKING:
			## Decrease engine power on state changed
			engine_state = States.BRAKING
			engine_force = engine_force * coast_init
	## Else: Coasting 
	else: 
		if engine_state != States.COASTING:
			## Decrease engine power on state changed
			engine_state = States.COASTING
			engine_force = engine_force * coast_init

	## Process Engine States				
	## Accelerating first
	if engine_state == States.ACCELERATING:
		acceleration_power = MAX_POWER * accelerating
		## Remove REVERSE
		engine_force = abs(engine_force)
		## Match force to scale_curve
		matching_power = engine_match_power(
			linear_velocity.length(), scale_curve)
		## Apply accelerating USING LERP!
		engine_force = lerp(
			engine_force, 
			clamp(matching_power, 0, matching_power), 
			control_speed * delta) 
		## Apply REVERSE
		
	## Than Braking
	if engine_state == States.BRAKING:
		## Slow engine USING LERP!
		engine_force = lerp(engine_force, 0.0, control_speed * delta)
		## Braking with Vehicle3D
		if not use_wheel_brake:
			var set_vehicle_brake_force = - (
				accelerating * vehicle_brake_force )
			change_vehicle_brake(set_vehicle_brake_force, delta)
		## Braking with Wheels
		else:
			var set_wheel_brake_force = \
				- accelerating * vehicle_brake_force
			change_wheel_brake(set_wheel_brake_force, 
				front_brake_force, rear_brake_force)
	else: 
		change_vehicle_brake(0.0, delta)
		change_wheel_brake(0.0, 0.0, 0.0)
		
	## Coasting next
	if engine_state == States.COASTING:
		## Engine coasting toward down USING LERP!
		engine_force = lerp(engine_force, 0.0, engine_coast * delta)
		
	## Reverse last
	if REVERSE and engine_state != States.REVERSING:
		engine_state = States.REVERSING
		## Rear Gear has 30% of maximum power
		engine_force = - clamp(engine_force, 0, MAX_POWER * 0.3)

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
		if engine_state == States.COASTING:
			engine_state = States.CHILL
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
		
	## Update UI
	UI.set_speedometer_label(
		States.keys()[engine_state] + ' ' + engine_index_list.keys()[engine_index])
	rotate_speed_pt(linear_velocity.length() * 3.6)
	rotate_speed_ps(get_delta_velocity(delta), delta)
	rotate_tacho_pt(($Wheel3DRL.get_rpm() + $Wheel3DRR.get_rpm()) / 2)
	rotate_tacho_ps(engine_force, delta)
	
	## @DEBUG UI logs
	UI.logs_clr_text()
	#UI.logs_add_text("\n steering.....: %6.2f" % steering)
	#UI.logs_add_text("\n accelerating.: %6.2f" % accelerating)
	#UI.logs_add_text("\n engine brake.: %6.2f" % brake)
	#UI.logs_add_text("\n wheel f.brake: %6.2f" % $Wheel3Dfl.brake)
	#UI.logs_add_text("\n wheel r.brake: %6.2f" % $Wheel3Drl.brake)
	UI.logs_add_text("\n engine_force.: %8.2f" % engine_force)
	UI.logs_add_text("\n Linear Veloc.: %8.2f" % linear_velocity.length())
	UI.logs_add_text("\n Spd.Max Steer: %8.2f" % m_MAX_STEER)
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
		
func set_engine_index(speed_index) -> void:
	engine_index = speed_index

func rotate_speed_pt(speedf: float) -> void:
	var speedr = 0.0
	var min_rad = Analometer.get_min_rad() 
	var max_rad = Analometer.get_max_rad() 
	var max_spd = Analometer.get_max_spd()
	speedr = min_rad + (
		(max_rad-min_rad) / max_spd
		) * speedf
	Analometer.rotate_speed_pt(speedr)
	
func rotate_tacho_pt(tachof: float) -> void:
	var tachor = 0.0
	var min_rad = Analometer.get_min_rad() 
	var max_rad = Analometer.get_max_rad() 
	var max_rot = Analometer.get_max_rot() 
	tachor = min_rad + (
		(max_rad - min_rad) / max_rot
		) * tachof
	Analometer.rotate_tacho_pt(tachor)
		
func rotate_tacho_ps(tachof: float, delta) -> void:
	var tachor = 0.0
	var min_rad = Analometer.get_min_rad() 
	var max_rad = Analometer.get_max_rad() 
	var max_tac = Analometer.get_max_tac() 
	var tach_ps = Analometer.get_tach_ps() 
	tachor = min_rad + (
		(max_rad - min_rad) / max_tac
		) * tachof
	Analometer.rotate_tacho_ps(
		move_toward(tach_ps, tachor, delta))
	
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
		move_toward(speed_ps, deltavr, delta))

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
