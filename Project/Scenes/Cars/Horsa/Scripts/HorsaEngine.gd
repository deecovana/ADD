extends Node

## Copied from Fanta1000
@onready var _timer = $"../Timer"
@onready var _start = $"../Start"
@onready var _idle = $"../Idle"
@onready var _pow = $"../Pow"
@onready var _run = $"../Run"
var vehicle
var vel
var power
var max_s
var max_p
var snd_start
var rem_engine_index
var vol = -0.6
## @NEW Engine Index RPM to use GearBox
var eng_rpm = 1.0
var eng_ind_rpm = []
## Sound Scale from velocity, Volume from power
var scale_rpm = 1.0

func _ready():
	vehicle = $".."
	max_s = vehicle.MAX_SPEED
	max_p = vehicle.MAX_POWER
	snd_start = max_s / 32
	_pow.volume_db = -24.0
	_run.volume_db = -24.0
	_timer.connect("timeout", on_timer_timeout)
	_start.play()
	_timer.start()
	## @NEW Engine Index RPM to use GearBox
	eng_ind_rpm = vehicle.eng_ind_rpm
	
func _physics_process(_delta: float) -> void:
	vel = vehicle.linear_velocity.length() * eng_ind_rpm.min() * 2
	power = vehicle.engine_force
						
	vol = power / max_p
	## @NEW Engine Index RPM to use GearBox
	scale_rpm = vehicle.scale_rpm
	
	if (rem_engine_index != vehicle.engine_index
		and not $"../Gear".playing):
		rem_engine_index = vehicle.engine_index
		$"../Gear".play()
	
	if not _start.playing and not _idle.playing:
		_idle.play()
	if not _start.playing and not _pow.playing:
		_pow.play()
	if not _start.playing and not _run.playing:
		_run.play()
	if vel > snd_start:
		_idle.pitch_scale = scale_rpm * 1.2
		_pow.pitch_scale = scale_rpm * 0.8
		_pow.volume_db = clamp(vol * 24 - 24, -24.0, 0.0)
		var vl = vehicle.linear_velocity.length()/vehicle.MAX_SPEED
		_run.pitch_scale = (2 + vl)
		_run.volume_db = clamp(
			(vl * abs(vehicle.ACCELERATING)) * 24 - 24, -24.0, -12.0)
	## Randomise loops
	if randf() > 0.9: _idle.play()
	if randf() > 0.9: _pow.play()

func on_timer_timeout():
	_start.stop()
	_idle.play()
