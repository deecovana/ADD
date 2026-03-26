extends MarginContainer

var logs: RichTextLabel
var PFG: Control 
var message: Label
var help: Label
var topline: Label
var speedometer_label: Label
var digital_speedometer_label: Label
var digital_gear_label: Label
var Analometer: Control
var container: MarginContainer
var RotLeft
var RotRight
var RotLeftA
var RotRightA

func _ready() -> void:
	logs = $VBoxContainer/Info/Logs
	PFG = $MarginContainer/VBoxContainer/PFG
	message = $HBoxContainer/Message
	help = $HBoxContainer/Help
	container = $MarginContainer
	topline = $MarginContainer/Topline
	speedometer_label = $MarginContainer/VBoxContainer/Speedometer/Label
	Analometer = $VBoxContainer/Analometer
	digital_speedometer_label = $VBoxContainer/Analometer/Speed
	digital_gear_label = $VBoxContainer/Analometer/Gear
	RotLeft = $VBoxContainer/VBoxContainer2/Rotation/Left
	RotLeftA = $VBoxContainer/VBoxContainer2/Rotation/LeftA
	RotRight = $VBoxContainer/VBoxContainer2/Rotation/Right
	RotRightA = $VBoxContainer/VBoxContainer2/Rotation/RightA
	
	
func _process(_delta: float) -> void:
	topline.text = (str(Engine.get_frames_per_second())
		+ ' fps [F1] help [F5] restart [F6] view modes [C] camera [H] hide UI')

func call_draw_curve(curve: Array):
	if not PFG:
		PFG = $MarginContainer/VBoxContainer/PFG
	var draw_node = PFG
	draw_node.curve_array = curve
	draw_node.queue_redraw()

func show_message(text):
	if not message:
		message = $HBoxContainer/Message
	message.text = text
	message.show()
	help.show()
	await get_tree().create_timer(2.5).timeout
	message.hide()
	help.hide()
	
func show_message_again():
	message.show()
	help.show()
	await get_tree().create_timer(5).timeout
	message.hide()
	help.hide()
	
func hide_info() -> void:
	logs.visible = !logs.visible
	
func show_info() -> void:
	logs.visible = !logs.visible
	
func show_ui() -> void:
	for e in get_tree().get_nodes_in_group('Torpedos'):
		e.visible = !e.visible
	
func hide_ui() -> void:
	for e in get_tree().get_nodes_in_group('Torpedos'):
		e.visible = !e.visible
	
func set_speedometer_label(text) -> void:
	speedometer_label.text = text
	
func set_digital_speed(text) -> void:
	digital_speedometer_label.text = text
	
func set_digital_gear(text) -> void:
	digital_gear_label.text = text
	
func logs_hide() -> void:
	logs.hide()
	
func logs_show() -> void:
	logs.show()
	
func logs_get() -> RichTextLabel:
	return logs
	
func logs_clr_text() -> void:
	logs.text = ""
	
func logs_add_text(text) -> void:
	logs.text += text
	
func logs_ins_text(text) -> void:
	logs.text = text +\
			logs.text
			
func get_analometer() -> Control:
	return Analometer
	
func rotate_wheel(rot) -> void:
	$Control/Wheel.rotation = rot
	
func set_brake_pedal(val) -> void:
	$VBoxContainer/WheelsRearSleep/Brake.value = val
	
func set_accelerate_pedal(val) -> void:
	$VBoxContainer/WheelsRearSleep/Accelerate.value = val

func set_rotate_alpha(rot,rot_d,vel_a) -> void:
	if rot > 0:
		RotLeft.show()
		RotLeft.text = (rot_d)
		RotRightA.show()
		RotRightA.text = (
			"%s" % (vel_a)
		)
		RotRight.hide()
		RotLeftA.hide()
	else:
		RotRight.show()
		RotRight.text = (rot_d)
		RotLeftA.show()
		RotLeftA.text = (
			"%s" % (vel_a)
		)
		RotLeft.hide()
		RotRightA.hide()
