extends Timer ## timerDark

@export var step = 0.0005 # Step Frequency
@export var wait_time_sec = 0.0001 # Step TimeOut

@export var power: float = 3.0 ## Affect Light Energy
@export var intensity = 32000 ## Affect Env. Background Light Max
@export var intensity_min = 3200 ## Affect Env. Background Light Min

@export var e_step = 0.15 ## Affect Global Explosure
@export var e_min = 0.5 ## Affect Explosure Minimum

@export var p_norm: float
@export var p_min: float = 0.15 ## Affect Global Sky Nigh Power 

var p: float
var q: float
var sky: WorldEnvironment
var light: DirectionalLight3D
var cam: Camera3D
var gimbal: SpringArm3D
var sun: Sprite3D
var vehicle: VehicleBody3D

func _ready() -> void:
	sky = get_parent()
	cam = get_viewport().get_camera_3d()
	vehicle = get_tree().get_root().find_child("Vehicle")
	light = $"../DirectionalLight3D"
	gimbal = $"../SpringArm3D"
	sun = $"../SpringArm3D/Sun"
	wait_time = wait_time_sec
	autostart = true
	start()
	p_norm = update_sky(p, p * intensity, p_norm, step)

## Update sky and Warp "p" var if p>1
## Added normalization for intensity_min and p_min
func update_sky(_p, _intensity, _p_norm, _step) -> float:
	## Normalize minimums
	if _intensity < intensity_min:
		_intensity = intensity_min
	if _p < p_min:
		_p = p_min
	sky.environment.adjustment_brightness = _p
	sky.environment.adjustment_saturation = _p
	sky.environment.background_energy_multiplier = _p
	var p_e = e_min + _p * e_step
	sky.environment.tonemap_exposure = p_e
	sky.environment.background_intensity = _intensity
	## Warp P if need
	_p_norm += _step
	if  _p_norm >= 1.0:
		_p_norm = -1.0
	return _p_norm

func set_light(_p, _q) -> void:
	light.rotation.x = -p
	light.rotation.y = 2 * q
	light.rotation.z = p - q
	light.light_specular = p
	var sp = (0.5 + p) * (0.5 + p) / 4 + 0.5
	light.light_energy = power * sp
	light.light_indirect_energy = power * sp / 2
	if cam.position:
		var tween = create_tween()
		tween.tween_property(gimbal, "global_position", cam.global_position, wait_time_sec)
		tween.tween_property(gimbal, "global_rotation", light.global_rotation, wait_time_sec)
		light.position = sun.position

func _on_timeout() -> void:
	p = sin( PI * p_norm )
	q = cos( PI * p_norm )
	var sp = (1 + p) * (1 + p) / 4
	p_norm = update_sky(sp, sp * intensity, p_norm, step)
	set_light(p * 2, q * 2)

	
