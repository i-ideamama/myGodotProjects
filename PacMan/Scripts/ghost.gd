extends Sprite

var r_dir_list = [Vector2(1,0), Vector2(0,0), Vector2(-1,0), Vector2(0,-1)]
var direction = r_dir_list[randi()%r_dir_list.size()]

func _physics_process(_delta):
	if direction == Vector2.ZERO:
		direction = r_dir_list[randi()%r_dir_list.size()]
