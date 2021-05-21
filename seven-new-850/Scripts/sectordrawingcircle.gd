extends CanvasItem


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var a1 = 0
var a2 = 0
var draw_sector = false
# Called when the node enters the scene tree for the first time.
func _draw_sector(angStart,angEnd):
	
	draw_sector = true
	a1 = angStart
	a2 = angEnd

func _process(_delta):
	if draw_sector:
		update()


func _draw():

	draw_circle_arc_poly(Vector2(0,0),16,a1,a2,"#c3243a")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)


