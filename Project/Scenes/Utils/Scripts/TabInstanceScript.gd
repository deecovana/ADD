extends MeshInstance3D

var CurrTime: Label3D
var LastTime: Label3D
var BestTime: Label3D
var BeatTime: Label3D

var CurrTimeValue: float
var LastTimeValue: float
var BestTimeValue: float
var BeatTimeValue: float

func _ready() -> void:
	CurrTime = $CurrTime
	LastTime = $LastTime
	BestTime = $BestTime
	BeatTime = $BeatTime
	SetCurrTime(0.0)
	SetLastTime(0.0)
	SetBestTime(0.0)
	## Spa Short on keyboard CHERO 1.14.30
	## Spa Short on keyboard FANTA 1.14.08
	## Spa Short on keyboard HORSA 1.14.80
	## Spa Long  on keyboard CHERO 3.59.53
	## Spa Long  on keyboard FANTA 4.00.03
	## Spa Long  on keyboard HORSA 3.59.55
	SetBeatTime(74.00)
	
func SetCurrTime(t: float) -> void:
	CurrTimeValue = t
	CurrTime.text = t_to_mst(t)
	
func SetLastTime(t: float) -> void:
	LastTimeValue = t
	LastTime.text = t_to_mst(t)
	
func SetBestTime(t: float) -> void:
	BestTimeValue = t
	BestTime.text = t_to_mst(t)
	
func SetBeatTime(t: float) -> void:
	BeatTimeValue = t
	BeatTime.text = t_to_mst(t)
	
func SetCurrTimeColor(c: Color) -> void:
	CurrTime.modulate = c
	
func SetLastTimeColor(c: Color) -> void:
	LastTime.modulate = c
	
func SetBestTimeColor(c: Color) -> void:
	BestTime.modulate = c
	
func SetBeatTimeColor(c: Color) -> void:
	BeatTime.modulate = c
	
func GetCurrTime() -> float:
	return CurrTimeValue
	
func GetLastTime() -> float:
	return LastTimeValue
	
func GetBestTime() -> float:
	return BestTimeValue
	
func GetBeatTime() -> float:
	return BeatTimeValue
	
func t_to_mst(t: float) -> String:
	var ms = int(t*100) % 100
	var s = int(t) % 60
	var m = int(t/60) % 60
	return "%2d:%02d:%02d" % [m, s, ms]
