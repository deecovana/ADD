extends Node

## Copied from Fanta1000
@onready var _timer: Timer  = $"../Timer"
@onready var _start: AudioStreamPlayer3D  = $"../Start"
@onready var _idle: AudioStreamPlayer3D  = $"../Idle"
@onready var _pow: AudioStreamPlayer3D  = $"../Pow"
@onready var _powR: AudioStreamPlayer3D  = $"../PowR"
@onready var _val: AudioStreamPlayer3D = $"../Val"
var vehicle
var vel
var power
var max_s
var max_p
var snd_start
var rem_engine_index
var vol = -12
## @NEW Engine Index RPM to use GearBox
var eng_rpm = 1.0
var eng_ind_rpm = []
## Sound Scale from velocity, Volume from power
var scale_rpm = 1.0
var twenty_four = 24.0
var sixty_four = 64.0
var eleven = 12
var qwinta = (1.0 + 5.0/12.0)

func _ready():
	vehicle = get_parent()
	print(var_to_str(vehicle))
	
	max_s = vehicle.MAX_SPEED
	max_p = vehicle.MAX_POWER
	snd_start = max_s / twenty_four
	_pow.volume_db = -sixty_four
	_powR.volume_db = -sixty_four
	_val.volume_db = -sixty_four
	_pow.play()
	_powR.play()
	_val.play()
	_start.play()
	_timer.start()
	_timer.connect("timeout", on_timer_timeout)
	## @NEW Engine Index RPM to use GearBox
	eng_ind_rpm = vehicle.eng_ind_rpm
	
func _physics_process(_delta: float) -> void:
	vel = abs(vehicle.get_local_velocity().z)
	vol = scale_rpm * abs(vehicle.ACCELERATING) * (
		vehicle.engine_force / max_p
		)
	
	## Get Engine Index RPM to use GearBox
	scale_rpm = vehicle.s_scale_rpm
	## Fix sound's overscale when gearing down
	if scale_rpm >= 1.0:
		scale_rpm = lerp(1.0, scale_rpm, _delta)
	
	if (rem_engine_index != vehicle.engine_index
		and not $"../Gear".playing):
		rem_engine_index = vehicle.engine_index
		$"../Gear".play()
		if (not vehicle.ACCELERATING > 0 
				and not $"../GearAir".playing 
				and randf() > 0.5):
			$"../GearAir".play()
	
	## Start sounds
	if not _start.playing and not _idle.playing:
		_idle.play()
	
	var vel_start = abs(
		vehicle.get_local_velocity().z
		) * eng_ind_rpm.min()
	if vel_start > snd_start:
		var d = _delta * eleven
		## Pitches Lerp
		_idle.pitch_scale = lerp(scale_rpm, scale_rpm, d)
		_pow.pitch_scale = lerp(_pow.pitch_scale, scale_rpm * qwinta, d)
		_powR.pitch_scale = lerp(_powR.pitch_scale, scale_rpm * qwinta, d)
		_val.pitch_scale = lerp(_val.pitch_scale, vel / vehicle.MAX_SPEED / 2, d)
		## Volumes Lerp
		_pow.volume_db = lerp(_pow.volume_db, (vol * twenty_four - twenty_four), d)
		_powR.volume_db = lerp(_powR.volume_db, (vol * twenty_four - twenty_four), d)
		var v = lerp(_val.volume_db, clamp(vel, -twenty_four, -_pow.volume_db), d)
		_val.volume_db = v
	
	## Randomise loops
	if randf() > 0.9:
		_idle.play()
	if randf() > 0.9:
		_pow.play()
	if randf() > 0.9:
		_powR.play()
	if randf() > 0.9:
		_val.play()

func on_timer_timeout():
	_start.stop()
	_idle.play()
