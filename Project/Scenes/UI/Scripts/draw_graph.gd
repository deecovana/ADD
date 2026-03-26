extends Control

var curve_array: Array
var margin = 10
var graph_width = 150
var graph_height = 150
var curve_point_height = 150

## Draw the curve in the graph box. 
## Input: Array[100] of Curve values
func draw_curve(curve: Array):
	var curve_size = curve.size()
	if curve_size == 0:
		curve_size = 100
	var x_mod = (graph_width) / float(curve_size)
	
	draw_rect(Rect2(
		Vector2(0.0,0.0), Vector2(
			float(graph_width + margin * 2), 
			float(graph_height))), 
		Color.GRAY, false, 2)
		
	for n in (curve.size()-1):
		draw_line(
			Vector2(margin + (n) * x_mod , 
			graph_height - curve[n] * 
			(curve_point_height - margin)), 
			Vector2(margin + (n+1) * x_mod , 
			graph_height - curve[(n+1)] *
			(curve_point_height - margin)), 
			Color.WHEAT, 2)
	
func _draw():
	draw_curve(curve_array)
	
