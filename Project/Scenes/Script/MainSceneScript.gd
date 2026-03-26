extends Node3D

@export var DEBUG = false
@export var DEBUG_SHOW = true
var UI: MarginContainer
var vehicle: VehicleBody3D

func _ready():
	vehicle = $Vehicle
	UI = vehicle.get_node("UI")
	if DEBUG:
		var viewport = get_viewport()
		## Use unshaded for tests
		viewport.debug_draw = viewport.DEBUG_DRAW_UNSHADED
		UI.logs_show()
	else:
		UI.logs_hide()
	UI.show_message("Now Drive!")

func _process(_delta):
	if Input.is_action_just_pressed('restore'):
		UI.show_message("Restoring...")
		vehicle.position = Vector3(
			vehicle.position.x + randf() * 2.0 - 1.0,
			vehicle.position.y + randf() * 2.0 + 1.0,
			vehicle.position.z +  randf() * 2.0 - 1.0)
		vehicle.rotation.x = 0.0
		vehicle.rotation.z = 0.0
		vehicle.linear_velocity = Vector3.ZERO
		vehicle.angular_velocity = Vector3.ZERO
		vehicle.constant_force = Vector3.ZERO
		vehicle.constant_torque = Vector3.ZERO
		
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.is_echo():
		use_main_controls(event)

func use_main_controls(_event) -> void:
	if Input.is_action_just_pressed('hide_ui'):
		UI.hide_ui()
	if Input.is_action_just_pressed('help'):
		UI.show_message_again()
	if Input.is_action_just_pressed('Show Info'):
		UI.show_info()
	if Input.is_action_just_pressed('Hide Info'):
		UI.hide_info()
	if Input.is_action_just_pressed('reload'):
		UI.show_message("Reloading...")
		start_scene_reload_timer()
		
	## Change fullscreen (ONLY if Project Propery Run Windowed)
	if Input.is_action_just_pressed('screen'):
		var mode := DisplayServer.window_get_mode()
		var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN \
			if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
	## Toggle between debug draw modes using a key press
	if Input.is_action_just_pressed('viewport'):
		var viewport = get_viewport()
		viewport.debug_draw = (viewport.debug_draw + 1) % 6
		
func _on_timer_timeout():
	# Use call_deferred to safely reload the scene
	get_tree().call_deferred("reload_current_scene")
		
func start_scene_reload_timer(delay: float = 3):
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	# Connect the timeout signal to the reload function
	timer.timeout.connect(_on_timer_timeout) 
	timer.start(delay)
